import 'package:flutter/material.dart';

import 'application/learning_workspace_controller.dart';
import 'domain/learning_block_definition.dart';

typedef LearningBlockAddCallback =
    void Function(
      LearningBlockDefinition block,
      LearningBlockGroupColor groupColor, {
      int? parentId,
      int? index,
    });

class _LearningBlockDragData {
  const _LearningBlockDragData({required this.block, required this.groupColor});

  final LearningBlockDefinition block;
  final LearningBlockGroupColor groupColor;
}

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
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _WorkspacePanel(
                              blocks: _controller.programBlocks,
                              onAdd: _controller.addBlock,
                              onRemove: _controller.removeBlock,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 280,
                            child: _ProgramOutlinePanel(
                              functions: _controller.functionBlocks,
                              globals: _controller.globalBlocks,
                              onAddUserFunction: _controller.addUserFunction,
                              onAddGlobalVariable:
                                  _controller.addGlobalVariable,
                              onRestoreRequiredFunction:
                                  _controller.addRequiredFunction,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 210,
                      child: _BlockPalette(
                        groups: _controller.paletteGroups,
                        onAdd: _controller.addBlock,
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

class _BlockPalette extends StatefulWidget {
  const _BlockPalette({required this.groups, required this.onAdd});

  final List<LearningBlockGroup> groups;
  final LearningBlockAddCallback onAdd;

  @override
  State<_BlockPalette> createState() => _BlockPaletteState();
}

class _BlockPaletteState extends State<_BlockPalette> {
  int _selectedGroupIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedGroup = widget.groups[_selectedGroupIndex];

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
              child: _PaletteGroupBlocks(
                group: selectedGroup,
                onAdd: widget.onAdd,
              ),
            ),
            const SizedBox(height: 12),
            _GroupTabStrip(
              groups: widget.groups,
              selectedIndex: _selectedGroupIndex,
              onSelected: (index) {
                setState(() {
                  _selectedGroupIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteGroupBlocks extends StatelessWidget {
  const _PaletteGroupBlocks({required this.group, required this.onAdd});

  final LearningBlockGroup group;
  final LearningBlockAddCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final block = group.blocks[index];
              return SizedBox(
                width: 280,
                child: _PaletteBlockTile(
                  block: block,
                  groupColor: group.color,
                  onAdd: onAdd,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: group.blocks.length,
          ),
        ),
      ],
    );
  }
}

class _GroupTabStrip extends StatelessWidget {
  const _GroupTabStrip({
    required this.groups,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<LearningBlockGroup> groups;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final group = groups[index];
          return _GroupTabButton(
            group: group,
            isSelected: index == selectedIndex,
            onPressed: () => onSelected(index),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: groups.length,
      ),
    );
  }
}

class _GroupTabButton extends StatelessWidget {
  const _GroupTabButton({
    required this.group,
    required this.isSelected,
    required this.onPressed,
  });

  final LearningBlockGroup group;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = _colorForGroup(group.color);
    final foregroundColor = isSelected ? Colors.white : color;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color : _tintForGroup(color),
        foregroundColor: foregroundColor,
        side: BorderSide(color: color.withAlpha(isSelected ? 255 : 112)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.circle_outlined,
            size: 14,
          ),
          const SizedBox(height: 2),
          Text(
            group.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
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
    final tile = _PaletteBlockSurface(
      block: block,
      groupColor: groupColor,
      color: color,
      textTheme: textTheme,
      onAdd: onAdd,
    );

    return Draggable<_LearningBlockDragData>(
      data: _LearningBlockDragData(block: block, groupColor: groupColor),
      feedback: Material(
        elevation: 8,
        color: Colors.transparent,
        child: SizedBox(width: 280, child: tile),
      ),
      childWhenDragging: Opacity(opacity: 0.45, child: tile),
      child: tile,
    );
  }
}

class _PaletteBlockSurface extends StatelessWidget {
  const _PaletteBlockSurface({
    required this.block,
    required this.groupColor,
    required this.color,
    required this.textTheme,
    required this.onAdd,
  });

  final LearningBlockDefinition block;
  final LearningBlockGroupColor groupColor;
  final Color color;
  final TextTheme textTheme;
  final LearningBlockAddCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return _PuzzleBlockShell(
      block: block,
      color: color,
      child: Row(
        children: [
          const SizedBox(width: 6),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  block.title,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'إضافة',
            onPressed: () => onAdd(block, groupColor),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _PuzzleBlockShell extends StatelessWidget {
  const _PuzzleBlockShell({
    required this.block,
    required this.color,
    required this.child,
  });

  final LearningBlockDefinition block;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          'المستوى: ${_placementLabel(block.placement)}\nالغرض: ${block.description}',
      textStyle: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.white),
      preferBelow: false,
      child: SizedBox(
        height: 78,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _ScratchBlockPainter(color: color)),
            ),
            PositionedDirectional.fill(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 14),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScratchBlockPainter extends CustomPainter {
  const _ScratchBlockPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _scratchBlockPath(size);
    final shadowPaint = Paint()
      ..color = color.withAlpha(48)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final fillPaint = Paint()..color = color;
    final highlightPaint = Paint()
      ..color = _lighten(color).withAlpha(84)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final borderPaint = Paint()
      ..color = _darken(color)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path.shift(const Offset(0, 3)), shadowPaint);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);

    final highlightPath = Path()
      ..moveTo(18, 17)
      ..lineTo(size.width - 24, 17);
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant _ScratchBlockPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

Path _scratchBlockPath(Size size) {
  final width = size.width;
  final height = size.height;

  return Path()
    ..moveTo(14, 10)
    ..lineTo(56, 10)
    ..cubicTo(62, 10, 64, 20, 74, 20)
    ..lineTo(102, 20)
    ..cubicTo(112, 20, 114, 10, 122, 10)
    ..lineTo(width - 14, 10)
    ..quadraticBezierTo(width - 4, 10, width - 4, 20)
    ..lineTo(width - 4, height - 18)
    ..quadraticBezierTo(width - 4, height - 8, width - 14, height - 8)
    ..lineTo(132, height - 8)
    ..cubicTo(124, height - 8, 122, height, 112, height)
    ..lineTo(84, height)
    ..cubicTo(74, height, 72, height - 8, 64, height - 8)
    ..lineTo(14, height - 8)
    ..quadraticBezierTo(4, height - 8, 4, height - 18)
    ..lineTo(4, 20)
    ..quadraticBezierTo(4, 10, 14, 10)
    ..close();
}

class _WorkspacePuzzleBlock extends StatelessWidget {
  const _WorkspacePuzzleBlock({
    required this.index,
    required this.block,
    required this.onAdd,
    required this.onRemove,
  });

  final int index;
  final LearningProgramBlock block;
  final LearningBlockAddCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final color = _colorForGroup(block.groupColor);
    final textTheme = Theme.of(context).textTheme;

    final header = _PuzzleBlockShell(
      block: block.definition,
      color: color,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(34),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withAlpha(96)),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  block.definition.title,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'حذف',
            onPressed: () => onRemove(block.id),
            color: Colors.white,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );

    if (!block.definition.acceptsChildren) {
      return SizedBox(width: 300, child: header);
    }

    return SizedBox(
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          _NestedBlockArea(
            parent: block,
            color: color,
            onAdd: onAdd,
            onRemove: onRemove,
          ),
        ],
      ),
    );
  }
}

class _NestedBlockArea extends StatelessWidget {
  const _NestedBlockArea({
    required this.parent,
    required this.color,
    required this.onAdd,
    required this.onRemove,
  });

  final LearningProgramBlock parent;
  final Color color;
  final LearningBlockAddCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final containsContainer = parent.children.any(
      (block) => block.definition.acceptsChildren,
    );

    return Container(
      height: containsContainer ? 238 : 128,
      margin: const EdgeInsetsDirectional.only(start: 26, end: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _tintForGroup(color),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        border: Border.all(color: color.withAlpha(96)),
      ),
      child: parent.children.isEmpty
          ? _BlockDropSlot(
              parentId: parent.id,
              index: 0,
              onAdd: onAdd,
              label: 'أفلت بلوكا داخل ${parent.definition.title}',
            )
          : _BlockSequence(
              blocks: parent.children,
              parentId: parent.id,
              onAdd: onAdd,
              onRemove: onRemove,
              compact: true,
            ),
    );
  }
}

class _BlockSequence extends StatelessWidget {
  const _BlockSequence({
    required this.blocks,
    required this.onAdd,
    required this.onRemove,
    this.parentId,
    this.compact = false,
  });

  final List<LearningProgramBlock> blocks;
  final int? parentId;
  final LearningBlockAddCallback onAdd;
  final ValueChanged<int> onRemove;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (index.isEven) {
          return _BlockDropSlot(
            parentId: parentId,
            index: index ~/ 2,
            onAdd: onAdd,
            compact: compact,
          );
        }

        final blockIndex = index ~/ 2;
        final block = blocks[blockIndex];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _WorkspaceBlockTile(
            index: blockIndex,
            block: block,
            onAdd: onAdd,
            onRemove: onRemove,
          ),
        );
      },
      itemCount: blocks.length * 2 + 1,
    );
  }
}

