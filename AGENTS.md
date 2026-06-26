# AGENTS.md — arabic_arduino_ide workspace

This workspace contains two distinct projects:

- `IDE/` — a Flutter application for the Arabic Arduino IDE.
- `arduino_arabic_compiler/ArduinoArabicCompiler/` — a Python-based Arabic-aware Arduino compiler and AVR toolchain support.

## Use this file as the top-level entrypoint for AI coding agents

Do not assume the repository is a single Flutter app.
Use the project-specific docs and subproject `AGENTS.md` when available.

## Primary project areas

1. `IDE/`
   - Flutter/Dart application.
   - Main entry point: `IDE/lib/main.dart`.
   - Flutter Windows desktop support via `IDE/windows/CMakeLists.txt`.
   - Use `IDE/README.md` and `IDE/analysis_options.yaml` for local IDE conventions.

2. `arduino_arabic_compiler/ArduinoArabicCompiler/`
   - Python 3 compiler pipeline for Arabic Arduino-style source.
   - Compiler driver: `main.py`.
   - Build helper: `build.py`.
   - Compiler architecture docs and workflow are captured in `arduino_arabic_compiler/ArduinoArabicCompiler/AGENTS.md`.

## Build and development workflows

### Flutter IDE

- `flutter pub get`
- `flutter run -d windows`
- `flutter analyze`
- `flutter test` (if tests are added)

### Arabic Arduino compiler

- Create a venv and install dependencies from `arduino_arabic_compiler/ArduinoArabicCompiler/requirements.txt`.
- `python build.py compile`
- `python build.py test`
- `python build.py setup`
- `python build.py link`
- `python build.py flash`

## Key documentation

- `IDE/README.md` — Flutter app startup and workspace orientation.
- `arduino_arabic_compiler/ArduinoArabicCompiler/AGENTS.md` — detailed compiler architecture, build commands, and known risks.
- `docs/*.md` — product and user-interface design goals for the Arabic IDE.
- `arduino_arabic_compiler/ArduinoArabicCompiler/docs/IDE_INTEGRATION_GUIDE.md` — compiler integration hooks and IDE expectations.

## Agent guidance

- Keep instructions minimal and actionable.
- Prefer linking to existing docs instead of duplicating them.
- When changing the compiler, read `arduino_arabic_compiler/ArduinoArabicCompiler/AGENTS.md` first.
- When changing the IDE, read `IDE/README.md`, `docs/*.md`, and Flutter entry files.
- Respect the multi-project structure: do not mix Flutter changes with Python compiler changes unless the task explicitly requires both.

## Important repo notes

- The compiler uses Arabic language keywords and normalization logic in `normlize.py`.
- `main.py` in the compiler subproject currently hardcodes `test_arduino.txt`.
- The Flutter app is currently in a starter-state; its top-level README is generic.
- There is no repository-level CI defined outside the compiler subproject.
