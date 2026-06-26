# Step 12: Pro Source To Developer Analysis

## Goal

Connect the current Pro Mode editor source to Developer Mode diagnostics, and standardize the Arabic language file extension as `.arabic`.

## Implemented

Developer Mode now has a button:

- `تحليل الكود`

When clicked, it sends the current Pro Mode editor text to:

- `ArduinoArabicCompilerDiagnosticsAdapter`

The adapter runs the compiler diagnostics runner and maps compiler JSON output into Developer Mode panels.

## Source Sharing

`HomeShell` now owns the Pro Mode session controller.

This keeps the editor state alive when switching between:

- Pro Mode
- Developer Mode
- Help
- Settings

Developer Mode receives source through a small `sourceProvider` callback instead of directly owning Pro Mode internals.

## File Extension Change

The language file extension is now:

```text
.arabic
```

Updated behavior:

- Save dialog suggests `برنامج_عربي.arabic`.
- Open dialog accepts `.arabic`, `.ino`, and `.txt`.

## Compiler Boundary

Developer Mode does not implement separate lexer/parser logic.

It displays compiler output from:

- `run_diagnostics.py`

Current compiler output:

- tokens
- parse tree
- raw diagnostics
- build stages
- internal logs

AST and generated Arduino/C++ remain unavailable until the compiler emits them.

## Help And Requirements Updates

Updated:

- Help section.
- Main requirements.
- Technical requirements.
- Step 4 file-action documentation.

## Next Step Suggestion

Step 13 should improve compiler runtime readiness:

- detect missing Python/runtime dependencies from the IDE
- show setup instructions in Developer Mode
- add a `إعداد المترجم` action that points to `setup.ps1`
