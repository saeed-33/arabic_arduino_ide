# Step 27 - Learning Program Structure And Top Navigation

## Goal

Make the learning workspace match the expected Arduino structure and move app navigation to the top of the screen.

## Changes

- App sections are now shown in a horizontal top navigation bar.
- Learning Mode starts with two required Arduino functions:
  - `initialize / إعداد`
  - `loop / حلقة`
- Learning Mode now has a right-side program outline panel.
- The outline panel lists current functions.
- The outline panel lists global variables.
- The outline panel can add a user function.
- The outline panel can add a global variable.
- Required functions can be restored from the outline panel if deleted.
- Horizontal block lists use right-to-left ordering.

## Architecture Notes

- `LearningWorkspaceController` initializes the base program structure.
- The controller owns function/global creation methods.
- `_ProgramOutlinePanel` is UI-only and delegates mutations to the controller.
- The app shell owns top-level section navigation.
- Generated code still comes from the existing nested block tree.

## Current Limits

- User function names are still placeholder values.
- Global variable names are still placeholder values.
- Existing workspace blocks are not yet draggable for reordering.
- The compiler remains the source of final language validation.
