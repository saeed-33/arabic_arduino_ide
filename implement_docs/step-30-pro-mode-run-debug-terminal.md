# Step 30: Pro Mode Run / Debug / Terminal UX

## Goal

Give Pro Mode an actual execution flow, with clear run, stop, restart, and terminal-style output.

## Why this step

After compiler integration, the IDE must feel like a working environment where users can launch code and see progress, rather than only displaying raw compiler logs.

## What to implement

- Add run state to the Pro Mode controller:
  - `idle`
  - `running`
  - `success`
  - `failed`
- Keep a command state for `تشغيل`, `إيقاف`, and `إعادة تشغيل`.
- Preserve compiler output in a scrollable terminal panel with timestamped entries.
- Add a small note or tooltip for `تصحيح` to explain that debugger support is coming later.
- Ensure the UI still works when the compiler process exits with an error.
- Add user-friendly Arabic status labels such as:
  - `تشغيل...`
  - `توقف` 
  - `نجاح` 
  - `خطأ في الترجمة`

## Acceptance criteria

- Running code changes the panel state to running.
- Stop cancels the current compiler subprocess.
- Restart re-runs using the latest buffer content.
- Output history is preserved between runs.
- The panel shows whether the last run succeeded or failed.

## Notes

- Do not add device upload or board flashing behavior here.
- Keep the actual debug command as a placeholder until the debug integration step.
- Prefer a single output/log panel that can show both compilation and run messages rather than multiple disjoint consoles.

## Next step suggestion

Step 31 should connect device and board state so users can compile and flash a real Arduino board from the IDE.
