import 'package:flutter/material.dart';

import '../settings/domain/ide_settings.dart';
import 'application/developer_diagnostics_controller.dart';
import 'domain/ast_node_info.dart';
import 'domain/build_stage_info.dart';
import 'domain/parse_tree_node_info.dart';
import 'domain/raw_diagnostic.dart';
import 'domain/token_info.dart';

class DeveloperModePage extends StatefulWidget {
  const DeveloperModePage({super.key, required this.sourceProvider});

  final String Function() sourceProvider;

  @override
  State<DeveloperModePage> createState() => _DeveloperModePageState();
}

class _DeveloperModePageState extends State<DeveloperModePage> {
  late final DeveloperDiagnosticsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DeveloperDiagnosticsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return DefaultTabController(
          length: 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'وضع المطور',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            _controller.analyze(widget.sourceProvider());
                          },
                          icon: const Icon(Icons.analytics_outlined),
                          label: const Text('تحليل الكود'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(_controller.statusMessage),
                  ],
                ),
              ),
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Parse Tree'),
                  Tab(text: 'AST'),
                  Tab(text: 'Tokens'),
                  Tab(text: 'Raw Errors'),
                  Tab(text: 'Friendly Errors'),
                  Tab(text: 'Generated Code'),
                  Tab(text: 'Pipeline'),
                  Tab(text: 'Internal Logs'),
                  Tab(text: 'Environment'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _ParseTreePanel(root: _controller.parseTreeRoot),
                    _AstPanel(root: _controller.astRoot),
                    _TokensPanel(tokens: _controller.tokens),
                    _RawErrorsPanel(diagnostics: _controller.rawDiagnostics),
                    _FriendlyErrorsPanel(
                      diagnostics: _controller.rawDiagnostics,
                    ),
                    _GeneratedCodePanel(lines: _controller.generatedCodeLines),
                    _PipelinePanel(stages: _controller.buildStages),
                    _InternalLogsPanel(logs: _controller.internalLogs),
                    _EnvironmentPanel(
                      settings: IdeSettings.initial(),
                      compilerName: _controller.compilerName,
                      compilerSourcePath: _controller.compilerSourcePath,
                      runtimeNote: _controller.runtimeNote,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ParseTreePanel extends StatelessWidget {
  const _ParseTreePanel({required this.root});

  final ParseTreeNodeInfo root;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [_ParseTreeNodeTile(node: root)],
    );
  }
}

class _ParseTreeNodeTile extends StatelessWidget {
  const _ParseTreeNodeTile({required this.node});

  final ParseTreeNodeInfo node;

  @override
  Widget build(BuildContext context) {
    final title = '${node.rule}: ${node.text}';
    final subtitle = 'line ${node.line}, column ${node.column}';

    if (node.children.isEmpty) {
      return ListTile(
        dense: true,
        leading: const Icon(Icons.schema_outlined),
        title: Text(title),
        subtitle: Text(subtitle),
      );
    }

    return ExpansionTile(
      leading: const Icon(Icons.schema_outlined),
      title: Text(title),
      subtitle: Text(subtitle),
      children: node.children
          .map((child) => _ParseTreeNodeTile(node: child))
          .toList(),
    );
  }
}

class _AstPanel extends StatelessWidget {
  const _AstPanel({required this.root});

  final AstNodeInfo root;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [_AstNodeTile(node: root)],
    );
  }
}

class _AstNodeTile extends StatelessWidget {
  const _AstNodeTile({required this.node});

  final AstNodeInfo node;

  @override
  Widget build(BuildContext context) {
    final title = '${node.type}: ${node.value}';
    final subtitle = 'line ${node.line}, column ${node.column}';

    if (node.children.isEmpty) {
      return ListTile(
        dense: true,
        leading: const Icon(Icons.account_tree_outlined),
        title: Text(title),
        subtitle: Text(subtitle),
      );
    }

    return ExpansionTile(
      leading: const Icon(Icons.account_tree_outlined),
      title: Text(title),
      subtitle: Text(subtitle),
      children: node.children
          .map((child) => _AstNodeTile(node: child))
          .toList(),
    );
  }
}

class _TokensPanel extends StatelessWidget {
  const _TokensPanel({required this.tokens});

