import 'package:flutter/foundation.dart';

import '../domain/learning_block_definition.dart';

class LearningWorkspaceController extends ChangeNotifier {
  final List<LearningProgramBlock> _programBlocks = [];
  int _nextId = 1;

  List<LearningBlockGroup> get paletteGroups => const [
    LearningBlockGroup(
      title: 'البداية والتكرار',
      color: LearningBlockGroupColor.teal,
      blocks: [
        LearningBlockDefinition(
          kind: LearningBlockKind.setup,
          title: 'دالة إعداد',
          description: 'مكان أوامر البداية.',
          generatedCode: 'دالة إعداد() : فارغ {\n}',
          placement: LearningBlockPlacement.topLevel,
          acceptsChildren: true,
        ),
        LearningBlockDefinition(
          kind: LearningBlockKind.loop,
          title: 'دالة حلقة',
          description: 'أوامر تتكرر دائما.',
          generatedCode: 'دالة حلقة() : فارغ {\n}',
          placement: LearningBlockPlacement.topLevel,
          acceptsChildren: true,
        ),
      ],
    ),
    LearningBlockGroup(
      title: 'المتغيرات',
      color: LearningBlockGroupColor.blue,
      blocks: [
        LearningBlockDefinition(
          kind: LearningBlockKind.variable,
          title: 'متغير رقم',
          description: 'ينشئ متغيرا رقميا بسيطا.',
          generatedCode: 'متغير العدد : صحيح = 0؛',
          placement: LearningBlockPlacement.topLevel,
        ),
      ],
    ),
    LearningBlockGroup(
      title: 'الأوامر',
      color: LearningBlockGroupColor.amber,
      blocks: [
        LearningBlockDefinition(
          kind: LearningBlockKind.print,
          title: 'كتابة نص',
          description: 'استدعاء دالة كتابة متوافق مع قواعد المترجم.',
          generatedCode: 'كتابة_تسلسلية("مرحبا")؛',
          placement: LearningBlockPlacement.functionBody,
        ),
        LearningBlockDefinition(
          kind: LearningBlockKind.delay,
          title: 'انتظر',
          description: 'ينتظر زمنا بالمللي ثانية.',
          generatedCode: 'تأخير(1000)؛',
          placement: LearningBlockPlacement.functionBody,
        ),
      ],
    ),
    LearningBlockGroup(
      title: 'الشروط',
      color: LearningBlockGroupColor.rose,
      blocks: [
        LearningBlockDefinition(
          kind: LearningBlockKind.ifStatement,
          title: 'إذا',
          description: 'شرط بسيط.',
          generatedCode: 'إذا (العدد > 0) {\n}',
          placement: LearningBlockPlacement.functionBody,
          acceptsChildren: true,
        ),
      ],
    ),
    LearningBlockGroup(
      title: 'توابع المستخدم',
      color: LearningBlockGroupColor.violet,
      blocks: [
        LearningBlockDefinition(
          kind: LearningBlockKind.userFunction,
          title: 'تعريف تابع',
          description: 'ينشئ تابعا جديدا باسم يختاره المستخدم لاحقا.',
          generatedCode: 'دالة تابعي() : فارغ {\n}',
          placement: LearningBlockPlacement.topLevel,
          acceptsChildren: true,
        ),
        LearningBlockDefinition(
          kind: LearningBlockKind.callUserFunction,
          title: 'استدعاء تابع',
          description: 'يستدعي تابعا أنشأه المستخدم.',
          generatedCode: 'تابعي()؛',
          placement: LearningBlockPlacement.functionBody,
        ),
      ],
    ),
  ];

  List<LearningProgramBlock> get programBlocks =>
      List.unmodifiable(_programBlocks);

  bool get hasBlocks => _programBlocks.isNotEmpty;

  void addBlock(
    LearningBlockDefinition definition,
    LearningBlockGroupColor groupColor, {
    int? parentId,
    int? index,
  }) {
    final newBlock = LearningProgramBlock(
      id: _nextId++,
      definition: definition,
      groupColor: groupColor,
      children: [],
    );

    if (parentId == null) {
      _insertBlock(_programBlocks, newBlock, index);
    } else {
      _insertIntoParent(_programBlocks, parentId, newBlock, index);
    }

    notifyListeners();
  }

