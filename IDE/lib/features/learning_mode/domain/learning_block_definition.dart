enum LearningBlockKind { variable, setup, loop, print, delay, ifStatement }

class LearningBlockDefinition {
  const LearningBlockDefinition({
    required this.kind,
    required this.title,
    required this.description,
    required this.generatedCode,
  });

  final LearningBlockKind kind;
  final String title;
  final String description;
  final String generatedCode;
}

class LearningProgramBlock {
  const LearningProgramBlock({required this.id, required this.definition});

  final int id;
  final LearningBlockDefinition definition;
}