class _BlockDropSlot extends StatelessWidget {
  const _BlockDropSlot({
    required this.index,
    required this.onAdd,
    this.parentId,
    this.compact = false,
    this.label,
  });

  final int? parentId;
  final int index;
  final LearningBlockAddCallback onAdd;
  final bool compact;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return DragTarget<_LearningBlockDragData>(
      onAcceptWithDetails: (details) {
        onAdd(
          details.data.block,
          details.data.groupColor,
          parentId: parentId,
          index: index,
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isActive = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: compact ? 94 : 116,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outlineVariant,
              width: isActive ? 2 : 1,
            ),
          ),
          child: Text(
            label ?? 'أفلت هنا',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        );
      },
    );
  }
}

class _ProgramOutlinePanel extends StatelessWidget {
  const _ProgramOutlinePanel({
    required this.functions,
    required this.globals,
    required this.onAddUserFunction,
    required this.onAddGlobalVariable,
    required this.onRestoreRequiredFunction,
  });

  final List<LearningProgramBlock> functions;
  final List<LearningProgramBlock> globals;
  final VoidCallback onAddUserFunction;
  final VoidCallback onAddGlobalVariable;
  final ValueChanged<LearningBlockKind> onRestoreRequiredFunction;

  @override
  Widget build(BuildContext context) {
    final hasSetup = functions.any(
      (block) => block.definition.kind == LearningBlockKind.setup,
    );
    final hasLoop = functions.any(
      (block) => block.definition.kind == LearningBlockKind.loop,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'هيكل البرنامج',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _OutlineActionButton(
              icon: Icons.add,
              label: 'إضافة تابع جديد',
              onPressed: onAddUserFunction,
            ),
            const SizedBox(height: 8),
            _OutlineActionButton(
              icon: Icons.data_object,
              label: 'متغير عام',
              onPressed: onAddGlobalVariable,
            ),
            const SizedBox(height: 12),
            Text('التوابع', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (!hasSetup)
              _OutlineActionButton(
                icon: Icons.restart_alt,
                label: 'إعادة initialize',
                onPressed: () =>
                    onRestoreRequiredFunction(LearningBlockKind.setup),
              ),
            if (!hasLoop)
              Padding(
                padding: EdgeInsets.only(top: hasSetup ? 0 : 8),
                child: _OutlineActionButton(
                  icon: Icons.loop,
                  label: 'إعادة loop',
                  onPressed: () =>
                      onRestoreRequiredFunction(LearningBlockKind.loop),
                ),
              ),
            Expanded(
              child: ListView(
                children: [
                  ...functions.map(
                    (block) => _OutlineItem(
                      color: _colorForGroup(block.groupColor),
                      title: block.definition.title,
                      subtitle: '${block.children.length} بلوك داخلي',
                      icon: _iconForBlock(block.definition.kind),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'المتغيرات العامة',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (globals.isEmpty)
                    const Text('لا توجد متغيرات عامة بعد.')
                  else
                    ...globals.map(
                      (block) => _OutlineItem(
                        color: _colorForGroup(block.groupColor),
                        title: block.definition.title,
                        subtitle: block.definition.description,
                        icon: Icons.data_array,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _OutlineItem extends StatelessWidget {
  const _OutlineItem({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _tintForGroup(color),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(96)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkspacePanel extends StatelessWidget {
  const _WorkspacePanel({
    required this.blocks,
    required this.onAdd,
    required this.onRemove,
  });

  final List<LearningProgramBlock> blocks;
  final LearningBlockAddCallback onAdd;
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
                  ? Center(
                      child: SizedBox(
                        height: 96,
                        child: _BlockDropSlot(
                          index: 0,
                          onAdd: onAdd,
                          label: 'اسحب بلوكا من المكتبة وأفلته هنا',
                        ),
                      ),
                    )
                  : _BlockSequence(
                      blocks: blocks,
                      onAdd: onAdd,
                      onRemove: onRemove,
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
    required this.onAdd,
    required this.onRemove,
  });

  final int index;
  final LearningProgramBlock block;
  final LearningBlockAddCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return _WorkspacePuzzleBlock(
      index: index,
      block: block,
      onAdd: onAdd,
      onRemove: onRemove,
    );
  }
}

String _placementLabel(LearningBlockPlacement placement) {
  return switch (placement) {
    LearningBlockPlacement.topLevel => 'مستوى البرنامج',
    LearningBlockPlacement.functionBody => 'داخل دالة',
  };
}

IconData _iconForBlock(LearningBlockKind kind) {
  return switch (kind) {
    LearningBlockKind.setup => Icons.restart_alt,
    LearningBlockKind.loop => Icons.loop,
    LearningBlockKind.userFunction => Icons.functions,
    LearningBlockKind.variable => Icons.data_array,
    LearningBlockKind.print => Icons.terminal,
    LearningBlockKind.delay => Icons.timer_outlined,
    LearningBlockKind.ifStatement => Icons.call_split,
    LearningBlockKind.callUserFunction => Icons.keyboard_return,
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

Color _darken(Color color) {
  return Color.fromARGB(
    color.alpha,
    (color.red * 0.72).round(),
    (color.green * 0.72).round(),
    (color.blue * 0.72).round(),
  );
}

Color _lighten(Color color) {
  return Color.fromARGB(
    color.alpha,
    color.red + ((255 - color.red) * 0.20).round(),
    color.green + ((255 - color.green) * 0.20).round(),
    color.blue + ((255 - color.blue) * 0.20).round(),
  );
}
