# Step 4: Basic File Actions

## Goal

Make the first local file actions work in Pro Mode while keeping run, debug, terminal, compiler, and device behavior untouched.

## Implemented

The Pro Mode command bar now supports:

- `ملف جديد`
- `فتح`
- `حفظ`

## New File

`ملف جديد` clears the editor and starts a new unnamed buffer.

Current behavior:

- Editor content becomes empty.
- Current file path is cleared.
- Save state returns to `محفوظ`.

## Open

`فتح` opens a native Windows file picker.

Accepted file extensions:

- `.arab`
- `.ino`
- `.txt`

When a file is opened:

- Its content is loaded into the editor.
- The editor header shows the file name.
- Save state returns to `محفوظ`.

## Save

`حفظ` writes the current editor content to disk.

Current behavior:

- If the file already has a path, save writes back to the same path.
- If the file is unnamed, a native Windows save dialog is shown.
- The suggested file name is `برنامج_عربي.arab`.
- Save state returns to `محفوظ`.

## Editor Header

The editor header now shows:

- Current file name, or `ملف جديد`.
- Current save state:
  - `محفوظ`
  - `تغييرات غير محفوظة`

## Dependency Added

Added Flutter package:

- `file_selector`

This gives the Windows app native open/save dialogs.

## File Dialog Runtime Fix

File operations were moved behind `ProModeFileService` so the Pro Mode page does not directly own native file dialog behavior.

The UI now catches unavailable file-dialog plugin errors and shows an Arabic status message instead of allowing an unhandled exception to crash the app.

If `MissingPluginException` appears after adding `file_selector`, stop the running app and rebuild it. Flutter desktop native plugins are registered at app startup, so hot reload/hot restart is not enough after adding a new plugin.

Use:

```powershell
cd IDE
flutter clean
flutter pub get
flutter run -d windows
```

## Still Not Implemented

- Multiple file tabs.
- Save as.
- Close file confirmation.
- Recent files.
- Parser.
- Compiler.
- Upload to Arduino.
- Terminal behavior.
- Debug behavior.

## Help Section Update

The Help section now explains that local file actions are available for text files on Windows.

## Next Step Suggestion

Step 5 should add the first output/log state:

- Show clear status messages after New/Open/Save.
- Add log entries for user actions.
- Keep terminal execution disabled until the compiler/toolchain step.
