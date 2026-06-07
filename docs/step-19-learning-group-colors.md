# Step 19: Learning Group Colors

## Goal

Make Learning Mode block groups easier to scan by giving each group a fixed name and color, and removing group numbers from the UI.

## Implemented

Removed group numbers from:

- `LearningBlockGroup`
- Learning Mode palette UI

Added:

- `LearningBlockGroupColor`
- fixed color marker per group

## Current Groups

- `البداية والتكرار`
- `المتغيرات`
- `الأوامر`
- `الشروط`
- `توابع المستخدم`

## Color Purpose

Colors are visual identifiers only.

They do not affect code generation or compiler behavior.

## Preview Rule

Code preview remains optional and appears only when the user presses:

```text
معاينة الكود
```

## Next Step Suggestion

Step 20 should add placement rules for blocks:

- declarations at top level
- statements inside functions
- educational warnings for invalid placement
