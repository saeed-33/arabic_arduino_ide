# Step 13: Compiler Runtime Readiness

## Goal

Fix Arabic mojibake from compiler output and show whether the local compiler runtime is ready before analysis.

## Bug Fixed

Developer Mode displayed corrupted Arabic text in Parse Tree output.

Cause:

- Flutter/Dart was reading Python process stdout using the platform default encoding.
- The compiler emits UTF-8 JSON.
- Arabic text was decoded incorrectly before JSON mapping.

Fix:

- `Process.run` now uses:
  - `stdoutEncoding: utf8`
  - `stderrEncoding: utf8`

## Runtime Checks

Developer Mode now checks:

- compiler folder exists
- Python can run
- local `.venv` exists
- `antlr4` can be imported
- `llvmlite` can be imported

## Environment Panel

The Developer Mode Environment tab now shows:

- Runtime ready
- Python
- Virtual env
- ANTLR runtime
- llvmlite
- Setup command

## Setup Command

The IDE shows the setup command but does not run it automatically:

```powershell
cd compiler/ArduinoArabicCompiler
.\setup.ps1
```

## Compiler Boundary

The IDE still does not implement compiler logic.

All diagnostics remain compiler-driven through:

- `run_diagnostics.py`
- `ArduinoArabicCompilerDiagnosticsAdapter`

## Verification

The compiler runner, Flutter analysis, tests, and Windows build should pass after this step.

## Next Step Suggestion

Step 14 should improve Developer Mode usability:

- limit very large parse tree rendering
- add search/filter in Parse Tree
- add token count and diagnostic count summaries
