# Arduino Arabic Compiler Snapshot

This folder contains the compiler source snapshot provided to the IDE project.

Imported files:

- `ArArduinoLexer.g4`
- `ArArduinoParser.g4`
- `requirements.txt`
- `test.txt`
- `parse tree.png`

Current status:

- The source appears to be an ANTLR grammar package.
- Python runtime dependencies are listed in `requirements.txt`.
- The Flutter IDE executes `run_diagnostics.py` through the Developer Mode adapter.
- The current compiler snapshot emits tokens, parse tree, raw syntax errors, and build stages.
- The current compiler snapshot does not emit AST or generated Arduino/C++ code yet.

Integration rule:

Do not couple Flutter UI widgets directly to these compiler files. Use an adapter/service boundary that translates compiler output into Developer Mode domain models.

## Setup

Run once from this folder:

```powershell
.\setup.ps1
```

This creates `.venv` and installs `requirements.txt`.

## Diagnostics Runner

Analyze the sample file:

```powershell
.\.venv\Scripts\python.exe run_diagnostics.py --file test.txt
```

Analyze inline source:

```powershell
.\.venv\Scripts\python.exe run_diagnostics.py --source "متغير ليد : صحيح = 9؛"
```
