import 'package:flutter/material.dart';

import 'application/pro_mode_session_controller.dart';
import 'domain/pro_mode_log_entry.dart';

class ProModePage extends StatefulWidget {
  const ProModePage({super.key, required this.controller});

  final ProModeSessionController controller;

  @override
  State<ProModePage> createState() => _ProModePageState();
}

class _ProModePageState extends State<ProModePage> {
  @override
  Widget build(BuildContext context) {
    final sessionController = widget.controller;

    return AnimatedBuilder(
      animation: sessionController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _CommandBar(
                onNewFile: sessionController.createNewFile,
                onOpenFile: sessionController.openFile,
                onSaveFile: sessionController.saveFile,
                onRun: sessionController.runProgram,
                onStop: sessionController.stopProgram,
                onRestart: sessionController.restartProgram,
                onDebug: sessionController.debugProgram,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Expanded(
                            child: _ArabicCodeEditor(
                              controller: sessionController.editorController,
                              fileLabel: sessionController.fileLabel,
                              hasUnsavedChanges:
                                  sessionController.hasUnsavedChanges,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 190,
                            child: _OutputPanel(
                              statusMessage: sessionController.statusMessage,
                              logs: sessionController.logs,
                              onClearLogs: sessionController.clearLogs,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const SizedBox(width: 260, child: _DeviceToolsPanel()),
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

class _CommandBar extends StatelessWidget {
  const _CommandBar({
    required this.onNewFile,
    required this.onOpenFile,
    required this.onSaveFile,
    required this.onRun,
    required this.onStop,
    required this.onRestart,
    required this.onDebug,
  });

  final Future<void> Function() onNewFile;
  final Future<void> Function() onOpenFile;
  final Future<void> Function() onSaveFile;
  final VoidCallback onRun;
  final VoidCallback onStop;
  final VoidCallback onRestart;
  final VoidCallback onDebug;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CommandButton(
                      icon: Icons.note_add_outlined,
                      label: 'ملف جديد',
                      onPressed: () {
                        onNewFile();
                      },
                    ),
                    _CommandButton(
                      icon: Icons.folder_open_outlined,
                      label: 'فتح',
                      onPressed: () {
                        onOpenFile();
                      },
                    ),
                    _CommandButton(
                      icon: Icons.save_outlined,
                      label: 'حفظ',
                      onPressed: () {
                        onSaveFile();
                      },
                    ),
                    const SizedBox(width: 16),
                    _CommandButton(
                      icon: Icons.play_arrow,
                      label: 'تشغيل',
                      onPressed: onRun,
                    ),
                    _CommandButton(
                      icon: Icons.stop,
                      label: 'إيقاف',
                      onPressed: onStop,
                    ),
                    _CommandButton(
                      icon: Icons.restart_alt,
                      label: 'إعادة تشغيل',
                      onPressed: onRestart,
                    ),
                    _CommandButton(
                      icon: Icons.bug_report_outlined,
                      label: 'تصحيح',
                      onPressed: onDebug,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text('وضع المحترف', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _CommandButton extends StatelessWidget {
  const _CommandButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Tooltip(
        message: label,
        child: FilledButton.tonalIcon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(label),
        ),
      ),
    );
  }
}

class _ArabicCodeEditor extends StatelessWidget {
  const _ArabicCodeEditor({
    required this.controller,
    required this.fileLabel,
    required this.hasUnsavedChanges,
  });

  final TextEditingController controller;
  final String fileLabel;
  final bool hasUnsavedChanges;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            icon: Icons.edit_note,
            title: 'المحرر',
            trailing:
                '$fileLabel - ${hasUnsavedChanges ? 'تغييرات غير محفوظة' : 'محفوظ'}',
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TextField(
                controller: controller,
                expands: true,
                maxLines: null,
                minLines: null,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Cascadia Mono',
                  height: 1.55,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutputPanel extends StatelessWidget {
  const _OutputPanel({
    required this.statusMessage,
    required this.logs,
    required this.onClearLogs,
  });

  final String statusMessage;
  final List<ProModeLogEntry> logs;
  final VoidCallback onClearLogs;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            icon: Icons.terminal,
            title: 'المخرجات والسجلات',
            trailing: statusMessage,
            action: IconButton(
              tooltip: 'مسح السجلات',
              onPressed: onClearLogs,
              icon: const Icon(Icons.clear_all, size: 20),
            ),
          ),
          Expanded(
            child: logs.isEmpty
                ? const Center(child: Text('لا توجد سجلات بعد.'))
                : ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      return _LogEntryRow(log: logs[index]);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: logs.length,
                  ),
          ),
        ],
      ),
    );
  }
}

class _LogEntryRow extends StatelessWidget {
  const _LogEntryRow({required this.log});

  final ProModeLogEntry log;

  @override
  Widget build(BuildContext context) {
    final color = _colorForLevel(context, log.level);
    final time = TimeOfDay.fromDateTime(log.createdAt).format(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(_iconForLevel(log.level), color: color, size: 18),
        const SizedBox(width: 8),
        Text(time, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 8),
        Expanded(child: Text(log.message)),
      ],
    );
  }

  Color _colorForLevel(BuildContext context, ProModeLogLevel level) {
    return switch (level) {
      ProModeLogLevel.info => Theme.of(context).colorScheme.primary,
      ProModeLogLevel.success => Colors.green.shade700,
      ProModeLogLevel.warning => Colors.orange.shade800,
      ProModeLogLevel.error => Theme.of(context).colorScheme.error,
    };
  }

  IconData _iconForLevel(ProModeLogLevel level) {
    return switch (level) {
      ProModeLogLevel.info => Icons.info_outline,
      ProModeLogLevel.success => Icons.check_circle_outline,
      ProModeLogLevel.warning => Icons.warning_amber_outlined,
      ProModeLogLevel.error => Icons.error_outline,
    };
  }
}

class _DeviceToolsPanel extends StatelessWidget {
  const _DeviceToolsPanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'الأجهزة والأدوات',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            const _InfoRow(
              icon: Icons.usb,
              title: 'الأجهزة المتصلة',
              value: 'لا يوجد جهاز',
            ),
            const Divider(height: 28),
            const _InfoRow(
              icon: Icons.memory,
              title: 'اللوحة',
              value: 'غير محددة',
            ),
            const Divider(height: 28),
            const _InfoRow(
              icon: Icons.download_outlined,
              title: 'التثبيت',
              value: 'غير مفعّل بعد',
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined),
              label: const Text('إعداد الأدوات'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.icon,
    required this.title,
    required this.trailing,
    this.action,
  });

  final IconData icon;
  final String title;
  final String trailing;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Flexible(
            child: Text(
              trailing,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (action != null) ...[const SizedBox(width: 8), action!],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}
