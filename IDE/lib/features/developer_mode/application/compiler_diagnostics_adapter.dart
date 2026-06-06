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

class MockCompilerDiagnosticsAdapter implements CompilerDiagnosticsAdapter {
  const MockCompilerDiagnosticsAdapter();

  @override
  String get compilerName => 'ArduinoArabicCompiler';

  @override
  String get compilerSourcePath => 'compiler/ArduinoArabicCompiler';

  @override
  String get runtimeNote =>
      'ANTLR/Python compiler source imported; runtime bridge is not connected yet.';

  @override
  Future<CompilerDiagnosticsSnapshot> analyze(String source) async {
    return const CompilerDiagnosticsSnapshot(
      statusMessage:
          'تم استيراد مصدر المترجم. بيانات التشخيص ما زالت مؤقتة حتى بناء جسر التشغيل.',
      parseTreeRoot: ParseTreeNodeInfo(
        rule: 'program',
        text: 'ابدأ ... نهاية',
        line: 1,
        column: 1,
        children: [
          ParseTreeNodeInfo(
            rule: 'setup_block',
            text: 'ابدأ اجعل المنفذ 13 مخرج',
            line: 1,
            column: 1,
            children: [
              ParseTreeNodeInfo(
                rule: 'START_KEYWORD',
                text: 'ابدأ',
                line: 1,
                column: 1,
              ),
              ParseTreeNodeInfo(
                rule: 'pin_mode_statement',
                text: 'اجعل المنفذ 13 مخرج',
                line: 2,
                column: 3,
              ),
            ],
          ),
          ParseTreeNodeInfo(
            rule: 'loop_block',
            text: 'كرر دائما ...',
            line: 4,
            column: 1,
          ),
        ],
      ),
      astRoot: AstNodeInfo(
        type: 'Program',
        value: 'برنامج',
        line: 1,
        column: 1,
        children: [
          AstNodeInfo(type: 'SetupBlock', value: 'ابدأ', line: 1, column: 1),
          AstNodeInfo(
            type: 'LoopBlock',
            value: 'كرر دائما',
            line: 4,
            column: 1,
          ),
        ],
      ),
      tokens: [
        TokenInfo(type: 'KeywordStart', lexeme: 'ابدأ', line: 1, column: 1),
        TokenInfo(type: 'KeywordMake', lexeme: 'اجعل', line: 2, column: 3),
        TokenInfo(type: 'Identifier', lexeme: 'المنفذ', line: 2, column: 8),
        TokenInfo(type: 'Number', lexeme: '13', line: 2, column: 15),
      ],
      rawDiagnostics: [
        RawDiagnostic(
          code: 'COMPILER_BRIDGE_NOT_CONNECTED',
          message:
              'Compiler source is available, but the Flutter runtime bridge is not implemented yet.',
          severity: DiagnosticSeverity.info,
          line: 1,
          column: 1,
          context: 'compiler/ArduinoArabicCompiler',
        ),
      ],
      generatedCodeLines: [
        '// Compiler adapter placeholder',
        '// Real generated Arduino/C++ will come from ArduinoArabicCompiler.',
      ],
      buildStages: [
        BuildStageInfo(
          name: 'Compiler source import',
          status: BuildStageStatus.ready,
          durationLabel: '--',
          details: 'تم استيراد ملفات ANTLR و requirements.txt.',
        ),
        BuildStageInfo(
          name: 'Runtime bridge',
          status: BuildStageStatus.blocked,
          durationLabel: '--',
          details: 'لم يتم ربط Python/ANTLR مع تطبيق Flutter بعد.',
        ),
      ],
      internalLogs: [
        '[dev] Compiler source path: compiler/ArduinoArabicCompiler',
        '[dev] Adapter: MockCompilerDiagnosticsAdapter',
        '[dev] Runtime bridge pending.',
      ],
    );
  }
}
