import 'package:flutter/foundation.dart';

import '../domain/ide_settings.dart';

class SettingsController extends ChangeNotifier {
  IdeSettings _settings = IdeSettings.initial();
  String _statusMessage = 'الإعدادات محفوظة مؤقتا داخل الجلسة الحالية فقط.';

  IdeSettings get settings => _settings;
  String get statusMessage => _statusMessage;

  void updateArduinoCliPath(String value) {
    _update(_settings.copyWith(arduinoCliPath: value));
  }

  void updateDefaultBoard(String value) {
    _update(_settings.copyWith(defaultBoard: value));
  }

  void updateSerialPort(String value) {
    _update(_settings.copyWith(serialPort: value));
  }

  void updateLibrariesServerUrl(String value) {
    _update(_settings.copyWith(librariesServerUrl: value));
  }

  void reset() {
    _settings = IdeSettings.initial();
    _statusMessage = 'تمت إعادة الإعدادات المؤقتة إلى القيم الافتراضية.';
    notifyListeners();
  }

  void _update(IdeSettings settings) {
    _settings = settings;
    _statusMessage = 'تم تحديث الإعدادات مؤقتا.';
    notifyListeners();
  }
}
