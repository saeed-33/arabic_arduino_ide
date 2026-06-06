import 'dart:convert';
import 'dart:io';

import '../domain/ast_node_info.dart';
import '../domain/build_stage_info.dart';
import '../domain/compiler_diagnostics_snapshot.dart';
import '../domain/parse_tree_node_info.dart';
import '../domain/raw_diagnostic.dart';
import '../domain/token_info.dart';

abstract class CompilerDiagnosticsAdapter {
  String get compilerName;
  String get compilerSourcePath;
  String get runtimeNote;

  Future<CompilerDiagnosticsSnapshot> analyze(String source);
}

class ArduinoArabicCompilerDiagnosticsAdapter
    implements CompilerDiagnosticsAdapter {
  const ArduinoArabicCompilerDiagnosticsAdapter();

  @override
  String get compilerName => 'ArduinoArabicCompiler';

  @override
  String get compilerSourcePath => 'compiler/ArduinoArabicCompiler';

  @override
  String get runtimeNote =>
      'يشغّل Developer Mode سكربت Python الخاص بالمترجم ويقرأ JSON diagnostics.';

  @override
  Future<CompilerDiagnosticsSnapshot> analyze(String source) async {
    final compilerDirectory = _findCompilerDirectory();
    if (compilerDirectory == null) {
      return _failureSnapshot(
        code: 'COMPILER_SOURCE_NOT_FOUND',
        message: 'Compiler source folder was not found.',
        context: compilerSourcePath,
      );
    }

    final runner = File('${compilerDirectory.path}\\run_diagnostics.py');
    if (!runner.existsSync()) {
      return _failureSnapshot(
        code: 'COMPILER_RUNNER_NOT_FOUND',
        message: 'run_diagnostics.py was not found.',
        context: runner.path,
      );
    }

    final pythonExecutable = _pythonExecutableFor(compilerDirectory);
    final arguments = source.trim().isEmpty
        ? ['run_diagnostics.py', '--file', 'test.txt']
        : ['run_diagnostics.py', '--source', source];

    try {
      final result = await Process.run(
        pythonExecutable,
        arguments,
        workingDirectory: compilerDirectory.path,
        environment: {'PYTHONIOENCODING': 'utf-8'},
      );

      final stdoutText = result.stdout.toString();
      if (stdoutText.trim().isEmpty) {
        return _failureSnapshot(
          code: 'COMPILER_NO_OUTPUT',
          message: result.stderr.toString().trim().isEmpty
              ? 'Compiler runner produced no JSON output.'
              : result.stderr.toString().trim(),
          context: compilerDirectory.path,
        );
      }

      return _snapshotFromJson(jsonDecode(stdoutText) as Map<String, dynamic>);
    } on Object catch (error) {
      return _failureSnapshot(
        code: 'COMPILER_PROCESS_FAILED',
        message: error.toString(),
        context: compilerDirectory.path,
      );
    }
  }

  Directory? _findCompilerDirectory() {
    final candidates = <Directory>[
      Directory(compilerSourcePath),
      Directory('..\\$compilerSourcePath'),
      Directory('${Directory.current.path}\\$compilerSourcePath'),
      Directory('${Directory.current.parent.path}\\$compilerSourcePath'),
    ];

    for (final candidate in candidates) {
      if (File('${candidate.path}\\run_diagnostics.py').existsSync()) {
        return candidate;
      }
    }

    return null;
  }

  String _pythonExecutableFor(Directory compilerDirectory) {
    final venvPython = File(
      '${compilerDirectory.path}\\.venv\\Scripts\\python.exe',
    );
    if (venvPython.existsSync()) {
      return venvPython.path;
    }

    return 'python';
  }

  CompilerDiagnosticsSnapshot _snapshotFromJson(Map<String, dynamic> json) {
    final diagnostics = _diagnosticsFromJson(json['rawDiagnostics']);
    final parseTree = _parseTreeFromJson(json['parseTree']);
    final tokens = _tokensFromJson(json['tokens']);
    final generatedCode = _stringListFromJson(json['generatedCode']);
    final buildStages = _buildStagesFromJson(json['buildStages']);
    final internalLogs = _stringListFromJson(json['internalLogs']);

    return CompilerDiagnosticsSnapshot(
      statusMessage: diagnostics.isEmpty
          ? 'تم تحليل المثال باستخدام المترجم المدمج.'
          : 'أعاد المترجم ${diagnostics.length} رسالة تشخيصية.',
      parseTreeRoot: parseTree,
      astRoot: const AstNodeInfo(
        type: 'CompilerOutputMissing',
        value: 'المترجم الحالي لا يصدر AST بعد.',
        line: 1,
        column: 1,
      ),
      tokens: tokens,
      rawDiagnostics: diagnostics,
      generatedCodeLines: generatedCode.isEmpty
          ? const ['// المترجم الحالي لا يصدر كود Arduino/C++ بعد.']
          : generatedCode,
      buildStages: buildStages,
      internalLogs: internalLogs,
    );
  }

  List<TokenInfo> _tokensFromJson(Object? value) {
    return _jsonList(value)
        .map(
          (item) => TokenInfo(
            type: _stringValue(item['type']),
            lexeme: _stringValue(item['lexeme']),
            line: _intValue(item['line']),
            column: _intValue(item['column']),
          ),
        )
        .toList();
  }

  ParseTreeNodeInfo _parseTreeFromJson(Object? value) {
    if (value is! Map<String, dynamic>) {
      return const ParseTreeNodeInfo(
        rule: 'empty',
        text: '',
        line: 1,
        column: 1,
      );
    }

    return ParseTreeNodeInfo(
      rule: _stringValue(value['rule']),
      text: _stringValue(value['text']),
      line: _intValue(value['line']),
      column: _intValue(value['column']),
      children: _jsonList(
        value['children'],
      ).map((child) => _parseTreeFromJson(child)).toList(),
    );
  }

  List<RawDiagnostic> _diagnosticsFromJson(Object? value) {
    return _jsonList(value)
        .map(
          (item) => RawDiagnostic(
            code: _stringValue(item['code']),
            message: _stringValue(item['message']),
            severity: _severityFromString(_stringValue(item['severity'])),
            line: _intValue(item['line']),
            column: _intValue(item['column']),
            context: _stringValue(item['context']),
          ),
        )
        .toList();
  }

  List<BuildStageInfo> _buildStagesFromJson(Object? value) {
    return _jsonList(value)
        .map(
          (item) => BuildStageInfo(
            name: _stringValue(item['name']),
            status: _stageStatusFromString(_stringValue(item['status'])),
            durationLabel: _stringValue(item['durationLabel']),
            details: _stringValue(item['details']),
          ),
        )
        .toList();
  }

  List<String> _stringListFromJson(Object? value) {
    return _jsonList(value).map((item) => item.toString()).toList();
  }

  CompilerDiagnosticsSnapshot _failureSnapshot({
    required String code,
    required String message,
    required String context,
  }) {
    return CompilerDiagnosticsSnapshot(
      statusMessage: 'تعذر تشغيل المترجم المدمج.',
      parseTreeRoot: const ParseTreeNodeInfo(
        rule: 'compiler_error',
        text: '',
        line: 1,
        column: 1,
      ),
      astRoot: const AstNodeInfo(
        type: 'CompilerError',
        value: '',
        line: 1,
        column: 1,
      ),
      tokens: const [],
      rawDiagnostics: [
        RawDiagnostic(
          code: code,
          message: message,
          severity: DiagnosticSeverity.error,
          line: 1,
          column: 1,
          context: context,
        ),
      ],
      generatedCodeLines: const [],
      buildStages: const [
        BuildStageInfo(
          name: 'Compiler runtime',
          status: BuildStageStatus.blocked,
          durationLabel: '--',
          details: 'تعذر تشغيل مترجم ArduinoArabicCompiler.',
        ),
      ],
      internalLogs: [message],
    );
  }

  List<Map<String, dynamic>> _jsonList(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value.whereType<Map<String, dynamic>>().toList();
  }

  String _stringValue(Object? value) => value?.toString() ?? '';

  int _intValue(Object? value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  DiagnosticSeverity _severityFromString(String value) {
    return switch (value.toLowerCase()) {
      'warning' => DiagnosticSeverity.warning,
      'error' => DiagnosticSeverity.error,
      _ => DiagnosticSeverity.info,
    };
  }

  BuildStageStatus _stageStatusFromString(String value) {
    return switch (value.toLowerCase()) {
      'ready' => BuildStageStatus.ready,
      'blocked' => BuildStageStatus.blocked,
      _ => BuildStageStatus.waiting,
    };
  }
}
