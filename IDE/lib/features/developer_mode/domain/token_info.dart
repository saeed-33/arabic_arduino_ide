class TokenInfo {
  const TokenInfo({
    required this.type,
    required this.lexeme,
    required this.line,
    required this.column,
  });

  final String type;
  final String lexeme;
  final int line;
  final int column;
}
