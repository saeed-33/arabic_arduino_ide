// domain/serial_log_entry.dart

class SerialLogEntry {
  const SerialLogEntry({
    required this.data,
    required this.timestamp,
    required this.isSent,
  });

  /// النص المستقبَل أو المُرسَل
  final String data;

  /// الوقت — مثلاً '14:03:22.451'
  final String timestamp;

  /// true  = أرسلناه نحن
  /// false = استقبلناه من اللوحة
  final bool isSent;

  factory SerialLogEntry.received(String data) => SerialLogEntry(
        data:      data,
        timestamp: _now(),
        isSent:    false,
      );

  factory SerialLogEntry.sent(String data) => SerialLogEntry(
        data:      data,
        timestamp: _now(),
        isSent:    true,
      );

  static String _now() {
    final t = DateTime.now();
    final h  = t.hour.toString().padLeft(2, '0');
    final m  = t.minute.toString().padLeft(2, '0');
    final s  = t.second.toString().padLeft(2, '0');
    final ms = t.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
  }
}
