import 'package:flutter/material.dart';

class ProModePage extends StatelessWidget {
  const ProModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _CommandBar(),
          SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Expanded(child: _EditorPlaceholder()),
                      SizedBox(height: 12),
                      SizedBox(height: 170, child: _OutputPanel()),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(width: 260, child: _DeviceToolsPanel()),
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

class _EditorPlaceholder extends StatelessWidget {
  const _EditorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PanelHeader(
            icon: Icons.edit_note,
            title: 'المحرر',
            trailing: 'ملف غير محفوظ',
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  'اكتب هنا كود الأردوينو العربي في الخطوات القادمة...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
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
