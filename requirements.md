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
- Open loads local `.arab`, `.ino`, or `.txt` files.
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
