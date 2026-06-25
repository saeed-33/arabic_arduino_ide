import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../domain/pro_mode_log_entry.dart';
import '../domain/serial_log_entry.dart';
import '../../../app/app_persistence.dart';
import '../../settings/application/settings_controller.dart';
import 'pro_mode_compiler_adapter.dart';
import 'pro_mode_file_service.dart';

enum ProModeExecutionState {
  idle,
  running,
  uploading,
  success,
  failed,
  stopped,
}

class ProModeSessionController extends ChangeNotifier {
  ProModeSessionController({
    ProModeFileService? fileService,
    ProModeCompilerAdapter? compilerAdapter,
    SettingsController? settingsController,
    AppPersistence? persistence,
  }) : _fileService = fileService ?? ProModeFileService(),
        _compilerAdapter = compilerAdapter ?? const ProModeCompilerAdapter(),
        _settingsController =
            settingsController ?? SettingsController(persistence: persistence),
        _persistence = persistence {
    editorController.addListener(_handleCodeChanged);
    _loadSessionState();
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

  final ProModeFileService      _fileService;
  final ProModeCompilerAdapter  _compilerAdapter;
  final SettingsController      _settingsController;
  final TextEditingController   editorController =
  TextEditingController(text: initialCode);

  // ── سجل التنفيذ ──────────────────────────────────────────────
  final List<ProModeLogEntry> _logs = [];

  // ── حالة الملف ───────────────────────────────────────────────
  String? _currentFilePath;
  String  _lastSavedText      = initialCode;
  bool    _hasUnsavedChanges  = false;

  // ── حالة التنفيذ ─────────────────────────────────────────────
  String                _statusMessage  = 'جاهز.';
  Process?              _compilerProcess;
  AppPersistence?       _persistence;
  ProModeExecutionState _executionState = ProModeExecutionState.idle;

  // ── المنافذ ───────────────────────────────────────────────────
  List<String> _availablePorts    = [];
  String?      _selectedPort;
  bool         _isRefreshingPorts = false;
  bool         _isFlashing        = false;

  // ── السيريال مونيتور ──────────────────────────────────────────
  final List<SerialLogEntry> _serialLog    = [];
  bool                       _isSerialOpen = false;
  int                        _baudRate     = 9600;
  StreamSubscription<String>? _serialSub;

  // ══════════════════════════════════════════════════════════════
  //  Getters
  // ══════════════════════════════════════════════════════════════

  List<ProModeLogEntry>  get logs             => List.unmodifiable(_logs);
  bool                   get hasUnsavedChanges => _hasUnsavedChanges;
  String                 get statusMessage     => _statusMessage;
  ProModeExecutionState  get executionState    => _executionState;
  List<String>           get availablePorts    => List.unmodifiable(_availablePorts);
  bool                   get isRefreshingPorts => _isRefreshingPorts;
  bool                   get isFlashing        => _isFlashing;
  bool                   get isRunning         => _compilerProcess != null;

  // السيريال
  bool                   get isSerialOpen => _isSerialOpen;
  List<SerialLogEntry>   get serialLog    => List.unmodifiable(_serialLog);

  String get executionStateLabel => switch (_executionState) {
    ProModeExecutionState.idle      => 'خامل',
    ProModeExecutionState.running   => 'تشغيل',
    ProModeExecutionState.uploading => 'رفع',
    ProModeExecutionState.success   => 'نجاح',
    ProModeExecutionState.failed    => 'فشل',
    ProModeExecutionState.stopped   => 'تم الإيقاف',
  };

  String? get selectedPort {
    if (_selectedPort != null && _selectedPort!.isNotEmpty) return _selectedPort;
    final p = _settingsController.settings.serialPort;
    return p.isNotEmpty ? p : null;
  }

  String get deviceStatusMessage => _isFlashing
      ? 'جاري رفع البرنامج إلى اللوحة...'
      : selectedPort != null
      ? 'المنفذ المحدد: $selectedPort'
      : 'لم يتم تحديد منفذ.';

  String get fileLabel {
    final path = _currentFilePath;
    return path == null ? 'ملف جديد' : _fileService.displayNameForPath(path);
  }

  // ══════════════════════════════════════════════════════════════
  //  السيريال مونيتور
  // ══════════════════════════════════════════════════════════════

  /// يفتح اتصال السيريال على المنفذ المحدد بالـ baud rate المطلوب.
  Future<void> openSerial(int baudRate) async {
    if (_isSerialOpen) {
      _setStatus('منفذ السيريال مفتوح بالفعل.', ProModeLogLevel.warning);
      return;
    }

    final port = selectedPort;
    if (port == null) {
      _setStatus('حدد منفذاً أولاً قبل فتح السيريال.', ProModeLogLevel.warning);
      return;
    }

    _baudRate     = baudRate;
    _isSerialOpen = true;
    notifyListeners();

    _setStatus('تم فتح السيريال على $port بـ $baudRate baud.', ProModeLogLevel.success);

    // ── الاتصال الحقيقي بالسيريال ────────────────────────────
    // يستخدم flutter_libserialport أو flutter_serial_port حسب ما هو متاح.
    // المثال أدناه يُظهر الهيكل — استبدله بمكتبة السيريال التي تستخدمها.
    try {
      await _compilerAdapter.openSerialPort(
        port:     port,
        baudRate: baudRate,
        onData:   (line) {
          _serialLog.add(SerialLogEntry.received(line));
          notifyListeners();
        },
        onError: (err) {
          _addLog('خطأ سيريال: $err', ProModeLogLevel.error);
          _isSerialOpen = false;
          notifyListeners();
        },
        onDone: () {
          _isSerialOpen = false;
          _setStatus('انقطع اتصال السيريال.', ProModeLogLevel.warning);
        },
      );
    } catch (e) {
      _isSerialOpen = false;
      _setStatus('فشل فتح السيريال: $e', ProModeLogLevel.error);
    }
  }

  /// يغلق اتصال السيريال.
  void closeSerial() {
    if (!_isSerialOpen) return;
    _compilerAdapter.closeSerialPort();
    _isSerialOpen = false;
    _setStatus('تم إغلاق منفذ السيريال.', ProModeLogLevel.info);
  }

  /// يرسل نصاً عبر السيريال.
  void serialSend(String message) {
    if (!_isSerialOpen) {
      _setStatus('افتح منفذ السيريال أولاً.', ProModeLogLevel.warning);
      return;
    }
    _compilerAdapter.writeToSerialPort(message);
    _serialLog.add(SerialLogEntry.sent(message));
    notifyListeners();
  }

  /// يمسح سجل السيريال.
  void clearSerialLog() {
    _serialLog.clear();
    notifyListeners();
  }

  /// يغيّر الـ baud rate (يُغلق ويفتح من جديد إذا كان مفتوحاً).
  void setSerialBaudRate(int baudRate) {
    if (_baudRate == baudRate) return;
    _baudRate = baudRate;
    if (_isSerialOpen) {
      closeSerial();
      openSerial(baudRate);
    }
  }

  // ══════════════════════════════════════════════════════════════
  //  الملفات
  // ══════════════════════════════════════════════════════════════

  Future<void> createNewFile() async {
    _currentFilePath   = null;
    _lastSavedText     = '';
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
      await _persistLastOpenedFilePath(file.path);
      _setStatus(
        'تم فتح الملف: ${_fileService.displayNameForPath(file.path)}',
        ProModeLogLevel.success,
      );
    } on FileDialogUnavailableException {
      _setStatus(
        'خدمة اختيار الملفات غير جاهزة. أوقف التطبيق ثم شغّله من جديد.',
        ProModeLogLevel.error,
      );
    } on FileSystemException catch (e) {
      _setStatus('تعذر فتح الملف: ${e.message}', ProModeLogLevel.error);
    }
  }

