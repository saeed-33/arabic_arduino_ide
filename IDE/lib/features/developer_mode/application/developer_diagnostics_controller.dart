import 'package:flutter/foundation.dart';

import '../domain/ast_node_info.dart';
import '../domain/build_stage_info.dart';
import '../domain/compiler_diagnostics_snapshot.dart';
import '../domain/compiler_runtime_status.dart';
import '../domain/parse_tree_node_info.dart';
import '../domain/raw_diagnostic.dart';
import '../domain/token_info.dart';
import 'compiler_diagnostics_adapter.dart';

class DeveloperDiagnosticsController extends ChangeNotifier {
  DeveloperDiagnosticsController({CompilerDiagnosticsAdapter? compilerAdapter})
    : _compilerAdapter =
          compilerAdapter ?? const ArduinoArabicCompilerDiagnosticsAdapter() {
    _snapshot = _emptySnapshot();
    analyze('');
  }

  final CompilerDiagnosticsAdapter _compilerAdapter;
  late CompilerDiagnosticsSnapshot _snapshot;
  CompilerRuntimeStatus? _runtimeStatus;

  String get compilerName => _compilerAdapter.compilerName;
  String get compilerSourcePath => _compilerAdapter.compilerSourcePath;
  String get runtimeNote => _compilerAdapter.runtimeNote;
  String get statusMessage => _snapshot.statusMessage;
  ParseTreeNodeInfo get parseTreeRoot => _snapshot.parseTreeRoot;
  AstNodeInfo get astRoot => _snapshot.astRoot;
  List<TokenInfo> get tokens => _snapshot.tokens;
  List<RawDiagnostic> get rawDiagnostics => _snapshot.rawDiagnostics;
  List<String> get generatedCodeLines => _snapshot.generatedCodeLines;
  List<BuildStageInfo> get buildStages => _snapshot.buildStages;
  List<String> get internalLogs => _snapshot.internalLogs;
  CompilerRuntimeStatus? get runtimeStatus => _runtimeStatus;

  Future<void> analyze(String source) async {
    _snapshot = await _compilerAdapter.analyze(source);
    _runtimeStatus = await _compilerAdapter.checkRuntime();
    notifyListeners();
  }

  CompilerDiagnosticsSnapshot _emptySnapshot() {
    return const CompilerDiagnosticsSnapshot(
      statusMessage: 'جاري تجهيز تشخيصات المترجم...',
      parseTreeRoot: ParseTreeNodeInfo(
        rule: 'empty',
        text: '',
        line: 1,
        column: 1,
      ),
      astRoot: AstNodeInfo(type: 'Empty', value: '', line: 1, column: 1),
      tokens: [],
      rawDiagnostics: [],
      generatedCodeLines: [],
      buildStages: [],
      internalLogs: [],
    );
  }
}
