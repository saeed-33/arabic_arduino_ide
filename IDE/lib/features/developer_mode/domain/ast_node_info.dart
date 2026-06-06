class AstNodeInfo {
  const AstNodeInfo({
    required this.type,
    required this.value,
    required this.line,
    required this.column,
    this.children = const [],
  });

  final String type;
  final String value;
  final int line;
  final int column;
  final List<AstNodeInfo> children;
}
