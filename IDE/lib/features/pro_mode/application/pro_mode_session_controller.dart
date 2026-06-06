import 'dart:io';

import 'package:flutter/material.dart';

import '../domain/pro_mode_log_entry.dart';
import 'pro_mode_file_service.dart';

class ProModeSessionController extends ChangeNotifier {
  ProModeSessionController({ProModeFileService? fileService})
    : _fileService = fileService ?? ProModeFileService() {
    editorController.addListener(_handleCodeChanged);
    _addLog('تم تجهيز محرر وضع المحترف.', ProModeLogLevel.info);
  }

  static const initialCode = '''
ابدأ
  اجعل المنفذ 13 مخرج

كرر دائما
  شغّل المنفذ 13
  انتظر 1000
  أطفئ المنفذ 13
  انتظر 1000
نهاية
''';

  final ProModeFileService _fileService;
  final TextEditingController editorController = TextEditingController(
    text: initialCode,
  );

  final List<ProModeLogEntry> _logs = [];
  String? _currentFilePath;
  String _lastSavedText = initialCode;
  bool _hasUnsavedChanges = false;
  String _statusMessage = 'جاهز.';

  List<ProModeLogEntry> get logs => List.unmodifiable(_logs);
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  String get statusMessage => _statusMessage;

  String get fileLabel {
    final path = _currentFilePath;
    if (path == null) {
      return 'ملف جديد';
    }

    return _fileService.displayNameForPath(path);
  }

  Future<void> createNewFile() async {
    _currentFilePath = null;
    _lastSavedText = '';
    _hasUnsavedChanges = false;
    _setEditorText('');
    _setStatus('تم إنشاء ملف جديد.', ProModeLogLevel.info);
  }

  Future<void> openFile() async {
    try {
      final file = await _fileService.openCodeFile();
      if (file == null) {
        _setStatus('تم إلغاء فتح الملف.', ProModeLogLevel.warning);
        return;
      }

      _setEditorText(file.content);
      _markSaved(file.path);
      _setStatus(
        'تم فتح الملف: ${_fileService.displayNameForPath(file.path)}',
        ProModeLogLevel.success,
      );
    } on FileDialogUnavailableException {
      _setStatus(
        'خدمة اختيار الملفات غير جاهزة. أوقف التطبيق ثم شغّله من جديد بعد إضافة الحزمة.',
        ProModeLogLevel.error,
      );
    } on FileSystemException catch (error) {
      _setStatus('تعذر فتح الملف: ${error.message}', ProModeLogLevel.error);
    }
  }

  Future<void> saveFile() async {
    try {
      final savedPath = await _fileService.saveCodeFile(
        content: editorController.text,
        currentPath: _currentFilePath,
      );
      if (savedPath == null) {
        _setStatus('تم إلغاء حفظ الملف.', ProModeLogLevel.warning);
        return;
      }

      _markSaved(savedPath);
      _setStatus(
        'تم حفظ الملف: ${_fileService.displayNameForPath(savedPath)}',
        ProModeLogLevel.success,
      );
    } on FileDialogUnavailableException {
      _setStatus(
        'خدمة اختيار الملفات غير جاهزة. أوقف التطبيق ثم شغّله من جديد بعد إضافة الحزمة.',
        ProModeLogLevel.error,
      );
    } on FileSystemException catch (error) {
      _setStatus('تعذر حفظ الملف: ${error.message}', ProModeLogLevel.error);
    }
  }

  void clearLogs() {
    _logs.clear();
    _setStatus('تم مسح السجلات.', ProModeLogLevel.info);
  }

  @override
  void dispose() {
    editorController
      ..removeListener(_handleCodeChanged)
      ..dispose();
    super.dispose();
  }

  void _handleCodeChanged() {
    final hasChanges = editorController.text != _lastSavedText;
    if (hasChanges == _hasUnsavedChanges) {
      return;
    }

    _hasUnsavedChanges = hasChanges;
    notifyListeners();
  }

  void _markSaved(String filePath) {
    _currentFilePath = filePath;
    _lastSavedText = editorController.text;
    _hasUnsavedChanges = false;
  }

  void _setEditorText(String text) {
    editorController.text = text;
    editorController.selection = TextSelection.collapsed(offset: text.length);
  }

  void _setStatus(String message, ProModeLogLevel level) {
    _statusMessage = message;
    _addLog(message, level);
    notifyListeners();
  }

  void _addLog(String message, ProModeLogLevel level) {
    _logs.insert(
      0,
      ProModeLogEntry(
        message: message,
        level: level,
        createdAt: DateTime.now(),
      ),
    );
  }
}
