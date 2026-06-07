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

Current Step 13 compiler readiness baseline:

- Compiler process output is decoded as UTF-8 to preserve Arabic text.
- Developer Mode checks compiler runtime readiness.
- Runtime checks include Python, `.venv`, `antlr4`, and `llvmlite`.
- Developer Mode Environment tab shows setup command when runtime is not ready.
- The IDE does not run setup automatically.

Current Step 14 developer diagnostics usability baseline:

- Developer Mode shows summary counts for tokens, diagnostics, parse tree nodes, and runtime status.
- Parse Tree supports search/filter.
- Long parse tree node text is compacted in the UI.
- Raw error messages wrap instead of stretching across the screen.

Current Step 15 friendly errors baseline:

- Friendly Errors maps raw compiler diagnostics into Arabic educational messages.
- Raw Errors remains unchanged for developer inspection.
- Mapping is display logic only; compiler behavior is not duplicated or modified.
- Friendly messages include title, explanation, location, and suggested fix.

### Kids Mode

The second mode to build after Pro Mode is complete.

Planned features:

- Drag-and-drop blocks.
- Scratch/App Inventor-like learning flow.
- Convert blocks into Arabic Arduino code.
- Beginner-friendly labels and guidance.

Current Step 16 learning mode shell baseline:

- Learning Mode has a block palette.
- Learning Mode has a workspace/program area.
- Users can add, remove, and clear blocks.
- Source preview is optional and appears only after pressing `معاينة الكود`.
- No permanent live source preview.
- No drag/drop yet.
- No compiler analysis from Learning Mode yet.

Current Step 17 learning block groups baseline:

- Learning block palette is split into named colored groups.
- Current groups are:
  - start and loop
  - variables
  - commands
  - conditions
  - user functions
- User functions group exists with define/call function placeholders.
- Preview remains optional and is not shown permanently.

Current group display baseline:

- Group numbers are not shown.
- Each group has a fixed name and color.

Current compiler dictionary generation baseline:

- Learning Mode generated code should follow `ArArduinoLexer.g4` and `ArArduinoParser.g4`.
- Top-level generated snippets use valid declarations such as `متغير` and `دالة`.
- Statement snippets should be valid inside compiler blocks.
- Keywords that exist in the lexer but are not accepted by parser statement rules should not be generated as standalone statements.

Current Step 20 learning block styling baseline:

- Each learning block uses the fixed color of its parent group.
- Palette blocks and workspace blocks have a clearer rounded visual shape.
- Blocks show whether they belong at program level or inside a function.
- Optional code preview can include educational placement warnings.
- Placement warnings do not replace compiler diagnostics and do not add a separate parser.

Current Step 21 learning tabs baseline:

- Learning Mode shows one block group at a time instead of all groups at once.
- Group tabs are horizontal and placed at the bottom of the block library.
- Each group tab uses the fixed color of its group.
- Blocks inside the selected group are arranged horizontally.
- Program assembly blocks are arranged horizontally with horizontal scrolling.

Current Step 22 learning block tips baseline:

- Block descriptions are not shown permanently on the block surface.
- Each block shows an information tip control.
- The tip includes the block placement level.
- The tip includes the block purpose.
- This is a UI presentation change only; generated code and compiler integration are unchanged.

Current Step 23 learning drag/drop baseline:

- The full block library appears horizontally at the bottom of Learning Mode.
- The program workspace appears above the block library.
- Palette blocks can be dragged from the library.
- The program workspace accepts dropped palette blocks and adds them to the program.
- The add button remains available as a simple fallback.
- Drag/drop only adds blocks; reordering existing program blocks is not implemented yet.

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
