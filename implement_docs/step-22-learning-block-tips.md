# Step 22 - Learning Block Tips

## Goal

Reduce visual noise in Learning Mode blocks by moving block explanations into tooltips.

## Changes

- Block descriptions are no longer shown as permanent text on each block.
- Each block now shows a small information control.
- The tooltip includes:
  - The block placement level.
  - The purpose of the block.
- The cleaner block surface keeps the horizontal layout easier to scan.

## Architecture Notes

- `LearningBlockDefinition.description` remains the source of the block purpose text.
- `LearningBlockPlacement` remains the source of placement-level text.
- The UI renders both fields through `_BlockTipButton`.
- No generated-code behavior changed.

## Current Limits

- Tooltips are hover/focus based.
- There is no mobile touch behavior because the app scope is Windows desktop only.
