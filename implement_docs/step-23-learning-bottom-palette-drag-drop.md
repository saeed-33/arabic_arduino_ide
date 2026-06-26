# Step 23 - Bottom Palette Drag And Drop

## Goal

Move the Learning Mode block library to the bottom of the screen and add basic drag/drop block insertion.

## Changes

- The workspace is now the primary area above the block library.
- The full block library appears horizontally at the bottom of Learning Mode.
- The selected group still uses bottom horizontal tabs inside the palette.
- Palette blocks can be dragged.
- The workspace accepts dropped palette blocks and adds them to the program.
- The add button remains available for users who prefer clicking.

## Architecture Notes

- `_LearningBlockDragData` carries the selected block and its group color during drag/drop.
- `_BlockPalette` remains responsible for group selection and palette rendering.
- `_WorkspacePanel` owns the drop target surface only.
- `LearningWorkspaceController.addBlock` remains the single path for adding blocks to the program.

## Current Limits

- Existing workspace blocks cannot be reordered yet.
- Blocks cannot be nested yet.
- Drop placement currently appends the block to the end of the program.
- Compiler integration and generated source are unchanged.
