import 'package:flutter/material.dart';

import '../features/help/help_page.dart';
import '../features/kids_mode/kids_mode_page.dart';
import '../features/pro_mode/pro_mode_page.dart';
import '../features/settings/settings_page.dart';

enum AppSection { proMode, kidsMode, help, settings }

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  AppSection _section = AppSection.proMode;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = AppSection.values.indexOf(_section);

    return Scaffold(
      appBar: AppBar(
        title: const Text('بيئة أردوينو العربية'),
        actions: [
          IconButton(
            tooltip: 'المساعدة',
            onPressed: () => setState(() => _section = AppSection.help),
            icon: const Icon(Icons.help_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _section = AppSection.values[index]);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.code),
                label: Text('المحترف'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.extension),
                label: Text('التعلم'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.help_outline),
                label: Text('مساعدة'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                label: Text('إعدادات'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _buildSection()),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return switch (_section) {
      AppSection.proMode => const ProModePage(),
      AppSection.kidsMode => const KidsModePage(),
      AppSection.help => const HelpPage(),
      AppSection.settings => const SettingsPage(),
    };
  }
}
