# Step 25 - Scratch-Like Learning Blocks

## Goal

Make Learning Mode blocks cleaner and closer to Scratch/App Inventor style.

## Changes

- Removed the information icon from block surfaces.
- The tooltip now appears when hovering anywhere on the block.
- The tooltip still includes:
  - Block placement level.
  - Block purpose.
- The block shape now uses a stronger Scratch-like body with top and bottom connector shapes.
- Palette, drag feedback, and workspace blocks use the same visual shell.

## Architecture Notes

- `_PuzzleBlockShell` owns tooltip behavior for the whole block.
- `_ScratchBlockPainter` draws the block body and connector-like shape.
- Palette and workspace widgets only provide block-specific content and actions.
- No generated-code or compiler behavior changed.

## Current Limits

- The connector shape is visual only.
- Dropping a block still appends it to the program.
- Existing blocks cannot be reordered or nested yet.