  void removeBlock(int id) {
    _removeBlock(_programBlocks, id);
    notifyListeners();
  }

  void clear() {
    _programBlocks.clear();
    notifyListeners();
  }

  String buildPreviewSource() {
    if (_programBlocks.isEmpty) {
      return '// لم تضف أي بلوكات بعد.';
    }

    final generatedSource = _programBlocks
        .map((block) => _buildBlockSource(block))
        .join('\n\n');

    final warnings = _buildPlacementWarnings();
    if (warnings.isEmpty) {
      return generatedSource;
    }

    return [
      '// تحذيرات تعليمية',
      ...warnings.map((warning) => '// $warning'),
      '',
      generatedSource,
    ].join('\n');
  }

  List<String> _buildPlacementWarnings() {
    final warnings = <String>[];
    final allBlocks = _flattenBlocks(_programBlocks);
    final hasFunctionContainer = allBlocks.any(
      (block) =>
          block.definition.kind == LearningBlockKind.setup ||
          block.definition.kind == LearningBlockKind.loop ||
          block.definition.kind == LearningBlockKind.userFunction,
    );

    warnings.addAll(_buildPlacementWarningsFor(_programBlocks));

    if (warnings.isNotEmpty && !hasFunctionContainer) {
      warnings.add('أضف دالة إعداد أو دالة حلقة حتى تجد الأوامر مكانا مناسبا.');
    }

    return warnings;
  }

  List<String> _buildPlacementWarningsFor(
    List<LearningProgramBlock> blocks, {
    bool insideContainer = false,
  }) {
    final warnings = <String>[];

    for (final block in blocks) {
      if (block.definition.placement == LearningBlockPlacement.functionBody &&
          !insideContainer) {
        warnings.add(
          'البلوك "${block.definition.title}" يجب أن يكون داخل دالة مثل إعداد أو حلقة.',
        );
      }

      warnings.addAll(
        _buildPlacementWarningsFor(
          block.children,
          insideContainer: insideContainer || block.definition.acceptsChildren,
        ),
      );
    }

    return warnings;
  }

  void _insertBlock(
    List<LearningProgramBlock> target,
    LearningProgramBlock block,
    int? index,
  ) {
    final safeIndex = index == null
        ? target.length
        : index.clamp(0, target.length);
    target.insert(safeIndex, block);
  }

  bool _insertIntoParent(
    List<LearningProgramBlock> blocks,
    int parentId,
    LearningProgramBlock newBlock,
    int? index,
  ) {
    for (final block in blocks) {
      if (block.id == parentId && block.definition.acceptsChildren) {
        _insertBlock(block.children, newBlock, index);
        return true;
      }

      if (_insertIntoParent(block.children, parentId, newBlock, index)) {
        return true;
      }
    }

    return false;
  }

  bool _removeBlock(List<LearningProgramBlock> blocks, int id) {
    final removed = blocks.removeWhere((block) => block.id == id);
    if (removed > 0) {
      return true;
    }

    for (final block in blocks) {
      if (_removeBlock(block.children, id)) {
        return true;
      }
    }

    return false;
  }

  String _buildBlockSource(LearningProgramBlock block, [int indentLevel = 0]) {
    if (!block.definition.acceptsChildren) {
      return _indent(block.definition.generatedCode, indentLevel);
    }

    final source = block.definition.generatedCode;
    final openBlock = source.endsWith('\n}')
        ? source.substring(0, source.length - 2)
        : source;

    if (block.children.isEmpty) {
      return _indent('$openBlock\n}', indentLevel);
    }

    final childrenSource = block.children
        .map((child) => _buildBlockSource(child, indentLevel + 1))
        .join('\n');

    return '${_indent(openBlock, indentLevel)}\n$childrenSource\n${_indent('}', indentLevel)}';
  }

  String _indent(String source, int level) {
    final prefix = '  ' * level;
    return source.split('\n').map((line) => '$prefix$line').join('\n');
  }

  List<LearningProgramBlock> _flattenBlocks(List<LearningProgramBlock> blocks) {
    return [
      for (final block in blocks) ...[block, ..._flattenBlocks(block.children)],
    ];
  }
}
