# Step 8: Developer Mode Shell

## Goal

Add a separate Developer Mode shell for advanced diagnostics without building the real lexer, parser, compiler, or upload pipeline yet.

## Implemented

Added navigation item:

- `المطور`

Added feature folder:

```text
IDE/lib/features/developer_mode/
```

## Developer Mode Tabs

Developer Mode currently includes placeholder tabs for:

- AST
- Tokens
- Raw Errors
- Friendly Errors
- Generated Code
- Pipeline
- Internal Logs
- Environment

## Placeholder Data

The shell uses temporary diagnostic data:

- Example AST tree.
- Example token stream.
- Example raw diagnostic.
- Example friendly error preview.
- Example generated Arduino/C++ preview.
- Example build stages.
- Example internal logs.
- Current environment placeholders.

## Architecture

Developer Mode is split by responsibility:

- `developer_mode_page.dart`
  - UI layout and panels.
- `DeveloperDiagnosticsController`
  - Temporary diagnostics source.
- Domain models:
  - `AstNodeInfo`
  - `TokenInfo`
  - `RawDiagnostic`
  - `BuildStageInfo`

## Design Boundary

Developer Mode is for language/toolchain developers.

It can expose advanced details such as raw diagnostics, AST nodes, token streams, and generated code. Pro Mode and Kids Mode should remain learner-focused and should not expose raw internals by default.

## Still Not Implemented

- Real lexer.
- Real parser.
- Real AST from editor content.
- Semantic analysis.
- Friendly diagnostic generation.
- Arabic-to-Arduino/C++ code generation.
- Arduino CLI compile/upload.
- Device environment probing.

## Help Section Update

The Help section now explains that Developer Mode is a diagnostics shell for developers.

## Next Step Suggestion

Step 9 should start the language core outside the UI:

- Create a `language` feature or package boundary.
- Define token types.
- Implement a small lexer for the current sample language.
- Add tests for Arabic keywords and numbers.
- Feed real token output into Developer Mode.
