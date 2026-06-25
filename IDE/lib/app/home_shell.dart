import 'package:flutter/material.dart';

import '../features/developer_mode/developer_mode_page.dart';
import '../features/help/help_page.dart';
import '../features/kids_mode/kids_mode_page.dart';
import '../features/pro_mode/application/pro_mode_session_controller.dart';
import '../features/pro_mode/pro_mode_page.dart';
import '../features/settings/application/settings_controller.dart';
import '../features/settings/settings_page.dart';
import 'app_persistence.dart';

enum AppSection { proMode, kidsMode, developerMode, help, settings }

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.persistence});
  final AppPersistence persistence;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  AppSection _section = AppSection.proMode;

  late final SettingsController _settingsController;
  late final ProModeSessionController _proModeSessionController;

  @override
  void initState() {
    super.initState();
    _settingsController = SettingsController(persistence: widget.persistence);
    _proModeSessionController = ProModeSessionController(
      settingsController: _settingsController,
      persistence: widget.persistence,
    );
  }

  @override
  void dispose() {
    _proModeSessionController.dispose();
    super.dispose();
  }

  int get _selectedIndex => AppSection.values.indexOf(_section);

  void _onSelect(int index) {
    setState(() => _section = AppSection.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيئة أردوينو العربية'),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onSelect,
            labelType: NavigationRailLabelType.all,
            groupAlignment: -0.9,
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
                icon: Icon(Icons.developer_mode),
                label: Text('المطور'),
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
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                ProModePage(controller: _proModeSessionController),
                const KidsModePage(),
                DeveloperModePage(
                  sourceProvider: () =>
                  _proModeSessionController.editorController.text,
                ),
                const HelpPage(),
                SettingsPage(controller: _settingsController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}