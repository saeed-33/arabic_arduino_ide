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
- The Flutter IDE does not execute this compiler yet.
- Developer Mode reads compiler-shaped mock diagnostics through a Dart adapter contract.

Integration rule:

Do not couple Flutter UI widgets directly to these compiler files. Use an adapter/service boundary that translates compiler output into Developer Mode domain models.
