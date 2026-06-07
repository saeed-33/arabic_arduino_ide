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
        ),
        LearningBlockDefinition(
          kind: LearningBlockKind.loop,
          title: 'دالة حلقة',
          description: 'أوامر تتكرر دائما.',
          generatedCode: 'دالة حلقة() : فارغ {\n}',
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
        ),
        LearningBlockDefinition(
          kind: LearningBlockKind.delay,
          title: 'انتظر',
          description: 'ينتظر زمنا بالمللي ثانية.',
          generatedCode: 'تأخير(1000)؛',
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
        ),
        LearningBlockDefinition(
          kind: LearningBlockKind.callUserFunction,
          title: 'استدعاء تابع',
          description: 'يستدعي تابعا أنشأه المستخدم.',
          generatedCode: 'تابعي()؛',
        ),
      ],
    ),
  ];

  List<LearningProgramBlock> get programBlocks =>
      List.unmodifiable(_programBlocks);

  bool get hasBlocks => _programBlocks.isNotEmpty;

  void addBlock(LearningBlockDefinition definition) {
    _programBlocks.add(
      LearningProgramBlock(id: _nextId++, definition: definition),
    );
    notifyListeners();
  }

  void removeBlock(int id) {
    _programBlocks.removeWhere((block) => block.id == id);
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

    return _programBlocks
        .map((block) => block.definition.generatedCode)
        .join('\n\n');
  }
}
