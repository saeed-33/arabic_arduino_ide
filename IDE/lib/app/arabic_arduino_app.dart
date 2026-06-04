import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'home_shell.dart';

class ArabicArduinoApp extends StatelessWidget {
  const ArabicArduinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بيئة أردوينو العربية',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomeShell(),
      ),
    );
  }
}
