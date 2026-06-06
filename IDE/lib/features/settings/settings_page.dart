import 'package:flutter/material.dart';

import 'application/settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SettingsController();
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
        final settings = _controller.settings;

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'الإعدادات',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _controller.reset,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('إعادة ضبط'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_controller.statusMessage),
            const SizedBox(height: 24),
            _SettingsField(
              label: 'مسار Arduino CLI',
              hint: r'C:\Tools\arduino-cli.exe',
              initialValue: settings.arduinoCliPath,
              onChanged: _controller.updateArduinoCliPath,
            ),
            const SizedBox(height: 16),
            _SettingsField(
              label: 'اللوحة الافتراضية',
              hint: 'arduino:avr:uno',
              initialValue: settings.defaultBoard,
              onChanged: _controller.updateDefaultBoard,
            ),
            const SizedBox(height: 16),
            _SettingsField(
              label: 'المنفذ التسلسلي',
              hint: 'COM3',
              initialValue: settings.serialPort,
              onChanged: _controller.updateSerialPort,
            ),
            const SizedBox(height: 16),
            _SettingsField(
              label: 'رابط خادم المكتبات',
              hint: 'https://example.com/libraries',
              initialValue: settings.librariesServerUrl,
              textDirection: TextDirection.ltr,
              onChanged: _controller.updateLibrariesServerUrl,
            ),
          ],
        );
      },
    );
  }
}

class _SettingsField extends StatelessWidget {
  const _SettingsField({
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.onChanged,
    this.textDirection,
  });

  final String label;
  final String hint;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('$label-$initialValue'),
      initialValue: initialValue,
      onChanged: onChanged,
      textDirection: textDirection ?? TextDirection.rtl,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
