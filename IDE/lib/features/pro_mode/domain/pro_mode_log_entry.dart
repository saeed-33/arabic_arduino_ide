enum ProModeLogLevel { info, success, warning, error }

class ProModeLogEntry {
  const ProModeLogEntry({
    required this.message,
    required this.level,
    required this.createdAt,
  });

  final String message;
  final ProModeLogLevel level;
  final DateTime createdAt;
}
