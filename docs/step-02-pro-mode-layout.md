# Step 2: Pro Mode Layout

## Goal

Create the first real Pro Mode workspace layout without adding editor, terminal, compiler, debugger, or device logic.

## Implemented UI

The Pro Mode screen now contains:

- Top command bar.
- Main editor placeholder.
- Bottom output/logs placeholder.
- Side devices/tools panel.

## Command Bar

The command bar includes Arabic action placeholders:

- `ملف جديد`
- `فتح`
- `حفظ`
- `تشغيل`
- `إيقاف`
- `إعادة تشغيل`
- `تصحيح`

These buttons do not perform actions yet. They reserve the intended workflow positions for later steps.

## Workspace Regions

### Editor

The editor area is currently a placeholder. The real Arabic code editor will be added in a later step.

### Output And Logs

The bottom panel reserves space for:

- Run output.
- Error messages.
- Build logs.
- Debug messages.

### Devices And Tools

The side panel reserves space for:

- Connected Arduino devices.
- Selected board.
- Install/upload tools.

## Help Section Update

The Help section now explains that Pro Mode contains the first workspace structure:

- Command bar.
- Editor area.
- Output and logs.
- Devices and tools.

## Design Decision

The layout is intentionally simple because the target users are learners aged 7 to 18. The interface should reveal the IDE concepts gradually instead of exposing all advanced controls at once.

## Next Step Suggestion

Step 3 should add the first lightweight Arabic editor component:

- Editable text area.
- RTL typing.
- Monospace-like readable code font.
- Unsaved-file state.
- No parser or compiler yet.
