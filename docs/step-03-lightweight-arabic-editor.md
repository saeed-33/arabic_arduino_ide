# Step 3: Lightweight Arabic Editor

## Goal

Add the first real editable code area to Pro Mode while keeping the IDE simple and avoiding compiler, parser, terminal, and file-system behavior for now.

## Implemented

The Pro Mode editor placeholder is now an editable Arabic text area.

The editor supports:

- Right-to-left writing.
- Multi-line input.
- A readable code-style font.
- Initial Arabic Arduino sample code.
- Simple unsaved-change state.

## Initial Sample Code

The editor starts with a small blinking LED style example written in Arabic:

```text
ابدأ
  اجعل المنفذ 13 مخرج

كرر دائما
  شغّل المنفذ 13
  انتظر 1000
  أطفئ المنفذ 13
  انتظر 1000
نهاية
```

This is sample language text only. It is not parsed or compiled yet.

## Unsaved State

When the user changes the editor text, the editor header changes from:

- `محفوظ مؤقتا`

to:

- `تغييرات غير محفوظة`

This state is local to the current session. Real save/open behavior will be added later.

## Still Not Implemented

- Real save.
- Real open.
- File tabs.
- Syntax highlighting.
- Parser.
- Compiler.
- Upload to Arduino.
- Terminal behavior.
- Debug behavior.

## Help Section Update

The Help section now explains that the editor is editable and that unsaved-change tracking is only temporary until file handling is built.

## Next Step Suggestion

Step 4 should add basic file state and file command behavior:

- New file clears/replaces editor content.
- Save writes to a chosen local file.
- Open loads a local file into the editor.
- Editor header shows file name.
