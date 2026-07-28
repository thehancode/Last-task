# Last Task

Last Task is a local-first Flutter task manager. It currently targets Linux
desktop, Windows desktop, web, and Android from one codebase.

## Run

```sh
flutter pub get
flutter run -d linux
flutter run -d windows
flutter run -d chrome
flutter run -d android
```

## Backend build environments

`env/development.json` targets the local backend (`localhost:8080`; Android
emulators use `10.0.2.2:8080`). `env/production.json` targets
`https://lasttask-api.hancode.ai` on every supported platform.

Use the matching file whenever building or running with the backend:

```sh
flutter run -d linux --dart-define-from-file=env/development.json
flutter build web --dart-define-from-file=env/production.json
scripts/install-linux.sh --production
```

## Local data

Linux deliberately uses the existing Rust location:

```text
$XDG_DATA_HOME/tui-kanban/tasklists/
# or ~/.local/share/tui-kanban/tasklists/
```

Windows uses its product-specific roaming application-support directory:

```text
%APPDATA%\com.tuikanban\Last Task\tasklists\
```

Android uses private application-support storage. Web uses browser IndexedDB.
All targets persist one schema-version-1 JSON-compatible task-list document per
list. Do not run the Rust application and the Flutter Linux application at the
same time: they use the same files and do not coordinate writes.

Linux, Windows, and web use the terminal presentation. Android uses the
touch-oriented Material presentation.

## Architecture

`lib/domain` contains immutable models and repository contracts.
`lib/data` contains JSON/local-store implementations. `lib/presentation`
contains Riverpod MVVM workspace state and widgets. Widgets do not access files
or IndexedDB directly.

The former Rust implementation and its migration notes are preserved on the
`legacy-rust` branch.
