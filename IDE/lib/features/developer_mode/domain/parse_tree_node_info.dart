class ParseTreeNodeInfo {
  const ParseTreeNodeInfo({
    required this.rule,
    required this.text,
    required this.line,
    required this.column,
    this.children = const [],
  });

  final String rule;
  final String text;
  final int line;
  final int column;
  final List<ParseTreeNodeInfo> children;
}
