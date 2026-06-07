# Step 18: Compiler Dictionary Code Generation

## Goal

Make Learning Mode generated snippets follow the actual compiler grammar dictionary.

## Compiler Source Of Truth

Learning Mode generation should follow:

- `compiler/ArduinoArabicCompiler/ArArduinoLexer.g4`
- `compiler/ArduinoArabicCompiler/ArArduinoParser.g4`

## Important Rule

A token existing in the lexer is not enough.

The generated code must also be accepted by parser rules.

Example:

- `PRINT : 'اكتب' ;` exists in the lexer.
- But the current parser `statement` rule does not accept `PRINT` directly.
- Therefore Learning Mode should not generate `اكتب("مرحبا")؛` as a standalone statement.

## Implemented Change

The old learning block:

```text
اكتب("مرحبا")؛
```

was replaced with:

```text
كتابة_تسلسلية("مرحبا")؛
```

This is an identifier-based function call, so it matches:

```text
idStatement SEMI
```

inside compiler blocks.

## Current Limitation

Learning Mode still generates snippets independently. A later step should generate a complete valid program structure and place statement blocks inside `دالة إعداد` or `دالة حلقة`.

## Next Step Suggestion

Step 19 should add block placement rules:

- declarations at top level
- setup/loop/function blocks at top level
- statements only inside function bodies
