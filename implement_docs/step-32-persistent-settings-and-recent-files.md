# Step 32: Persistent Settings and Recent Files

## Goal

Add persistence for editor state, file history, and IDE settings so users do not lose their workflow when restarting the app.

## Why this step

The IDE currently works in-memory only. Persistent settings make the app feel stable and production-ready.

## What to implement

- Choose and add a Windows-friendly persistence layer.
  - `shared_preferences` for small values.
  - `path_provider` for a local app data folder.
- Persist:
  - last opened file path
  - last used board port
  - last selected settings values
  - recent files list
  - window or workspace layout state if available
- Restore persisted values at startup.
- Add a `Recent Files` section or quick access list in Pro Mode.
- Add a small settings page entry for toolchain and default board port.

## Acceptance criteria

- The IDE restores `lastOpenedFile` after restart when that file still exists.
- The selected board port is remembered.
- Recent files appear in a quick-access list.
- Settings values persist across app restarts.

## Notes

- Keep the persistence API isolated from UI widgets.
- Avoid storing large editor contents in the preference store; only persist file paths and small settings.
- Validate file existence before reopening data from the last session.

## Next step suggestion

Step 33 should improve the learning experience and help content so the IDE supports both learners and developers.
