# Arabic Arduino IDE Requirements

## Product Scope

Build a small Windows-only IDE for an Arabic Arduino learning language.

The IDE is designed for learners between 7 and 18 years old. It should stay simple, friendly, and focused on learning Arduino programming without overwhelming users.

## Primary Language And Direction

- Arabic-first interface.
- Right-to-left layout by default.
- Arabic labels, help text, output, and learning guidance.
- Pro Mode supports writing code using Arabic characters.

## Modes

### Pro Mode

The first mode to build. It will grow into a simple text-editor-based IDE for Arabic Arduino code.

Planned features:

- Arabic code editor.
- Terminal.
- Output panel.
- Logs panel.
- Run.
- Debug.
- Restart.
- Settings.
- Connected devices.
- Install tools.
- File actions:
  - New file.
  - Open file.
  - Close file.
  - Save file.
- Help section.

Current Step 2 layout baseline:

- Top command bar.
- Main editor region placeholder.
- Bottom output/logs region placeholder.
- Side devices/tools panel placeholder.
- No real editor, terminal, compiler, debugger, or device logic yet.

Current Step 3 editor baseline:

- Editable Arabic code area.
- RTL text entry.
- Initial Arabic Arduino sample code.
- Simple unsaved-change state when the editor text changes.
- File buttons are still visual placeholders only.
- No parser, compiler, terminal, debugger, save/open, or device logic yet.

Current Step 4 file baseline:

- New file clears the editor and starts an unnamed buffer.
- Open loads local `.arabic`, `.ino`, or `.txt` files.
- Save writes the current editor content to the selected local file.
- Existing opened/saved files save back to the same path.
- Editor header shows the current file name and save state.
- Run, debug, terminal, compiler, and device behavior are still not implemented.

Technical documentation baseline:

- `docs/technical-requirements.md` tracks toolchain, libraries, versions, platform constraints, and architecture rules.
- Native Flutter desktop plugins require a full app restart/rebuild after being added.
- File platform behavior should live outside UI widgets to preserve separation of concerns.

Current Step 5 output/log baseline:

- File actions write structured log entries.
- Output panel shows the newest status.
- Output panel shows a scrollable log list.
- Logs can be cleared from the output panel.
- Pro Mode separates UI, session state, file service, and log model.
- Run, debug, terminal execution, compiler, and device behavior are still not implemented.

Current Step 6 run/debug feedback baseline:

- Run, stop, restart, and debug buttons write clear Arabic status/log messages.
- These actions are intentionally inactive placeholders.
- No compiler, terminal process, board detection, upload, or debug engine exists yet.

Current Step 7 settings baseline:

- Settings model exists for Arduino CLI path, default board, serial port, and libraries server URL.
- Settings controller keeps values in memory only.
- Settings UI exposes Arabic fields for the current configuration placeholders.
- No persistence, validation, device detection, toolchain install, or server connection yet.

Current Step 8 developer mode baseline:

- Developer Mode shell exists as a separate feature.
- Navigation includes `المطور`.
- Developer Mode contains placeholder tabs for parse tree, AST, tokens, raw errors, friendly errors, generated code, build pipeline, internal logs, and environment.
- No real lexer, parser, semantic analyzer, code generator, compiler, or device integration yet.

Compiler integration note:

- The compiler will be provided later by the project owner.
- Developer Mode should be ready to display compiler/parser outputs without coupling UI widgets directly to compiler internals.
- Parse Tree should preserve grammar structure, while AST should represent the simplified semantic tree.

Current compiler import baseline:

- Provided compiler source is stored under `compiler/ArduinoArabicCompiler`.
- Compiler source contains ANTLR lexer/parser grammar files and Python requirements.
- Developer Mode has a `CompilerDiagnosticsAdapter` contract.
- Current adapter runs `run_diagnostics.py` and maps compiler JSON into Developer Mode.
- Developer Mode diagnostics should come from compiler output, not duplicated IDE parsing logic.
- Current compiler output includes tokens, parse tree, raw diagnostics, build stages, and internal logs.
- AST and generated Arduino/C++ code are shown as unavailable until the compiler emits them.

Current Step 12 source analysis baseline:

- Arabic language files use the `.arabic` extension.
- Developer Mode can analyze the current Pro Mode editor source.
- `تحليل الكود` runs the compiler diagnostics adapter against the current editor text.
- Developer Mode continues to display compiler output only, without duplicating compiler logic in the IDE.

### Kids Mode

The second mode to build after Pro Mode is complete.

Planned features:

- Drag-and-drop blocks.
- Scratch/App Inventor-like learning flow.
- Convert blocks into Arabic Arduino code.
- Beginner-friendly labels and guidance.

## Libraries

The IDE should later support adding libraries from a server. The server and protocol will be designed in a later step.

## Platform

- Windows only.
- Flutter desktop app.
- No Android, iOS, web, macOS, or Linux target in the first scope.

## Documentation Rule

Every completed step must add or update documentation under `docs/`.

## Help Rule

The in-app help section must be updated after every completed feature step.

## Commit Rule

Each completed step should be committed to Git.