  Future<void> saveFile() async {
    try {
      final savedPath = await _fileService.saveCodeFile(
        content:     editorController.text,
        currentPath: _currentFilePath,
      );
      if (savedPath == null) {
        _setStatus('تم إلغاء حفظ الملف.', ProModeLogLevel.warning);
        return;
      }
      _markSaved(savedPath);
      await _persistLastOpenedFilePath(savedPath);
      _setStatus(
        'تم حفظ الملف: ${_fileService.displayNameForPath(savedPath)}',
        ProModeLogLevel.success,
      );
    } on FileDialogUnavailableException {
      _setStatus(
        'خدمة اختيار الملفات غير جاهزة. أوقف التطبيق ثم شغّله من جديد.',
        ProModeLogLevel.error,
      );
    } on FileSystemException catch (e) {
      _setStatus('تعذر حفظ الملف: ${e.message}', ProModeLogLevel.error);
    }
  }

  // ══════════════════════════════════════════════════════════════
  //  التنفيذ
  // ══════════════════════════════════════════════════════════════

  Future<void> runProgram() async {
    if (isRunning) {
      _setStatus('المترجم يعمل بالفعل.', ProModeLogLevel.warning);
      return;
    }
    _executionState = ProModeExecutionState.running;
    _setStatus('جاري تشغيل المترجم...', ProModeLogLevel.info);

    try {
      _compilerProcess = await _compilerAdapter.startCompilerProcess(
        editorController.text,
        _handleCompilerStdout,
        _handleCompilerStderr,
      );
      _compilerProcess!.exitCode.then((code) {
        if (_executionState != ProModeExecutionState.stopped) {
          if (code == 0) {
            _executionState = ProModeExecutionState.success;
            _setStatus('انتهت الترجمة بنجاح.', ProModeLogLevel.success);
          } else {
            _executionState = ProModeExecutionState.failed;
            _setStatus('فشلت الترجمة برمز $code.', ProModeLogLevel.error);
          }
        }
        _compilerProcess = null;
        notifyListeners();
      });
    } on CompilerNotFoundException catch (e) {
      _setStatus(e.message, ProModeLogLevel.error);
    } on FileSystemException catch (e) {
      _setStatus('خطأ في نظام الملفات: ${e.message}', ProModeLogLevel.error);
    } catch (e) {
      _setStatus('فشل بدء المترجم: $e', ProModeLogLevel.error);
      _compilerProcess = null;
    }
  }

