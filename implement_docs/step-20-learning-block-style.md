# Step 20 - Learning Block Styling

## Goal

Improve the visual quality of Learning Mode blocks while keeping the feature simple and compiler-aligned.

## Changes

- Palette blocks now use the color of their parent group.
- Workspace blocks keep the same group color after being added.
- Block cards use a clearer visual shape with a colored side marker and light tinted background.
- Blocks show a placement label:
  - Program level.
  - Inside a function.
- Optional code preview can show educational placement warnings.

## Placement Rules

- Program-level blocks:
  - Variables.
  - Setup function.
  - Loop function.
  - User function definition.
- Function-body blocks:
  - Text output command.
  - Delay command.
  - If condition.
  - User function call.

## Architecture Notes

- `LearningBlockDefinition` owns static block metadata such as kind, generated code, and placement.
- `LearningProgramBlock` stores the selected block plus the group color used when it was added.
- `LearningWorkspaceController` owns workspace state and preview warning generation.
- `LearningModePage` only renders the palette, workspace, and preview dialog.

## Current Limits

- Blocks are still added and removed by button.
- Drag and drop is not implemented yet.
- Placement warnings are educational UI guidance only.
- The IDE still does not duplicate compiler parsing logic.
