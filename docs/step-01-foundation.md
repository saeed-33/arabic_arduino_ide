# Step 1: Foundation

## Goal

Create the project foundation for a Windows-only Flutter IDE that teaches Arabic Arduino programming.

## Approved Notes

- Create a GitHub repository for the project.
- Keep the first UI very simple.
- Do not add terminal or editor logic in Step 1.
- Use Flutter.
- Target Windows only.
- Use Arabic and right-to-left layout from the beginning.
- Separate the project architecture early so future steps stay organized.

## Folder Structure

```text
arabic_arduino_ide/
  docs/
    step-01-foundation.md
  IDE/
    lib/
      app/
      features/
        help/
        kids_mode/
        pro_mode/
        settings/
      shared/
  requirements.md
```

## Suggested Architecture

The app uses a small feature-first architecture:

- `lib/app/`
  - App entry shell, global theme, navigation, and layout direction.
- `lib/features/pro_mode/`
  - Future Pro Mode editor, file handling, run/debug controls, output, logs, devices, and install tools.
- `lib/features/kids_mode/`
  - Future block-based learning environment.
- `lib/features/help/`
  - Arabic help content, updated after each step.
- `lib/features/settings/`
  - Future app, language, server, board, and toolchain settings.
- `lib/shared/`
  - Reusable UI and utilities shared across features.

This keeps the app simple now while giving each major IDE area a clear place to grow.

## Initial UI

Step 1 creates a simple Arabic RTL shell with:

- App title: `بيئة أردوينو العربية`.
- Navigation for:
  - `المحترف`
  - `التعلم`
  - `مساعدة`
  - `إعدادات`
- Placeholder panels only. No editor, terminal, device, or compiler logic yet.

## Help Section Update

The initial help section explains:

- What the IDE is.
- What Pro Mode will become.
- What Kids Mode will become.

## Next Step Suggestion

Step 2 should build the Pro Mode layout without implementing deep editor logic yet:

- Top command bar.
- Empty editor region.
- Bottom output/log placeholder.
- Side devices/tools placeholder.
- Basic menu structure for files and help.
