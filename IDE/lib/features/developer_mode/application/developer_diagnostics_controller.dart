import 'package:flutter/foundation.dart';

import '../domain/ast_node_info.dart';
import '../domain/build_stage_info.dart';
import '../domain/parse_tree_node_info.dart';
import '../domain/raw_diagnostic.dart';
import '../domain/token_info.dart';

class DeveloperDiagnosticsController extends ChangeNotifier {
  String get statusMessage =>
      'بيانات وضع المطور مؤقتة حتى يتم بناء محلل اللغة والمترجم.';

  AstNodeInfo get astRoot => const AstNodeInfo(
    type: 'Program',
    value: 'برنامج',
    line: 1,
    column: 1,
    children: [
      AstNodeInfo(
        type: 'SetupBlock',
        value: 'ابدأ',
        line: 1,
        column: 1,
        children: [
          AstNodeInfo(
            type: 'PinModeStatement',
            value: 'اجعل المنفذ 13 مخرج',
            line: 2,
            column: 3,
          ),
        ],
      ),
      AstNodeInfo(
        type: 'LoopBlock',
        value: 'كرر دائما',
        line: 4,
        column: 1,
        children: [
          AstNodeInfo(
            type: 'DigitalWriteStatement',
            value: 'شغّل المنفذ 13',
            line: 5,
            column: 3,
          ),
          AstNodeInfo(
            type: 'DelayStatement',
            value: 'انتظر 1000',
            line: 6,
            column: 3,
          ),
        ],
      ),
    ],
  );

  ParseTreeNodeInfo get parseTreeRoot => const ParseTreeNodeInfo(
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
            children: [
              ParseTreeNodeInfo(
                rule: 'MAKE_KEYWORD',
                text: 'اجعل',
                line: 2,
                column: 3,
              ),
              ParseTreeNodeInfo(
                rule: 'PIN_IDENTIFIER',
                text: 'المنفذ',
                line: 2,
                column: 8,
              ),
              ParseTreeNodeInfo(
                rule: 'NUMBER',
                text: '13',
                line: 2,
                column: 15,
              ),
              ParseTreeNodeInfo(
                rule: 'OUTPUT_KEYWORD',
                text: 'مخرج',
                line: 2,
                column: 18,
              ),
            ],
          ),
        ],
      ),
      ParseTreeNodeInfo(
        rule: 'loop_block',
        text: 'كرر دائما ...',
        line: 4,
        column: 1,
        children: [
          ParseTreeNodeInfo(
            rule: 'REPEAT_KEYWORD',
            text: 'كرر',
            line: 4,
            column: 1,
          ),
          ParseTreeNodeInfo(
            rule: 'FOREVER_KEYWORD',
            text: 'دائما',
            line: 4,
            column: 5,
          ),
          ParseTreeNodeInfo(
            rule: 'digital_write_statement',
            text: 'شغّل المنفذ 13',
            line: 5,
            column: 3,
          ),
          ParseTreeNodeInfo(
            rule: 'delay_statement',
            text: 'انتظر 1000',
            line: 6,
            column: 3,
          ),
        ],
      ),
      ParseTreeNodeInfo(rule: 'END_KEYWORD', text: 'نهاية', line: 9, column: 1),
    ],
  );

  List<TokenInfo> get tokens => const [
    TokenInfo(type: 'KeywordStart', lexeme: 'ابدأ', line: 1, column: 1),
    TokenInfo(type: 'KeywordMake', lexeme: 'اجعل', line: 2, column: 3),
    TokenInfo(type: 'Identifier', lexeme: 'المنفذ', line: 2, column: 8),
    TokenInfo(type: 'Number', lexeme: '13', line: 2, column: 15),
    TokenInfo(type: 'KeywordOutput', lexeme: 'مخرج', line: 2, column: 18),
  ];

  List<RawDiagnostic> get rawDiagnostics => const [
    RawDiagnostic(
      code: 'DEV_PLACEHOLDER',
      message: 'No real parser diagnostics are available yet.',
      severity: DiagnosticSeverity.info,
      line: 1,
      column: 1,
      context: 'Developer Mode shell placeholder.',
    ),
  ];

  List<String> get generatedCodeLines => const [
    '// Generated Arduino/C++ preview placeholder',
    'void setup() {',
    '  pinMode(13, OUTPUT);',
    '}',
    '',
    'void loop() {',
    '  digitalWrite(13, HIGH);',
    '  delay(1000);',
    '}',
  ];

  List<BuildStageInfo> get buildStages => const [
    BuildStageInfo(
      name: 'Lexing',
      status: BuildStageStatus.ready,
      durationLabel: '--',
      details: 'سيتم استخراج الرموز من الكود العربي لاحقا.',
    ),
    BuildStageInfo(
      name: 'Parsing',
      status: BuildStageStatus.waiting,
      durationLabel: '--',
      details: 'سيتم بناء AST بعد تعريف قواعد اللغة.',
    ),
    BuildStageInfo(
      name: 'Code generation',
      status: BuildStageStatus.blocked,
      durationLabel: '--',
      details: 'ينتظر AST والتحليل الدلالي.',
    ),
  ];

  List<String> get internalLogs => const [
    '[dev] Developer diagnostics shell initialized.',
    '[dev] Parser service is not connected yet.',
    '[dev] Compiler pipeline is not connected yet.',
  ];
}
