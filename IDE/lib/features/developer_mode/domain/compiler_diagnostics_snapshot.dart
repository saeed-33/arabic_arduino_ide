import 'ast_node_info.dart';
import 'build_stage_info.dart';
import 'parse_tree_node_info.dart';
import 'raw_diagnostic.dart';
import 'token_info.dart';

class CompilerDiagnosticsSnapshot {
  const CompilerDiagnosticsSnapshot({
    required this.statusMessage,
    required this.parseTreeRoot,
    required this.astRoot,
    required this.tokens,
    required this.rawDiagnostics,
    required this.generatedCodeLines,
    required this.buildStages,
    required this.internalLogs,
  });

  final String statusMessage;
  final ParseTreeNodeInfo parseTreeRoot;
  final AstNodeInfo astRoot;
  final List<TokenInfo> tokens;
  final List<RawDiagnostic> rawDiagnostics;
  final List<String> generatedCodeLines;
  final List<BuildStageInfo> buildStages;
  final List<String> internalLogs;
}
