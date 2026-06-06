class CompilerRuntimeStatus {
  const CompilerRuntimeStatus({
    required this.compilerDirectoryFound,
    required this.pythonAvailable,
    required this.virtualEnvironmentFound,
    required this.antlrRuntimeAvailable,
    required this.llvmliteAvailable,
    required this.pythonExecutable,
    required this.setupCommand,
  });

  final bool compilerDirectoryFound;
  final bool pythonAvailable;
  final bool virtualEnvironmentFound;
  final bool antlrRuntimeAvailable;
  final bool llvmliteAvailable;
  final String pythonExecutable;
  final String setupCommand;

  bool get isReady =>
      compilerDirectoryFound &&
      pythonAvailable &&
      virtualEnvironmentFound &&
      antlrRuntimeAvailable &&
      llvmliteAvailable;
}
