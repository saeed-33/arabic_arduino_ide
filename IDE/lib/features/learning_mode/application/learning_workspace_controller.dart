import 'package:flutter/foundation.dart';

import '../domain/learning_block_definition.dart';

class LearningWorkspaceController extends ChangeNotifier {
  final List<LearningProgramBlock> _programBlocks = [];
  int _nextId = 1;

  List<LearningBlockDefinition> get palette => const [
    LearningBlockDefinition(
      kind: LearningBlockKind.variable,
      title: 'متغير رقم',
      description: 'ينشئ متغيرا رقميا بسيطا.',
      generatedCode: 'متغير العدد : صحيح = 0؛',
    ),
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
    LearningBlockDefinition(
      kind: LearningBlockKind.print,
      title: 'اكتب',
      description: 'أمر كتابة تجريبي داخل دالة.',
      generatedCode: 'اكتب("مرحبا")؛',
    ),
    LearningBlockDefinition(
      kind: LearningBlockKind.delay,
      title: 'انتظر',
      description: 'ينتظر زمنا بالمللي ثانية.',
      generatedCode: 'تأخير(1000)؛',
    ),
    LearningBlockDefinition(
      kind: LearningBlockKind.ifStatement,
      title: 'إذا',
      description: 'شرط بسيط.',
      generatedCode: 'إذا (العدد > 0) {\n}',
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
