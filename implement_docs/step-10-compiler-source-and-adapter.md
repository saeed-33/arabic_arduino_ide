# Step 10: Compiler Source And Adapter Contract

## Goal

Import the provided compiler source and define a clean adapter boundary so Developer Mode can consume compiler diagnostics later without coupling UI widgets directly to compiler internals.

## Imported Compiler Source

The provided archive was imported into:

```text
compiler/ArduinoArabicCompiler/
```

Imported files:

- `ArArduinoLexer.g4`
- `ArArduinoParser.g4`
- `requirements.txt`
- `test.txt`
- `parse tree.png`

## Compiler Type

The imported source is ANTLR/Python-oriented.

Python requirements:

```text
antlr4-python3-runtime==4.13.2
llvmlite==0.47.0
```

## Adapter Contract

Added:

- `CompilerDiagnosticsAdapter`
- `MockCompilerDiagnosticsAdapter`
- `CompilerDiagnosticsSnapshot`

The adapter accepts source code and returns structured diagnostics:

- status message
- parse tree
- AST
- tokens
- raw diagnostics
- generated code lines
- build stages
- internal logs

## Current Runtime Behavior

The Flutter app does not execute the compiler yet.

Developer Mode currently uses `MockCompilerDiagnosticsAdapter`, which reports that compiler source is available but the runtime bridge is not connected.

## Integration Boundary

The real compiler should be connected through an adapter/service layer.

The UI should not directly call:

- ANTLR generated classes.
- Python scripts.
- compiler internals.
- file-system compiler implementation details.

## Future Runtime Options

Possible integration choices:

- Run the Python compiler as a subprocess.
- Generate a Dart parser from grammar if feasible.
- Package the compiler as a local executable.
- Run the compiler as a local service process.

This decision should be made after the provided compiler has an executable entry point.

## Help And Requirements Updates

Technical requirements now list the provided compiler source and Python dependencies.

The main requirements file records that the compiler source is imported but not executable from Flutter yet.

## Next Step Suggestion

Step 11 should inspect or add a compiler entry point:

- Identify how to run lexer/parser from command line.
- Generate parser artifacts if needed.
- Define JSON output format for diagnostics.
- Keep Flutter integration behind `CompilerDiagnosticsAdapter`.
