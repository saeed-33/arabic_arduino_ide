# Step 21 - Learning Tabs And Horizontal Flow

## Goal

Make the Learning Mode block library easier to scan by replacing the full group list with bottom tabs.

## Changes

- The block library now shows one selected group at a time.
- Group tabs are horizontal and placed at the bottom of the library panel.
- Each tab uses the fixed color of its group.
- Blocks inside the selected group are arranged horizontally.
- Program assembly blocks are arranged horizontally in the workspace.

## Architecture Notes

- `_BlockPalette` owns only the selected group index.
- `LearningWorkspaceController` remains responsible for block data and workspace state.
- Group colors still come from `LearningBlockGroupColor`; UI widgets only map the enum to visual colors.
- No compiler, parser, or drag/drop logic was added in this step.

## Current Limits

- Tabs are click-based and do not yet support keyboard shortcuts.
- Horizontal program assembly is visual only; nested block placement is still planned for a later step.
- Blocks are still added through the add button.
