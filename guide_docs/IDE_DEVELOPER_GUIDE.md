# Arabic Arduino IDE — Developer Guide

> A comprehensive guide for developers who want to run, understand, extend, or contribute to the **Flutter-based Arabic Arduino IDE** in the `IDE/` directory.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What You Will Build](#2-what-you-will-build)
3. [Prerequisites](#3-prerequisites)
4. [Getting Started](#4-getting-started)
5. [Project Structure](#5-project-structure)
6. [Architecture Deep Dive](#6-architecture-deep-dive)
7. [Feature Areas You Can Develop](#7-feature-areas-you-can-develop)
8. [Step-by-Step Development Workflows](#8-step-by-step-development-workflows)
9. [Code Style and Conventions](#9-code-style-and-conventions)
10. [Testing Strategy](#10-testing-strategy)
11. [Troubleshooting](#11-troubleshooting)
12. [Performance and Best Practices](#12-performance-and-best-practices)
13. [Security and Safety Notes](#13-security-and-safety-notes)
14. [FAQ](#14-faq)
15. [References and Next Steps](#15-references-and-next-steps)

---

## 1. Introduction

The `IDE/` directory contains a **Flutter desktop application** that teaches and supports Arduino programming in Arabic. Unlike a generic code editor, this IDE is built specifically for an Arabic-speaking audience:

- The entire UI is **right-to-left (RTL)**.
- Code keywords and built-ins can be written in **Arabic**.
- The IDE integrates with the custom **Arabic Arduino Compiler** to compile and flash programs.
- It provides multiple learning levels: Pro Mode, Kids Mode, Learning Mode, and Developer Mode.

This guide explains how to set up the project, how the code is organized, and where to add new features.

---

## 2. What You Will Build

As an IDE developer, you are building the user-facing shell of the Arabic Arduino ecosystem. Your work connects students, hobbyists, and makers to the Arabic Arduino Compiler and real Arduino hardware.

### User journeys

1. A student opens the IDE, switches to **Kids Mode**, drags blocks, and sees generated Arabic code.
2. A hobbyist writes Arabic Arduino code in **Pro Mode**, clicks "تشغيل" (Run), and sees compiler output.
3. A teacher opens **Developer Mode** to inspect tokens, AST, and LLVM IR for a lesson.
4. A user connects an Arduino Uno, selects the COM port, and clicks "رفع إلى اللوحة" (Upload).

---

## 3. Prerequisites

### Required

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x or newer
- Windows 10/11 with desktop development support
- Git

### Recommended

- Visual Studio 2022 with C++ desktop workload (for Windows builds)
- VS Code with the Flutter and Dart extensions
- An Arduino Uno or compatible ATmega328P board for end-to-end testing

### Optional but useful

- The Python compiler set up in `ArduinoArabicCompiler/` (to test compile/flash flows)
- `arduino-cli` or `avrdude` installed (the IDE can also use the compiler's bundled toolchain)

---

## 4. Getting Started

All commands below assume your terminal is inside the `IDE/` directory.

### 4.1 Clone and enter the workspace

If you haven't already:

```bash
cd IDE/
```

### 4.2 Install Flutter dependencies

```bash
flutter pub get
```

This downloads packages such as `file_selector`, `shared_preferences`, and `cupertino_icons`.

### 4.3 Enable Windows desktop (if not already)

```bash
flutter config --enable-windows-desktop
```

### 4.4 Analyze the project

```bash
flutter analyze
```

Fix any lint errors before running.

### 4.5 Run the app

```bash
flutter run -d windows
```

The first build may take several minutes because Flutter compiles the C++ runner.

### 4.6 Build a release version

```bash
flutter build windows
```

Output: `build/windows/x64/runner/Release/arabic_arduino_ide.exe`

### 4.7 Run tests

```bash
flutter test
```

---

## 5. Project Structure

```text
IDE/
├── lib/
│   ├── main.dart                              # App entry point
│   ├── app/
│   │   ├── arabic_arduino_app.dart            # MaterialApp + RTL wrapping
│   │   ├── home_shell.dart                    # NavigationRail + section switching
│   │   ├── app_theme.dart                     # Theme configuration
│   │   └── app_persistence.dart               # SharedPreferences wrapper
│   └── features/
│       ├── pro_mode/
│       │   ├── pro_mode_page.dart             # Main pro-mode UI
│       │   ├── application/
│       │   │   ├── pro_mode_session_controller.dart
│       │   │   ├── pro_mode_compiler_adapter.dart
│       │   │   └── pro_mode_file_service.dart
│       │   └── domain/
│       │       ├── pro_mode_log_entry.dart
│       │       └── serial_log_entry.dart
│       ├── kids_mode/
│       │   └── kids_mode_page.dart
│       ├── learning_mode/
│       │   ├── learning_mode_page.dart
│       │   ├── application/
│       │   │   └── learning_workspace_controller.dart
│       │   └── domain/
│       │       └── learning_block_definition.dart
│       ├── developer_mode/
│       │   ├── developer_mode_page.dart
│       │   └── application/
│       │       ├── compiler_diagnostics_adapter.dart
│       │       ├── developer_diagnostics_controller.dart
│       │       └── friendly_diagnostic_mapper.dart
│       │   └── domain/
│       │       ├── ast_node_info.dart
│       │       ├── build_stage_info.dart
│       │       ├── compiler_diagnostics_snapshot.dart
│       │       ├── compiler_runtime_status.dart
│       │       ├── friendly_diagnostic.dart
│       │       ├── parse_tree_node_info.dart
│       │       ├── raw_diagnostic.dart
│       │       └── token_info.dart
│       ├── settings/
│       │   ├── settings_page.dart
│       │   ├── application/
│       │   │   └── settings_controller.dart
│       │   └── domain/
│       │       └── ide_settings.dart
│       └── help/
│           └── help_page.dart
├── pubspec.yaml
├── analysis_options.yaml
├── windows/                                   # CMake + Windows runner
└── README.md
```

### Folder philosophy

Each feature is self-contained:

- `application/` — controllers and service adapters (business logic)
- `domain/` — pure data classes and enums
- `<feature>_page.dart` — the UI widget

This makes it easy to find, test, and replace individual features.

---

## 6. Architecture Deep Dive

### 6.1 State management

The IDE does not use a global state library like Provider or Riverpod. Instead, it uses:

- `ChangeNotifier` controllers in `application/` folders.
- `AnimatedBuilder` / `ListenableBuilder` in widgets to rebuild on changes.
- `IndexedStack` in `HomeShell` to preserve state when switching sections.

Example flow:

```text
User types in editor
   ↓
TextEditingController notifies listener
   ↓
ProModeSessionController updates _hasUnsavedChanges
   ↓
notifyListeners()
   ↓
AnimatedBuilder in ProModePage rebuilds header trailing text
```

### 6.2 Right-to-left (RTL) layout

The app is wrapped in:

```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: HomeShell(...),
)
```

This makes Material widgets render in Arabic reading order. Some widgets (line numbers, code editor) override directionality locally to LTR where needed.

### 6.3 Compiler integration

The IDE shells out to the Python compiler through `ProModeCompilerAdapter`:

```text
Pro Mode "تشغيل" button
   ↓
ProModeSessionController.runProgram()
   ↓
ProModeCompilerAdapter.compileSource(source)
   ↓
Process.run('python', ['.../ArduinoArabicCompiler/main.py', tempFile])
   ↓
stdout/stderr parsed → logs, diagnostics, IR/ASM panels
```

This is the golden rule: **the IDE is a shell, the compiler is the engine.** The IDE should render compiler outputs, not reimplement compiler logic.

### 6.4 File persistence

`AppPersistence` wraps `shared_preferences` and is injected into controllers. It stores:

- Last open file path
- Editor font size
- Serial port and baud rate
- Theme preference
- Window size (if implemented)

### 6.5 Key controllers

| Controller | Responsibility |
|------------|----------------|
| `ProModeSessionController` | Editor state, file I/O, compiler runs, serial monitor, flashing |
| `ProModeCompilerAdapter` | Subprocess communication with the Python compiler |
| `ProModeFileService` | Open/save dialogs and file reading/writing |
| `SettingsController` | Load/save user preferences |
| `DeveloperDiagnosticsController` | Prepare and display compiler diagnostics in Developer Mode |
| `LearningWorkspaceController` | Block workspace state for Kids/Learning Mode |

---

## 7. Feature Areas You Can Develop

### 7.1 Pro Mode editor

`pro_mode_page.dart` contains a fully custom code editor with:

- Syntax highlighting for Arabic and C++/Arduino keywords
- Line number gutter synced to editor scroll
- RTL text input
- Custom arrow-key navigation to handle mixed-direction text

**Enhancement ideas:**

- **Auto-completion**: query compiler tokens or a static keyword list and show a popup.
- **Error squiggles**: parse compiler diagnostics and underline lines/columns.
- **Code folding**: add collapsible regions for functions and loops.
- **Find/replace**: a toolbar overlay with Arabic-aware search.
- **Better Arabic font**: bundle a monospace Arabic font (e.g., `Cascadia Code` + `Noto Sans Arabic`).
- **Minimap**: a scaled-down code overview on the right.
- **Multiple tabs**: open several files at once.

### 7.2 Compiler integration

`pro_mode_compiler_adapter.dart` is the bridge to the compiler.

**Enhancement ideas:**

- Parse structured JSON diagnostics from the compiler (if/when available).
- Show a progress panel for each pipeline stage: lexer → parser → semantic → IR → optimizer → linker.
- Display raw LLVM IR, optimized LLVM IR, and AVR assembly in read-only panels.
- Show flash and RAM usage after a successful build.
- Add a "Stop" button to kill a long-running compiler subprocess.
- Support compiling to a temporary file instead of relying on `test_arduino.txt`.

### 7.3 Serial monitor

The bottom panel has placeholders for a serial monitor.

**Enhancement ideas:**

- Read serial output from the board and display it in a scrollable panel.
- Send text from the IDE to the board.
- Support common baud rates (9600, 115200, etc.).
- Add timestamps and auto-scroll.
- Release the port before flashing.

### 7.4 Device tools panel

The right panel shows port selection and flash/upload buttons.

**Enhancement ideas:**

- Auto-detect connected boards with FQBN and core info.
- Show board name, port, and core version.
- Add a board picker (Uno, Nano, Mega, etc.).
- Show upload progress and success/failure state.

### 7.5 Developer Mode

`developer_mode_page.dart` is designed to expose compiler internals.

**Enhancement ideas:**

- Render the token stream as a table with type, text, line, and column.
- Render the parse tree as an expandable tree.
- Render the AST as a graph or interactive tree.
- Show raw and optimized LLVM IR side-by-side.
- Map AST nodes back to source lines on click.
- Show friendly explanations for compiler errors.

### 7.6 Kids / Learning Mode

These modes are currently starter pages.

**Enhancement ideas:**

- Drag-and-drop block editor (similar to Scratch or Blockly).
- Generate Arabic text code from blocks.
- Step-by-step lessons with goals and validation.
- Simulated Arduino board on screen before hardware is available.
- Badges and progress tracking.

### 7.7 Settings

`settings_page.dart` and `ide_settings.dart` manage preferences.

**Enhancement ideas:**

- Dark / light / system theme toggle.
- Editor font family and size.
- Default serial baud rate.
- Compiler executable path.
- UI language (Arabic / English).
- Auto-save interval.

### 7.8 Cross-platform support

Currently Windows-only.

**Enhancement ideas:**

- Enable Linux and macOS targets (`flutter build linux`, `flutter build macos`).
- Responsive layout for tablets.
- Mobile phone layout (compact navigation).

### 7.9 Accessibility

**Enhancement ideas:**

- High-contrast theme.
- Screen-reader labels for all buttons.
- Keyboard-only navigation.
- Font scaling support.

---

## 8. Step-by-Step Development Workflows

### 8.1 Add a new settings option

1. **Domain model**: Add a field to `features/settings/domain/ide_settings.dart`.
2. **Controller**: Add load/save logic in `features/settings/application/settings_controller.dart`.
3. **UI**: Add a control in `features/settings/settings_page.dart`.
4. **Usage**: Read the value from `SettingsController` wherever it is needed.

### 8.2 Add a new main section

1. Open `app/home_shell.dart`.
2. Add a value to the `AppSection` enum.
3. Add a `NavigationRailDestination` to the `destinations` list.
4. Add the corresponding page widget to the `IndexedStack` children.
5. Create the new page under `features/<new_section>/`.

### 8.3 Change compiler adapter behavior

1. Open `features/pro_mode/application/pro_mode_compiler_adapter.dart`.
2. Keep the public method signatures stable.
3. Return a structured result object (exit code, stdout, stderr, artifacts).
4. Update `ProModeSessionController` to consume the new fields.

### 8.4 Add a keyboard shortcut

1. Obtain or create a `FocusNode`.
2. Set `focusNode.onKeyEvent = _handleKeyEvent`.
3. Check `event.logicalKey` and return `KeyEventResult.handled` when consumed.
4. See `_ArabicCodeEditor._handleKeyEvent` for a working example.

### 8.5 Add a new IDE log level

1. Add a value to `ProModeLogLevel` in `domain/pro_mode_log_entry.dart`.
2. Update `_colorForLevel` and `_iconForLevel` in `pro_mode_page.dart`.
3. Update any switch statements that enumerate log levels.

---

## 9. Code Style and Conventions

### 9.1 Folder structure

Follow the existing feature-based layout:

```text
features/<name>/
├── application/       # Controllers and service adapters
├── domain/            # Data classes and enums
└── <name>_page.dart   # UI
```

### 9.2 Naming

- Widgets: `PascalCase` ending with `Page`, `Widget`, or `Panel`.
- Controllers: `PascalCase` ending with `Controller`.
- Files: `snake_case` matching the class name.
- User-facing strings: Arabic, RTL-aware.
- Code identifiers: English, following Dart conventions.

### 9.3 UI strings

- Prefer Arabic labels for buttons, titles, and status messages.
- Keep labels concise because Arabic text can be longer than English.
- Use tooltips for additional context.

### 9.4 State

- Controllers own mutable state.
- Pages are as stateless as possible.
- Always call `notifyListeners()` after state changes.
- Dispose controllers, scroll controllers, focus nodes, and text controllers.

### 9.5 Imports

- Order: Dart SDK, Flutter packages, third-party packages, project files.
- Use relative imports within a feature; absolute imports across features if preferred.

---

## 10. Testing Strategy

| Test type | Command | When to run |
|-----------|---------|-------------|
| Static analysis | `flutter analyze` | Before every commit |
| Unit/widget tests | `flutter test` | Before every commit |
| Manual smoke test | `flutter run -d windows` | While developing UI |
| Integration with compiler | Trigger Run in Pro Mode | When changing compiler adapter |
| Hardware test | Connect Arduino and Flash | Before releasing |

### 10.1 Writing widget tests

Use `WidgetTester` to pump pages with mock controllers:

```dart
testWidgets('ProModePage shows compile button', (tester) async {
  final controller = ProModeSessionController();
  await tester.pumpWidget(
    MaterialApp(home: ProModePage(controller: controller)),
  );
  expect(find.text('تشغيل'), findsOneWidget);
});
```

### 10.2 Writing controller tests

Controllers are plain `ChangeNotifier` classes, so you can unit test them directly:

```dart
test('saving marks file as not dirty', () async {
  final controller = ProModeSessionController();
  controller.editorController.text = 'modified';
  expect(controller.hasUnsavedChanges, isTrue);
  // mock file service and save...
});
```

---

## 11. Troubleshooting

| Problem | Likely Cause | Solution |
|---------|--------------|----------|
| `flutter run` cannot find Windows device | Windows desktop not enabled or MSVC missing | `flutter config --enable-windows-desktop`; install Visual Studio C++ workload |
| Build fails with CMake errors | Missing Windows SDK or Visual Studio | Repair Visual Studio installation |
| Arabic text appears reversed | Missing RTL directionality | Ensure widget tree has `Directionality(rtl)` |
| Code editor cursor jumps | Custom key handler conflict | Review `_handleKeyEvent` and focus scope |
| Compiler output not shown | Wrong compiler path or subprocess error | Check `ProModeCompilerAdapter` path and logs |
| Serial port list empty | No board connected or missing driver | Connect Arduino; install CH340/CP210x driver if clone board |
| SharedPreferences throws on desktop | Plugin not initialized | `WidgetsFlutterBinding.ensureInitialized()` in `main()` |
| Hot reload not working | Code in `main.dart` changed | Hot restart instead (`R` in terminal) |

---

## 12. Performance and Best Practices

- Debounce expensive operations like syntax highlighting or compiler calls.
- Run compiler subprocesses asynchronously; never block the UI thread.
- Use `ListView.builder` for long log lists.
- Avoid rebuilding the entire editor on every keystroke; target only the status line.
- Dispose all controllers and listeners to prevent memory leaks.
- Profile with Flutter DevTools when adding complex widgets.

---

## 13. Security and Safety Notes

- The IDE runs user-provided code through the compiler. Never execute generated code directly on the host machine.
- Compiler subprocess output should be parsed defensively; malformed output should not crash the IDE.
- Do not hardcode API keys, passwords, or absolute paths.
- When flashing hardware, confirm the selected port with the user to avoid bricking other serial devices.
- If adding cloud features (AI mentor, lesson sync), keep credentials in environment variables or secure storage.

---

## 14. FAQ

**Q: Can I run the IDE without the Python compiler?**
A: Yes, the IDE will launch, but compile/run/flash features will fail unless the compiler path is configured or the compiler is present.

**Q: Why is the app RTL by default?**
A: Arabic is the primary language. LTR widgets (line numbers, code) override directionality locally.

**Q: Can I add an English UI option?**
A: Yes. Add a language setting and conditionally choose strings. This is a planned enhancement.

**Q: How do I add a new Arduino board?**
A: Most board support is in the compiler's backend and toolchain. The IDE only needs to list the board and pass the correct FQBN/port to the compiler.

**Q: Where should I put utility widgets shared across features?**
A: Create a `lib/core/` or `lib/shared/` directory for reusable widgets, but keep feature-specific widgets inside their feature folder.

---

## 15. References and Next Steps

- `IDE/README.md` — project README
- `IDE/analysis_options.yaml` — lint rules
- `ArduinoArabicCompiler/docs/IDE_INTEGRATION_GUIDE.md` — compiler integration contract
- `ArduinoArabicCompiler/AGENTS.md` — compiler architecture
- [Flutter Windows desktop](https://docs.flutter.dev/platform-integration/windows/building)
- [Flutter RTL support](https://docs.flutter.dev/development/ui/layout/text-input)

---

## Quick Checklist for New Contributors

- [ ] `flutter pub get` succeeds.
- [ ] `flutter analyze` passes with no errors.
- [ ] `flutter run -d windows` launches the app.
- [ ] You can type Arabic code in Pro Mode.
- [ ] You can open and save a file.
- [ ] You understand which controller owns the state you are changing.
- [ ] You have read the compiler integration guide if changing compiler-related code.

Happy building! 🛠️
