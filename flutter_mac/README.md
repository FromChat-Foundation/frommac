# FromChat Flutter client (macOS + web)

## DEV web (без Xcode, через CORS-прокси)

`api.fromchat.ru` не пускает `localhost` по CORS. Для разработки поднимаем локальный proxy:

```bash
export PATH="$HOME/flutter/bin:$PATH"
cd flutter_mac
flutter pub get
# один раз:
dart run sqflite_common_ffi_web:setup

chmod +x tool/run_web.sh
./tool/run_web.sh
```

Скрипт:
1. стартует `tool/cors_proxy.py` на `http://127.0.0.1:8787`
2. запускает Chrome с `--dart-define=FROMCHAT_WEB_PROXY=127.0.0.1:8787`

Вручную двумя терминалами:

```bash
python3 tool/cors_proxy.py
flutter run -d chrome --dart-define=FROMCHAT_WEB_PROXY=127.0.0.1:8787
```

Прокси только для DEV. В проде web должен жить на origin, который сервер уже разрешает.

## Native macOS

Нужен полный Xcode: `flutter run -d macos` (CORS не нужен).
