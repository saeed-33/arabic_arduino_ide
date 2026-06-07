# Step 16: Learning Mode Shell

## Goal

Start the learning mode experience with a simple block-based shell for children and beginners.

## User Requirement

The code preview must be optional.

The IDE should not show generated source permanently. The learner should press a button when they want to see the generated Arabic code.

## Implemented

Added feature folder:

```text
IDE/lib/features/learning_mode/
```

Added:

- `LearningBlockDefinition`
- `LearningProgramBlock`
- `LearningWorkspaceController`
- `LearningModePage`

The existing `KidsModePage` now delegates to `LearningModePage` for compatibility with current navigation.

## UI

Learning Mode now has:

- block palette
- program workspace
- add block buttons
- remove block buttons
- clear workspace button
- optional preview button

## Optional Preview

The preview is shown only after clicking:

```text
معاينة الكود
```

The generated source appears in a dialog and is not permanently visible on the screen.

## Initial Blocks

The first shell includes simple placeholder blocks:

- `متغير رقم`
- `دالة إعداد`
- `دالة حلقة`
- `اكتب`
- `انتظر`
- `إذا`

These blocks generate simple Arabic source snippets. Drag/drop and structural validation are not implemented yet.

## Still Not Implemented

- drag and drop
- block nesting
- block parameter editing
- validation against compiler grammar
- sending generated source to Pro Mode
- analyzing generated source in Developer Mode
- learner-friendly compiler feedback inside Learning Mode

## Help Section Update

The Help section now explains that Learning Mode has a block palette and optional code preview.

## Next Step Suggestion

Step 17 should add editable block parameters:

- variable name
- numeric values
- delay amount
- text for `اكتب`
- simple validation before preview
