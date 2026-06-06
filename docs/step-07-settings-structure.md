# Step 7: Settings Structure

## Goal

Prepare the IDE settings structure for toolchain, board, serial port, and future library server configuration without implementing persistence, detection, or install behavior yet.

## Implemented

Added a settings feature structure:

- `IdeSettings`
- `SettingsController`
- Arabic settings UI

## Settings Fields

The Settings page now contains:

- `مسار Arduino CLI`
- `اللوحة الافتراضية`
- `المنفذ التسلسلي`
- `رابط خادم المكتبات`

## Current Behavior

Settings are stored in memory only.

This means:

- Values update while the Settings page is alive.
- Values are not persisted to disk.
- Values are not used by Run, Debug, Install, or device detection yet.

## Separation Of Concerns

The feature is split by responsibility:

- `settings_page.dart`
  - UI rendering and user input.
- `SettingsController`
  - In-memory settings state and status message.
- `IdeSettings`
  - Structured settings data.

## Still Not Implemented

- Persistent settings storage.
- File picker for Arduino CLI path.
- Validation.
- Board discovery.
- Serial port discovery.
- Arduino CLI install flow.
- Libraries server connection.

## Help Section Update

The Help section now explains that settings are temporary placeholders for Arduino CLI, board, port, and libraries server.

## Next Step Suggestion

Step 8 should add a Developer Mode plan or first Developer Mode shell for advanced diagnostics:

- AST tree placeholder.
- Raw parser/compiler errors placeholder.
- Token stream placeholder.
- Generated Arduino/C++ preview placeholder.
- Internal logs placeholder.