  final List<TokenInfo> tokens;

  @override
  Widget build(BuildContext context) {
    return _DataTableSurface(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Lexeme')),
          DataColumn(label: Text('Line')),
          DataColumn(label: Text('Column')),
        ],
        rows: tokens
            .map(
              (token) => DataRow(
                cells: [
                  DataCell(Text(token.type)),
                  DataCell(Text(token.lexeme)),
                  DataCell(Text('${token.line}')),
                  DataCell(Text('${token.column}')),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RawErrorsPanel extends StatelessWidget {
  const _RawErrorsPanel({required this.diagnostics});

  final List<RawDiagnostic> diagnostics;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final diagnostic = diagnostics[index];
        return ListTile(
          leading: Icon(_iconForSeverity(diagnostic.severity)),
          title: Text('${diagnostic.code}: ${diagnostic.message}'),
          subtitle: Text(
            'line ${diagnostic.line}, column ${diagnostic.column}\n${diagnostic.context}',
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: diagnostics.length,
    );
  }

  IconData _iconForSeverity(DiagnosticSeverity severity) {
    return switch (severity) {
      DiagnosticSeverity.info => Icons.info_outline,
      DiagnosticSeverity.warning => Icons.warning_amber_outlined,
      DiagnosticSeverity.error => Icons.error_outline,
    };
  }
}

class _FriendlyErrorsPanel extends StatelessWidget {
  const _FriendlyErrorsPanel({required this.diagnostics});

  final List<RawDiagnostic> diagnostics;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: diagnostics
          .map(
            (diagnostic) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'رسالة تعليمية مقترحة: سنحوّل ${diagnostic.code} إلى شرح مناسب للمتعلمين لاحقا.',
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _GeneratedCodePanel extends StatelessWidget {
  const _GeneratedCodePanel({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SelectableText(
        lines.join('\n'),
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontFamily: 'Cascadia Mono',
          height: 1.5,
        ),
      ),
    );
  }
}

class _PipelinePanel extends StatelessWidget {
  const _PipelinePanel({required this.stages});

  final List<BuildStageInfo> stages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final stage = stages[index];
        return ListTile(
          leading: Icon(_iconForStatus(stage.status)),
          title: Text(stage.name),
          subtitle: Text(stage.details),
          trailing: Text(stage.durationLabel),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: stages.length,
    );
  }

  IconData _iconForStatus(BuildStageStatus status) {
    return switch (status) {
      BuildStageStatus.waiting => Icons.hourglass_empty,
      BuildStageStatus.ready => Icons.check_circle_outline,
      BuildStageStatus.blocked => Icons.block,
    };
  }
}

class _InternalLogsPanel extends StatelessWidget {
  const _InternalLogsPanel({required this.logs});

  final List<String> logs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Text(
          logs[index],
          textDirection: TextDirection.ltr,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontFamily: 'Cascadia Mono'),
        );
      },
      itemCount: logs.length,
    );
  }
}

class _EnvironmentPanel extends StatelessWidget {
  const _EnvironmentPanel({
    required this.settings,
    required this.compilerName,
    required this.compilerSourcePath,
    required this.runtimeNote,
  });

  final IdeSettings settings;
  final String compilerName;
  final String compilerSourcePath;
  final String runtimeNote;

  @override
  Widget build(BuildContext context) {
    final rows = {
      'Arduino CLI': settings.arduinoCliPath.isEmpty
          ? 'غير محدد'
          : settings.arduinoCliPath,
      'Board FQBN': settings.defaultBoard,
      'Serial port': settings.serialPort.isEmpty
          ? 'غير محدد'
          : settings.serialPort,
      'Libraries server': settings.librariesServerUrl.isEmpty
          ? 'غير محدد'
          : settings.librariesServerUrl,
      'Compiler': 'غير متصل',
      'Compiler name': compilerName,
      'Compiler source': compilerSourcePath,
      'Compiler runtime': runtimeNote,
      'Parser': 'غير متصل',
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: rows.entries
          .map(
            (entry) =>
                ListTile(title: Text(entry.key), subtitle: Text(entry.value)),
          )
          .toList(),
    );
  }
}

class _DataTableSurface extends StatelessWidget {
  const _DataTableSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: child,
      ),
    );
  }
}
