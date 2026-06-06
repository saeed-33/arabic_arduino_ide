class IdeSettings {
  const IdeSettings({
    required this.arduinoCliPath,
    required this.defaultBoard,
    required this.serialPort,
    required this.librariesServerUrl,
  });

  factory IdeSettings.initial() {
    return const IdeSettings(
      arduinoCliPath: '',
      defaultBoard: 'arduino:avr:uno',
      serialPort: '',
      librariesServerUrl: '',
    );
  }

  final String arduinoCliPath;
  final String defaultBoard;
  final String serialPort;
  final String librariesServerUrl;

  IdeSettings copyWith({
    String? arduinoCliPath,
    String? defaultBoard,
    String? serialPort,
    String? librariesServerUrl,
  }) {
    return IdeSettings(
      arduinoCliPath: arduinoCliPath ?? this.arduinoCliPath,
      defaultBoard: defaultBoard ?? this.defaultBoard,
      serialPort: serialPort ?? this.serialPort,
      librariesServerUrl: librariesServerUrl ?? this.librariesServerUrl,
    );
  }
}
