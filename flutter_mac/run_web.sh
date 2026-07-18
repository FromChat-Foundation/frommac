#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
export PATH="$HOME/flutter/bin:$PATH"

cd "$ROOT"
flutter pub get
dart run sqflite_common_ffi_web:setup
chmod +x tool/run_web.sh
exec ./tool/run_web.sh
