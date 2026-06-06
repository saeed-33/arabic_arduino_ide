import 'package:flutter/material.dart';

class ProModePage extends StatefulWidget {
  const ProModePage({super.key});

  @override
  State<ProModePage> createState() => _ProModePageState();
}

class _ProModePageState extends State<ProModePage> {
  static const _initialCode = '''
ابدأ
  اجعل المنفذ 13 مخرج

كرر دائما
  شغّل المنفذ 13
  انتظر 1000
  أطفئ المنفذ 13
  انتظر 1000
نهاية
''';

  late final TextEditingController _editorController;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _editorController = TextEditingController(text: _initialCode);
    _editorController.addListener(_handleCodeChanged);
  }

  @override
  void dispose() {
    _editorController
      ..removeListener(_handleCodeChanged)
      ..dispose();
    super.dispose();
  }

  void _handleCodeChanged() {
    final hasChanges = _editorController.text != _initialCode;
    if (hasChanges == _hasUnsavedChanges) {
      return;
    }

    setState(() {
      _hasUnsavedChanges = hasChanges;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const _CommandBar(),
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
                          controller: _editorController,
                          hasUnsavedChanges: _hasUnsavedChanges,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 170, child: _OutputPanel()),
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
  }
}

class _CommandBar extends StatelessWidget {
  const _CommandBar();

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
                      onPressed: () {},
                    ),
                    _CommandButton(
                      icon: Icons.folder_open_outlined,
                      label: 'فتح',
                      onPressed: () {},
                    ),
                    _CommandButton(
                      icon: Icons.save_outlined,
                      label: 'حفظ',
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    _CommandButton(
                      icon: Icons.play_arrow,
                      label: 'تشغيل',
                      onPressed: () {},
                    ),
                    _CommandButton(
                      icon: Icons.stop,
                      label: 'إيقاف',
                      onPressed: () {},
                    ),
                    _CommandButton(
                      icon: Icons.restart_alt,
                      label: 'إعادة تشغيل',
                      onPressed: () {},
                    ),
                    _CommandButton(
                      icon: Icons.bug_report_outlined,
                      label: 'تصحيح',
                      onPressed: () {},
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
    required this.hasUnsavedChanges,
  });

  final TextEditingController controller;
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
            trailing: hasUnsavedChanges ? 'تغييرات غير محفوظة' : 'محفوظ مؤقتا',
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
  const _OutputPanel();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            icon: Icons.terminal,
            title: 'المخرجات والسجلات',
            trailing: 'جاهز',
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('ستظهر رسائل التشغيل، الأخطاء، والسجلات هنا.'),
            ),
          ),
        ],
      ),
    );
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
  });

  final IconData icon;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Text(trailing, style: Theme.of(context).textTheme.bodySmall),
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
