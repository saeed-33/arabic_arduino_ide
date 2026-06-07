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

enum LearningBlockGroupColor { teal, blue, amber, rose, violet }

class LearningBlockGroup {
  const LearningBlockGroup({
    required this.title,
    required this.color,
    required this.blocks,
  });

  final String title;
  final LearningBlockGroupColor color;
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
