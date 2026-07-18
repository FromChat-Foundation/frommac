#!/usr/bin/env python3
"""DEV-only CORS proxy via curl (urllib hangs on some VPN/fake-ip setups)."""

from __future__ import annotations

import argparse
import json
import subprocess
import tempfile
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

DEFAULT_UPSTREAM = "https://api.fromchat.ru"
DEFAULT_PORT = 8787


class ProxyState:
    upstream = DEFAULT_UPSTREAM


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt: str, *args) -> None:
        print(f"[proxy] {self.command} {self.path}")

    def _cors(self) -> None:
        origin = self.headers.get("Origin", "*")
        self.send_header("Access-Control-Allow-Origin", origin)
        self.send_header("Access-Control-Allow-Credentials", "true")
        self.send_header(
            "Access-Control-Allow-Headers",
            self.headers.get(
                "Access-Control-Request-Headers",
                "Authorization, Content-Type, Accept, X-Requested-With",
            ),
        )
        self.send_header(
            "Access-Control-Allow-Methods",
            "GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD",
        )
        self.send_header(
            "Access-Control-Expose-Headers",
            "*, X-FromChat-Instance-Id",
        )
        self.send_header("Vary", "Origin")

    def do_OPTIONS(self) -> None:  # noqa: N802
        self.send_response(204)
        self._cors()
        self.end_headers()

    def do_GET(self) -> None:  # noqa: N802
        if self.path.split("?", 1)[0] in ("/__health", "/healthz"):
            body = b'{"ok":true,"proxy":"fromchat-dev"}'
            self.send_response(200)
            self._cors()
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        self._forward()

    def do_POST(self) -> None:  # noqa: N802
        self._forward()

    def do_PUT(self) -> None:  # noqa: N802
        self._forward()

    def do_PATCH(self) -> None:  # noqa: N802
        self._forward()

    def do_DELETE(self) -> None:  # noqa: N802
        self._forward()

    def do_HEAD(self) -> None:  # noqa: N802
        self._forward()

    def _forward(self) -> None:
        url = f"{ProxyState.upstream}{self.path}"
        length = int(self.headers.get("Content-Length", "0") or "0")
        body = self.rfile.read(length) if length > 0 else b""

        with tempfile.TemporaryDirectory() as tmp:
            body_path = Path(tmp) / "body"
            hdr_path = Path(tmp) / "hdr"
            out_path = Path(tmp) / "out"
            if body:
                body_path.write_bytes(body)

            cmd = [
                "curl",
                "-sS",
                "-m",
                "45",
                "-X",
                self.command,
                "-D",
                str(hdr_path),
                "-o",
                str(out_path),
                "-w",
                "%{http_code}",
                "-H",
                "Accept: application/json",
                "-H",
                "User-Agent: FromChat-Dev-CORS-Proxy/2.0",
            ]
            auth = self.headers.get("Authorization")
            if auth:
                cmd.extend(["-H", f"Authorization: {auth}"])
            ctype = self.headers.get("Content-Type")
            if ctype:
                cmd.extend(["-H", f"Content-Type: {ctype}"])
            if body:
                cmd.extend(["--data-binary", f"@{body_path}"])
            cmd.append(url)

            try:
                proc = subprocess.run(
                    cmd,
                    check=False,
                    capture_output=True,
                    text=True,
                )
            except FileNotFoundError:
                self._fail(502, "curl not found on PATH")
                return

            if proc.returncode != 0 and not out_path.exists():
                err = (proc.stderr or proc.stdout or "curl failed").strip()
                print(f"[proxy] UPSTREAM FAIL {self.path}: {err}")
                self._fail(502, f"upstream curl failed: {err}")
                return

            status = int(proc.stdout.strip() or "502")
            raw_headers = hdr_path.read_text(encoding="utf-8", errors="replace")
            data = out_path.read_bytes() if out_path.exists() else b""

            self.send_response(status)
            self._cors()
            # Forward useful upstream headers
            for line in raw_headers.splitlines():
                if ":" not in line:
                    continue
                name, value = line.split(":", 1)
                lname = name.strip().lower()
                if lname in ("content-type", "x-fromchat-instance-id"):
                    self.send_header(name.strip(), value.strip())
            self.send_header("Content-Length", str(len(data)))
            self.end_headers()
            if self.command != "HEAD":
                self.wfile.write(data)

    def _fail(self, code: int, message: str) -> None:
        payload = json.dumps({"error": message}).encode()
        self.send_response(code)
        self._cors()
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)


def main() -> None:
    parser = argparse.ArgumentParser(description="FromChat DEV CORS proxy")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT)
    parser.add_argument("--upstream", default=DEFAULT_UPSTREAM)
    args = parser.parse_args()
    ProxyState.upstream = args.upstream.rstrip("/")
    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    print(f"DEV CORS proxy  http://127.0.0.1:{args.port}  ->  {ProxyState.upstream}", flush=True)
    print("Health: http://127.0.0.1:%d/__health" % args.port, flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nstopped")


if __name__ == "__main__":
    main()
