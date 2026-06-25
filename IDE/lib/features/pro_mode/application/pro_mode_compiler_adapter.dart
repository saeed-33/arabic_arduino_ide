import 'dart:async';
import 'dart:convert';
import 'dart:io';

class CompilerNotFoundException implements Exception {
  CompilerNotFoundException(this.message);

  final String message;

  @override
  String toString() => 'CompilerNotFoundException: $message';
}

class ProModeCompilerAdapter {
  const ProModeCompilerAdapter();

  Future<Directory> _findCompilerDirectory() async {
    final candidates = <String>[
      '../arduino_arabic_compiler/ArduinoArabicCompiler',
      'arduino_arabic_compiler/ArduinoArabicCompiler',
      '../ArduinoArabicCompiler',
      'ArduinoArabicCompiler',
    ].map((path) => Directory(path)).toList();

    for (final candidate in candidates) {
      if (await File(
        '${candidate.path}${Platform.pathSeparator}main.py',
      ).exists()) {
        return candidate.absolute;
      }
    }

    throw CompilerNotFoundException(
      'تعذر العثور على مجلد المترجم تحت مسارات: ${candidates.map((c) => c.path).join(', ')}',
    );
  }

  String _pythonExecutable(Directory compilerDirectory) {
    final venv = File(
      '${compilerDirectory.path}${Platform.pathSeparator}.venv${Platform.pathSeparator}Scripts${Platform.pathSeparator}python.exe',
    );
    if (venv.existsSync()) {
      return venv.path;
    }

    return 'python';
  }

  Future<Process> startCompilerProcess(
    String source,
    void Function(String line) onStdout,
    void Function(String line) onStderr,
  ) async {
    final compilerDir = await _findCompilerDirectory();
    final python = _pythonExecutable(compilerDir);
    final testFile = File(
      '${compilerDir.path}${Platform.pathSeparator}test_arduino.txt',
    );
    String? originalText;
    if (await testFile.exists()) {
      originalText = await testFile.readAsString(encoding: utf8);
    }

    await testFile.writeAsString(source, encoding: utf8);

    final process = await Process.start(
      python,
      ['build.py', 'compile'],
      workingDirectory: compilerDir.path,
      environment: {'PYTHONIOENCODING': 'utf-8'},
      runInShell: false,
    );

    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(onStdout);
    process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(onStderr);

    process.exitCode.whenComplete(() async {
      if (originalText != null) {
        await testFile.writeAsString(originalText, encoding: utf8);
      } else if (await testFile.exists()) {
        await testFile.delete();
      }
    });

    return process;
  }

  Future<List<String>> listAvailablePorts(
    void Function(String line) onStdout,
    void Function(String line) onStderr,
  ) async {
    final compilerDir = await _findCompilerDirectory();
    final python = _pythonExecutable(compilerDir);
    final ports = <String>{};
    final process = await Process.start(
      python,
      ['build.py', 'ports'],
      workingDirectory: compilerDir.path,
      environment: {'PYTHONIOENCODING': 'utf-8'},
      runInShell: false,
    );

    final portPattern = RegExp(r'(COM\d+|/dev/tty\S+)');

    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
          onStdout(line);
          for (final match in portPattern.allMatches(line)) {
            ports.add(match.group(0)!);
          }
        });
    process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(onStderr);

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw FileSystemException(
        'Failed to list Arduino ports.',
        compilerDir.path,
      );
    }

    return ports.toList();
  }

  Future<Process> flashFirmware(
    String port,
    void Function(String line) onStdout,
    void Function(String line) onStderr,
  ) async {
    final compilerDir = await _findCompilerDirectory();
    final python = _pythonExecutable(compilerDir);
    final process = await Process.start(
      python,
      ['build.py', 'flash', port],
      workingDirectory: compilerDir.path,
      environment: {'PYTHONIOENCODING': 'utf-8'},
      runInShell: false,
    );

    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(onStdout);
    process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(onStderr);

    return process;
  }
}