  Future<void> stopProgram() async {
    if (_compilerProcess == null) {
      _setStatus('لا توجد عملية لإيقافها.', ProModeLogLevel.info);
      return;
    }
    _compilerProcess!.kill(ProcessSignal.sigint);
    _executionState = ProModeExecutionState.stopped;
    _setStatus('جاري إيقاف المترجم...', ProModeLogLevel.info);
    await _compilerProcess!.exitCode;
    _compilerProcess = null;
    _setStatus('تم إيقاف المترجم.', ProModeLogLevel.warning);
  }

  Future<void> restartProgram() async {
    if (isRunning) await stopProgram();
    await runProgram();
  }

  Future<void> debugProgram() async {
    _setStatus(
      'التصحيح غير متاح بعد.',
      ProModeLogLevel.warning,
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  المنافذ
  // ══════════════════════════════════════════════════════════════

  Future<void> refreshAvailablePorts() async {
    if (_isRefreshingPorts) return;
    _isRefreshingPorts = true;
    _setStatus('جاري البحث عن المنافذ...', ProModeLogLevel.info);
    notifyListeners();

    try {
      final ports = await _compilerAdapter.listAvailablePorts(
            (l) => _addLog(l, ProModeLogLevel.info),
            (l) => _addLog(l, ProModeLogLevel.error),
      );
      _availablePorts = ports;
      if (ports.isNotEmpty) {
        _selectedPort ??= ports.first;
        _setStatus('تم العثور على المنافذ.', ProModeLogLevel.success);
      } else {
        _selectedPort = null;
        _setStatus('لم يُعثر على أي منفذ.', ProModeLogLevel.warning);
      }
    } on CompilerNotFoundException catch (e) {
      _setStatus(e.message, ProModeLogLevel.error);
    } on FileSystemException catch (e) {
      _setStatus('تعذر فحص المنافذ: ${e.message}', ProModeLogLevel.error);
    } catch (e) {
      _setStatus('فشل فحص المنافذ: $e', ProModeLogLevel.error);
    } finally {
      _isRefreshingPorts = false;
      notifyListeners();
    }
  }

  void selectPort(String? port) {
    _selectedPort = port;
    _settingsController.updateSerialPort(port ?? '');
    _settingsController.persistSettings();
    _setStatus(
      port != null ? 'تم تحديد المنفذ $port.' : 'تم مسح المنفذ.',
      ProModeLogLevel.info,
    );
  }

  Future<void> flashProgram() async {
    if (_isFlashing) {
      _setStatus('عملية الرفع جارية.', ProModeLogLevel.warning);
      return;
    }
    if (selectedPort == null) {
      _setStatus('حدد منفذاً قبل الرفع.', ProModeLogLevel.warning);
      return;
    }
    if (isRunning) {
      _setStatus('أوقف الترجمة أولاً.', ProModeLogLevel.warning);
      return;
    }

    _isFlashing     = true;
    _executionState = ProModeExecutionState.uploading;
    _setStatus('جاري التجميع...', ProModeLogLevel.info);
    notifyListeners();

    try {
      final compile = await _compilerAdapter.startCompilerProcess(
        editorController.text,
        _handleCompilerStdout,
        _handleCompilerStderr,
      );
      _compilerProcess = compile;
      final compileCode = await compile.exitCode;
      _compilerProcess = null;

      if (compileCode != 0) {
        _executionState = ProModeExecutionState.failed;
        _setStatus('فشل التجميع برمز $compileCode.', ProModeLogLevel.error);
        return;
      }

      _setStatus('جاري الرفع إلى $_selectedPort...', ProModeLogLevel.info);
      final flash     = await _compilerAdapter.flashFirmware(
        _selectedPort!,
        _handleCompilerStdout,
        _handleCompilerStderr,
      );
      final flashCode = await flash.exitCode;
      if (flashCode == 0) {
        _executionState = ProModeExecutionState.success;
        _setStatus('تم الرفع بنجاح.', ProModeLogLevel.success);
      } else {
        _executionState = ProModeExecutionState.failed;
        _setStatus('فشل الرفع برمز $flashCode.', ProModeLogLevel.error);
      }
    } on CompilerNotFoundException catch (e) {
      _setStatus(e.message, ProModeLogLevel.error);
    } on FileSystemException catch (e) {
      _setStatus('تعذر الرفع: ${e.message}', ProModeLogLevel.error);
    } catch (e) {
      _setStatus('فشل الرفع: $e', ProModeLogLevel.error);
    } finally {
      _isFlashing = false;
      notifyListeners();
    }
  }

  void clearLogs() {
    _logs.clear();
    _setStatus('تم مسح السجلات.', ProModeLogLevel.info);
  }

  // ══════════════════════════════════════════════════════════════
  //  dispose
  // ══════════════════════════════════════════════════════════════

  @override
  void dispose() {
    closeSerial();
    editorController
      ..removeListener(_handleCodeChanged)
      ..dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════
  //  helpers خاصة
  // ══════════════════════════════════════════════════════════════

  void _handleCodeChanged() {
    final changed = editorController.text != _lastSavedText;
    if (changed == _hasUnsavedChanges) return;
    _hasUnsavedChanges = changed;
    notifyListeners();
  }

  void _markSaved(String path) {
    _currentFilePath   = path;
    _lastSavedText     = editorController.text;
    _hasUnsavedChanges = false;
  }

  void _setEditorText(String text) {
    editorController.text      = text;
    editorController.selection = TextSelection.collapsed(offset: text.length);
  }

  void _setStatus(String message, ProModeLogLevel level) {
    _statusMessage = message;
    _addLog(message, level);
    notifyListeners();
  }

  void _handleCompilerStdout(String line) => _addLog(line, ProModeLogLevel.info);
  void _handleCompilerStderr(String line) => _addLog(line, ProModeLogLevel.error);

  /// يضيف سجل في النهاية (الأحدث في الأسفل)
  void _addLog(String message, ProModeLogLevel level) {
    _logs.add(
      ProModeLogEntry(
        message:   message,
        level:     level,
        createdAt: DateTime.now(),
      ),
    );
  }

  void _loadSessionState() {
    if (_persistence == null) return;
    _settingsController.loadSettings();
    _selectedPort = _settingsController.settings.serialPort.isNotEmpty
        ? _settingsController.settings.serialPort
        : null;

    final lastPath = _persistence!.loadLastOpenedFilePath();
    if (lastPath == null || lastPath.isEmpty) return;
    final file = File(lastPath);
    if (!file.existsSync()) return;

    try {
      final content = file.readAsStringSync();
      _setEditorText(content);
      _markSaved(lastPath);
      _setStatus(
        'تم استعادة الملف: ${_fileService.displayNameForPath(lastPath)}',
        ProModeLogLevel.info,
      );
    } catch (e) {
      _setStatus('فشل استعادة الملف: $e', ProModeLogLevel.error);
    }
  }

  Future<void> _persistLastOpenedFilePath(String? path) async {
    if (_persistence == null) return;
    await _persistence!.saveLastOpenedFilePath(path);
    if (path != null && path.isNotEmpty) {
      await _persistence!.addRecentFile(path);
    }
  }
}