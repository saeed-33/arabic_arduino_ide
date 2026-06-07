import 'package:flutter/material.dart';

import '../features/developer_mode/developer_mode_page.dart';
import '../features/help/help_page.dart';
import '../features/kids_mode/kids_mode_page.dart';
import '../features/pro_mode/application/pro_mode_session_controller.dart';
import '../features/pro_mode/pro_mode_page.dart';
import '../features/settings/settings_page.dart';

enum AppSection { proMode, kidsMode, developerMode, help, settings }

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  AppSection _section = AppSection.proMode;
  late final ProModeSessionController _proModeSessionController;

  @override
  void initState() {
    super.initState();
    _proModeSessionController = ProModeSessionController();
  }

  @override
  void dispose() {
    _proModeSessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيئة أردوينو العربية'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _SectionNavBar(
            selectedSection: _section,
            onSelected: (section) => setState(() => _section = section),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'المساعدة',
            onPressed: () => setState(() => _section = AppSection.help),
            icon: const Icon(Icons.help_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildSection(),
    );
  }

  Widget _buildSection() {
    return switch (_section) {
      AppSection.proMode => ProModePage(controller: _proModeSessionController),
      AppSection.kidsMode => const KidsModePage(),
      AppSection.developerMode => DeveloperModePage(
        sourceProvider: () => _proModeSessionController.editorController.text,
      ),
      AppSection.help => const HelpPage(),
      AppSection.settings => const SettingsPage(),
    };
  }
}

class _SectionNavBar extends StatelessWidget {
  const _SectionNavBar({
    required this.selectedSection,
    required this.onSelected,
  });

  final AppSection selectedSection;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _SectionNavButton(
            section: AppSection.proMode,
            selectedSection: selectedSection,
            icon: Icons.code,
            label: 'المحترف',
            onSelected: onSelected,
          ),
          _SectionNavButton(
            section: AppSection.kidsMode,
            selectedSection: selectedSection,
            icon: Icons.extension,
            label: 'التعلم',
            onSelected: onSelected,
          ),
          _SectionNavButton(
            section: AppSection.developerMode,
            selectedSection: selectedSection,
            icon: Icons.developer_mode,
            label: 'المطور',
            onSelected: onSelected,
          ),
          _SectionNavButton(
            section: AppSection.help,
            selectedSection: selectedSection,
            icon: Icons.help_outline,
            label: 'مساعدة',
            onSelected: onSelected,
          ),
          _SectionNavButton(
            section: AppSection.settings,
            selectedSection: selectedSection,
            icon: Icons.settings_outlined,
            label: 'إعدادات',
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}

class _SectionNavButton extends StatelessWidget {
  const _SectionNavButton({
    required this.section,
    required this.selectedSection,
    required this.icon,
    required this.label,
    required this.onSelected,
  });

  final AppSection section;
  final AppSection selectedSection;
  final IconData icon;
  final String label;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = section == selectedSection;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8),
      child: isSelected
          ? FilledButton.icon(
              onPressed: () => onSelected(section),
              icon: Icon(icon),
              label: Text(label),
            )
          : OutlinedButton.icon(
              onPressed: () => onSelected(section),
              icon: Icon(icon),
              label: Text(label),
            ),
    );
  }
}
