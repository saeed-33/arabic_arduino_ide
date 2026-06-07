# Step 17: Learning Block Groups

## Goal

Organize Learning Mode blocks into numbered groups and add a dedicated group for functions created by the user.

## Implemented

Added:

- `LearningBlockGroup`
- grouped palette structure in `LearningWorkspaceController`
- grouped palette UI in `LearningModePage`

## Current Groups

```text
1. البداية والتكرار
2. المتغيرات
3. الأوامر
4. الشروط
5. توابع المستخدم
```

## User Functions Group

Group 5 is dedicated to user-created functions.

Current placeholder blocks:

- `تعريف تابع`
- `استدعاء تابع`

These are not editable yet. Parameter editing and real user-defined function management should come in a later step.

## Preview Rule

Code preview remains optional.

The generated source is still shown only after pressing:

```text
معاينة الكود
```

It is not shown permanently.

## Still Not Implemented

- drag and drop
- editable block parameters
- creating multiple named user functions
- validating block placement
- sending generated source to Pro Mode
- analyzing Learning Mode output with the compiler

## Help Section Update

The Help section now explains that Learning Mode blocks are grouped and numbered.

## Next Step Suggestion

Step 18 should add editable parameters for blocks:

- variable name
- initial value
- delay value
- print text
- user function name
