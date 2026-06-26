# Step 29: Pro Mode Compiler Integration

## Goal

Connect the Pro Mode editor to the Arabic Arduino compiler so Pro Mode can run source text and show compiler output.

## Why this step

So far the IDE has layout, editor, and file actions. The next needed value is real compiler feedback in the UI.

## What to implement

- Add a compiler adapter service that runs the Python compiler in a subprocess.
- Keep the adapter separate from widgets.
- Use the current editor content as compiler input.
- Preserve UTF-8 encoding on Windows when reading compiler output.
- Show compiler success / failure and diagnostics in the output/log panel.
- Disable `تشغيل` while compilation is running.
- Keep the `إيقاف` button available, but if needed only stop the running process.

## Acceptance criteria

- `تشغيل` launches the compiler for the current buffer.
- Output panel displays compiler stdout and stderr.
- Errors are visible in Arabic and the app does not crash.
- The run button is disabled during execution.
- A failed compile still shows the editor and allows the user to fix code.

## Notes

- Use `python build.py compile` from `arduino_arabic_compiler/ArduinoArabicCompiler` or call `main.py` directly.
- For temporary unsaved buffers, write the editor contents to a temp file before running the compiler.
- Do not implement actual hardware upload or debugger behavior in this step.

## Next step suggestion

Step 30 should add a real run/debug workflow and improve the output/log UX with execution state and interactive controls.
