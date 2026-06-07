class FriendlyDiagnostic {
  const FriendlyDiagnostic({
    required this.title,
    required this.explanation,
    required this.suggestion,
    required this.location,
  });

  final String title;
  final String explanation;
  final String suggestion;
  final String location;
}
