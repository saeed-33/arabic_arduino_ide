enum DiagnosticSeverity { info, warning, error }

class RawDiagnostic {
  const RawDiagnostic({
    required this.code,
    required this.message,
    required this.severity,
    required this.line,
    required this.column,
    required this.context,
  });

  final String code;
  final String message;
  final DiagnosticSeverity severity;
  final int line;
  final int column;
  final String context;
}
