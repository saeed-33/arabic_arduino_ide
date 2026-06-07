enum LearningBlockKind {
  variable,
  setup,
  loop,
  print,
  delay,
  ifStatement,
  userFunction,
  callUserFunction,
}

class LearningBlockGroup {
  const LearningBlockGroup({
    required this.number,
    required this.title,
    required this.blocks,
  });

  final int number;
  final String title;
  final List<LearningBlockDefinition> blocks;
}

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
