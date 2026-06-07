# Step 24 - Learning Puzzle Blocks

## Goal

Make Learning Mode blocks feel more educational by changing the visual style from plain cards to puzzle-like blocks.

## Changes

- Palette blocks now use a puzzle-like shell.
- Workspace blocks use the same puzzle visual language.
- Drag feedback keeps the puzzle block shape while dragging.
- Each puzzle block uses the color of its group.
- The information tip remains inside the block.

## Architecture Notes

- `_PuzzleBlockShell` is the shared visual wrapper for block surfaces.
- `_PaletteBlockSurface` renders palette-specific actions inside the puzzle shell.
- `_WorkspacePuzzleBlock` renders workspace-specific numbering and delete action inside the puzzle shell.
- The controller and generated code path were not changed.

## Current Limits

- The puzzle shape is visual only.
- Blocks still append to the program when dropped.
- Existing workspace blocks cannot be reordered or nested yet.
