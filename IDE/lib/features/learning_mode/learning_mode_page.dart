import 'package:flutter/material.dart';

import 'application/learning_workspace_controller.dart';
import 'domain/learning_block_definition.dart';

typedef LearningBlockAddCallback =
    void Function(
      LearningBlockDefinition block,
      LearningBlockGroupColor groupColor,
    );

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
                      child: _WorkspacePanel(
                        blocks: _controller.programBlocks,
                        onAdd: _controller.addBlock,
                        onRemove: _controller.removeBlock,
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
                _BlockTipButton(block: block, color: color),
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
  const _PuzzleBlockShell({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            top: 22,
            start: -10,
            child: _PuzzleSocket(color: color),
          ),
          PositionedDirectional(
            top: 22,
            end: -10,
            child: _PuzzleKnob(color: color),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _darken(color), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(52),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 18, 10),
              child: child,
            ),
          ),
          PositionedDirectional(
            top: -7,
            start: 58,
            child: _PuzzleTopConnector(color: color),
          ),
          PositionedDirectional(
            bottom: -7,
            start: 92,
            child: _PuzzleBottomConnector(color: color),
          ),
        ],
      ),
    );
  }
}

class _PuzzleKnob extends StatelessWidget {
  const _PuzzleKnob({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _darken(color), width: 2),
      ),
    );
  }
}

class _PuzzleSocket extends StatelessWidget {
  const _PuzzleSocket({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 32,
      decoration: BoxDecoration(
        color: _tintForGroup(color),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _darken(color), width: 2),
      ),
    );
  }
}

class _PuzzleTopConnector extends StatelessWidget {
  const _PuzzleTopConnector({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _darken(color), width: 2),
      ),
    );
  }
}

class _PuzzleBottomConnector extends StatelessWidget {
  const _PuzzleBottomConnector({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 16,
      decoration: BoxDecoration(
        color: _tintForGroup(color),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _darken(color), width: 2),
      ),
    );
  }
}

class _WorkspacePuzzleBlock extends StatelessWidget {
  const _WorkspacePuzzleBlock({
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
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 300,
      child: _PuzzleBlockShell(
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
                  _BlockTipButton(block: block.definition, color: color),
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
    return DragTarget<_LearningBlockDragData>(
      onAcceptWithDetails: (details) {
        onAdd(details.data.block, details.data.groupColor);
      },
      builder: (context, candidateData, rejectedData) {
        final isDropActive = candidateData.isNotEmpty;
        return Card(
          color: isDropActive
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'مساحة البرنامج',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (isDropActive)
                      Text(
                        'أفلت البلوك هنا',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: blocks.isEmpty
                      ? const Center(
                          child: Text(
                            'اسحب بلوكا من مكتبة البلوكات وأفلته هنا.',
                          ),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final block = blocks[index];
                            return _WorkspaceBlockTile(
                              index: index,
                              block: block,
                              onRemove: onRemove,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemCount: blocks.length,
                        ),
                ),
              ],
            ),
          ),
        );
      },
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
    return _WorkspacePuzzleBlock(
      index: index,
      block: block,
      onRemove: onRemove,
    );
  }
}

class _BlockTipButton extends StatelessWidget {
  const _BlockTipButton({required this.block, required this.color});

  final LearningBlockDefinition block;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          'المستوى: ${_placementLabel(block.placement)}\nالغرض: ${block.description}',
      textStyle: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.white),
      preferBelow: false,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(34),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withAlpha(96)),
        ),
        child: const Icon(Icons.info_outline, size: 16, color: Colors.white),
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

Color _darken(Color color) {
  return Color.fromARGB(
    color.alpha,
    (color.red * 0.72).round(),
    (color.green * 0.72).round(),
    (color.blue * 0.72).round(),
  );
}
