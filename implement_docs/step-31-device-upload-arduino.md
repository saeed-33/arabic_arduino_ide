# Step 31: Device Panel and Arduino Upload

## Goal

Add board/device management and a first flashing workflow so the IDE can target real Arduino hardware.

## Why this step

Pro Mode should not just compile Arabic Arduino code; it must also let the user choose a connected board and upload firmware.

## What to implement

- Add a device panel to Pro Mode showing:
  - detected serial ports
  - selected board type
  - connection status
- Add a `رفع` button for upload.
- Integrate with the existing compiler flow so the IDE can build, link, and flash in sequence.
- Use `python build.py ports` or the current Arduino CLI wrapper to discover ports.
- Use `python build.py flash COM3` or an equivalent adapter to flash the selected port.
- Show upload progress and result messages in the output/log panel.

## Acceptance criteria

- The device panel lists at least one available port when Arduino hardware is connected.
- The user can select a port and press `رفع`.
- The IDE runs the upload command and reports success or failure.
- The upload step only runs after a successful compile.

## Notes

- Keep the hardware upload implementation modular so it can later be extended with serial monitoring.
- Do not require board-specific knowledge beyond selecting a serial port for the first version.
- Use an explicit `فرز المنافذ` or refresh control if port detection is unreliable.

## Next step suggestion

Step 32 should add persistent settings and recent-file state so IDE preferences survive app restarts.
