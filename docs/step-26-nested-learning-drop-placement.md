# Step 26 - Nested Learning Drop Placement

## Goal

Let learners drop new blocks into the position they choose, including inside container blocks.

## Changes

- The workspace now shows drop slots between blocks.
- Dropping on a slot inserts the new palette block at that position.
- Container blocks show an inner area for child blocks.
- The following blocks accept child blocks:
  - Setup function.
  - Loop function.
  - If condition.
  - User function definition.
- Generated preview source is now built from the nested workspace tree.
- Placement warnings understand nested blocks.

## Architecture Notes

- `LearningBlockDefinition.acceptsChildren` marks container-capable blocks.
- `LearningProgramBlock.children` stores nested program blocks.
- `LearningWorkspaceController.addBlock` accepts optional `parentId` and `index`.
- `_BlockDropSlot` handles targeted drop insertion.
- `_BlockSequence` renders a horizontal block sequence with slots between blocks.
- `_NestedBlockArea` renders the child area inside a container block.

## Current Limits

- Existing workspace blocks cannot be dragged to reorder yet.
- Dropping a palette block creates a new block; it does not move an existing workspace block.
- Nested areas are visual containers; deeper semantic validation still belongs to the compiler.
