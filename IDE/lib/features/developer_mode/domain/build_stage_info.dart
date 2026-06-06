enum BuildStageStatus { waiting, ready, blocked }

class BuildStageInfo {
  const BuildStageInfo({
    required this.name,
    required this.status,
    required this.durationLabel,
    required this.details,
  });

  final String name;
  final BuildStageStatus status;
  final String durationLabel;
  final String details;
}
