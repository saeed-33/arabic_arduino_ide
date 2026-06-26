# Step 6: Inactive Run And Debug Feedback

## Goal

Make the Pro Mode command buttons communicate clearly before real compiler, terminal, device, upload, or debug behavior exists.

## Implemented

The following buttons now write Arabic status/log messages:

- `تشغيل`
- `إيقاف`
- `إعادة تشغيل`
- `تصحيح`

## Behavior

### Run

Shows that running is not available yet and requires a compiler/toolchain step later.

### Stop

Shows that there is no active run process to stop.

### Restart

Shows that restart is not available until real run behavior exists.

### Debug

Shows that debugging will be defined after compiler and hardware layers are designed.

## Architecture

The button callbacks are wired through `ProModeSessionController`.

The UI command bar stays simple:

- It renders buttons.
- It forwards user actions.
- It does not own run/debug state.

## Still Not Implemented

- Compiler integration.
- Arduino CLI/toolchain setup.
- Terminal process execution.
- Serial monitor.
- Device detection.
- Upload/install behavior.
- Debug engine.

## Help Section Update

The Help section now explains that run/debug buttons provide feedback only and are not real execution features yet.

## Next Step Suggestion

Step 7 should add settings structure for toolchain/device configuration:

- Settings model.
- Arduino CLI path placeholder.
- Default board placeholder.
- Server URL placeholder for future libraries.
- Keep detection/install logic for later.
