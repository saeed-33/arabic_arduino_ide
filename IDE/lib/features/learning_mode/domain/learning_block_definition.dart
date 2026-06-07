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

enum LearningBlockPlacement { topLevel, functionBody }

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
    required this.placement,
  });

  final LearningBlockKind kind;
  final String title;
  final String description;
  final String generatedCode;
  final LearningBlockPlacement placement;
}

class LearningProgramBlock {
  const LearningProgramBlock({
    required this.id,
    required this.definition,
    required this.groupColor,
  });

  final int id;
  final LearningBlockDefinition definition;
  final LearningBlockGroupColor groupColor;
}
