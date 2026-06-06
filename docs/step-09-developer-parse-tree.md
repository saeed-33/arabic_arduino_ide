# Step 9: Developer Parse Tree

## Goal

Add a Parse Tree view to Developer Mode so compiler/parser output can be inspected later without mixing grammar diagnostics into learner-facing screens.

## Implemented

Developer Mode now includes a dedicated tab:

- `Parse Tree`

The tab appears before `AST` because parse trees usually come directly from parsing, while ASTs are simplified for semantic analysis and code generation.

## Placeholder Model

Added:

- `ParseTreeNodeInfo`

Fields:

- `rule`
- `text`
- `line`
- `column`
- `children`

## Placeholder Data

The current parse tree mirrors the sample Arabic Arduino code shape:

- `program`
- `setup_block`
- `pin_mode_statement`
- `loop_block`
- `digital_write_statement`
- `delay_statement`

This is temporary data. The real compiler/parser will provide actual parse-tree output later.

## Compiler Handoff Boundary

The compiler will be provided later by the project owner.

Developer Mode should consume structured outputs from that compiler:

- Parse tree.
- AST.
- Tokens.
- Raw diagnostics.
- Generated code.
- Build stages.

UI widgets should not depend directly on compiler internals. A controller/adapter should translate compiler output into Developer Mode domain models.

## Help Section Update

The Help section now mentions Parse Tree as part of Developer Mode diagnostics.

## Next Step Suggestion

Step 10 should define the compiler adapter contract:

- Input Arabic source text.
- Output tokens.
- Output parse tree.
- Output AST.
- Output raw diagnostics.
- Output generated code.

The adapter can start with mock data until the real compiler is delivered.
