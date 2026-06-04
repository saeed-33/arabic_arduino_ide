import 'package:flutter/material.dart';

class ProModePage extends StatelessWidget {
  const ProModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PageSurface(
      title: 'وضع المحترف',
      subtitle: 'هنا سنبني محرر اللغة العربية للأردوينو خطوة بخطوة.',
      children: [
        _PlaceholderPanel(
          title: 'المحرر',
          body: 'سيظهر محرر النصوص العربي في خطوة لاحقة.',
          icon: Icons.edit_note,
        ),
        _PlaceholderPanel(
          title: 'التشغيل والسجلات',
          body: 'سنضيف أزرار التشغيل والمخرجات والسجلات بعد تثبيت الهيكل.',
          icon: Icons.play_circle_outline,
        ),
        _PlaceholderPanel(
          title: 'الأجهزة المتصلة',
          body: 'سيتم عرض لوحات الأردوينو والمنافذ عند بناء طبقة الأجهزة.',
          icon: Icons.usb,
        ),
      ],
    );
  }
}

class _PageSurface extends StatelessWidget {
  const _PageSurface({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        Wrap(spacing: 16, runSpacing: 16, children: children),
      ],
    );
  }
}

class _PlaceholderPanel extends StatelessWidget {
  const _PlaceholderPanel({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(body),
            ],
          ),
        ),
      ),
    );
  }
}
