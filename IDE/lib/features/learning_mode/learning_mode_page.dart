import 'package:flutter/material.dart';

import 'application/learning_workspace_controller.dart';
import 'domain/learning_block_definition.dart';

typedef LearningBlockAddCallback =
    void Function(
      LearningBlockDefinition block,
      LearningBlockGroupColor groupColor,
    );

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
  final LearningBlockAddCallback onAdd;

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
  final LearningBlockAddCallback onAdd;

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
              child: _PaletteBlockTile(
                block: block,
                groupColor: group.color,
                onAdd: onAdd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteBlockTile extends StatelessWidget {
  const _PaletteBlockTile({
    required this.block,
    required this.groupColor,
    required this.onAdd,
  });

  final LearningBlockDefinition block;
  final LearningBlockGroupColor groupColor;
  final LearningBlockAddCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final color = _colorForGroup(groupColor);
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _tintForGroup(color),
        border: Border.all(color: color.withAlpha(96)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 8, 10),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 54,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        block.title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      _PlacementBadge(placement: block.placement, color: color),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(block.description, style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: 'إضافة',
              onPressed: () => onAdd(block, groupColor),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
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
    final color = _colorForGroup(block.groupColor);

    return ListTile(
      contentPadding: const EdgeInsetsDirectional.fromSTEB(8, 6, 8, 6),
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(block.definition.title),
      subtitle: Wrap(
        spacing: 8,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(block.definition.description),
          _PlacementBadge(placement: block.definition.placement, color: color),
        ],
      ),
      trailing: IconButton(
        tooltip: 'حذف',
        onPressed: () => onRemove(block.id),
        icon: const Icon(Icons.close),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withAlpha(112)),
      ),
      tileColor: _tintForGroup(color),
    );
  }
}

class _PlacementBadge extends StatelessWidget {
  const _PlacementBadge({required this.placement, required this.color});

  final LearningBlockPlacement placement;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(96)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          _placementLabel(placement),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

String _placementLabel(LearningBlockPlacement placement) {
  return switch (placement) {
    LearningBlockPlacement.topLevel => 'مستوى البرنامج',
    LearningBlockPlacement.functionBody => 'داخل دالة',
  };
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

Color _tintForGroup(Color color) {
  return Color.alphaBlend(color.withAlpha(18), Colors.white);
}
