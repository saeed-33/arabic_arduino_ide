import 'package:flutter/material.dart';

import 'app/arabic_arduino_app.dart';
import 'app/app_persistence.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final persistence = await AppPersistence.initialize();
  runApp(ArabicArduinoApp(persistence: persistence));
}
