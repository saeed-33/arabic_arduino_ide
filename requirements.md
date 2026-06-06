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
