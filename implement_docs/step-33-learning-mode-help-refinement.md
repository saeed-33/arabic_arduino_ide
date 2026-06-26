# Step 33: Learning Mode and Help Refinement

## Goal

Make the IDE’s learning experience more coherent by connecting help content, examples, and the Pro Mode compile/run workflow.

## Why this step

The app already contains both Pro Mode and learning-mode scaffolding. This step helps learners transition from examples to real code execution.

## What to implement

- Add sample Arabic Arduino programs for common learning tasks.
- Update Help content to describe:
  - how to write code in Pro Mode
  - how to compile and run
  - what the device panel does
  - why `تصحيح` is not active yet
- Add a small onboarding or `Getting Started` panel in the `مساعدة` section.
- Add a learning-mode note that points to Pro Mode for real compile/upload behavior.
- Keep learning mode UI simple, but aligned with the current compiler vocabulary.

## Acceptance criteria

- Help content clearly explains the next available workflow.
- A learner can follow the help text to edit code, compile, and flash an Arduino board.
- Existing `Kids Mode` / learning components are not broken by the new content.

## Notes

- Use Arabic UI copy consistently.
- Do not add advanced debugging or developer diagnostics yet.

## Next step suggestion

After this step, evaluate whether to add a dedicated Developer Mode for raw diagnostics and parse tree exploration.
