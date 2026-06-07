import 'package:flutter/material.dart';

import 'application/learning_workspace_controller.dart';
import 'domain/learning_block_definition.dart';

class LearningModePage extends StatefulWidget {
  const LearningModePage({super.key});

  @override
  State<LearningModePage> createState() => _LearningModePageState();
}

class _LearningModePageState extends State<LearningModePage> {
  late final LearningWorkspaceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LearningWorkspaceController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LearningHeader(
                hasBlocks: _controller.hasBlocks,
                onPreview: _showPreview,
                onClear: _controller.clear,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: _BlockPalette(
                        groups: _controller.paletteGroups,
                        onAdd: _controller.addBlock,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _WorkspacePanel(
                        blocks: _controller.programBlocks,
                        onRemove: _controller.removeBlock,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPreview() {
    final source = _controller.buildPreviewSource();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('معاينة الكود العربي'),
          content: SizedBox(
            width: 640,
            child: SelectableText(
              source,
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'Cascadia Mono',
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }
}

class _LearningHeader extends StatelessWidget {
  const _LearningHeader({
    required this.hasBlocks,
    required this.onPreview,
    required this.onClear,
  });

  final bool hasBlocks;
  final VoidCallback onPreview;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'وضع التعلم',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text('أضف بلوكات بسيطة، ثم اضغط معاينة لرؤية الكود.'),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: hasBlocks ? onClear : null,
              icon: const Icon(Icons.delete_outline),
              label: const Text('مسح'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: onPreview,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('معاينة الكود'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockPalette extends StatelessWidget {
  const _BlockPalette({required this.groups, required this.onAdd});

  final List<LearningBlockGroup> groups;
  final ValueChanged<LearningBlockDefinition> onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'مكتبة البلوكات',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return _PaletteGroupSection(group: group, onAdd: onAdd);
                },
                itemCount: groups.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteGroupSection extends StatelessWidget {
  const _PaletteGroupSection({required this.group, required this.onAdd});

  final LearningBlockGroup group;
  final ValueChanged<LearningBlockDefinition> onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 28,
                decoration: BoxDecoration(
                  color: _colorForGroup(group.color),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...group.blocks.map(
            (block) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _PaletteBlockTile(block: block, onAdd: onAdd),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForGroup(LearningBlockGroupColor color) {
    return switch (color) {
      LearningBlockGroupColor.teal => const Color(0xFF0F766E),
      LearningBlockGroupColor.blue => const Color(0xFF2563EB),
      LearningBlockGroupColor.amber => const Color(0xFFD97706),
      LearningBlockGroupColor.rose => const Color(0xFFE11D48),
      LearningBlockGroupColor.violet => const Color(0xFF7C3AED),
    };
  }
}

class _PaletteBlockTile extends StatelessWidget {
  const _PaletteBlockTile({required this.block, required this.onAdd});

  final LearningBlockDefinition block;
  final ValueChanged<LearningBlockDefinition> onAdd;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      title: Text(block.title),
      subtitle: Text(block.description),
      trailing: IconButton(
        tooltip: 'إضافة',
        onPressed: () => onAdd(block),
        icon: const Icon(Icons.add_circle_outline),
      ),
    );
  }
}

class _WorkspacePanel extends StatelessWidget {
  const _WorkspacePanel({required this.blocks, required this.onRemove});

  final List<LearningProgramBlock> blocks;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'مساحة البرنامج',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: blocks.isEmpty
                  ? const Center(child: Text('أضف بلوكا من مكتبة البلوكات.'))
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        final block = blocks[index];
                        return _WorkspaceBlockTile(
                          index: index,
                          block: block,
                          onRemove: onRemove,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: blocks.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceBlockTile extends StatelessWidget {
  const _WorkspaceBlockTile({
    required this.index,
    required this.block,
    required this.onRemove,
  });

  final int index;
  final LearningProgramBlock block;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('${index + 1}')),
      title: Text(block.definition.title),
      subtitle: Text(block.definition.description),
      trailing: IconButton(
        tooltip: 'حذف',
        onPressed: () => onRemove(block.id),
        icon: const Icon(Icons.close),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    );
  }
}
