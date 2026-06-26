# Arabic Arduino IDE

A Flutter desktop application for writing, compiling, and uploading Arabic Arduino programs to real Arduino hardware.

> 🌐 **Language**: Arabic (RTL) user interface with English code identifiers.
> 🖥️ **Platform**: Windows desktop (Linux and macOS can be enabled).
> 🔌 **Hardware**: Arduino Uno and compatible ATmega328P boards.

---

## What is this?

The **Arabic Arduino IDE** is the user-facing editor for the Arabic Arduino Compiler. It lets users write Arduino-style programs using Arabic keywords and built-ins, then compile and flash them onto an Arduino board.

The IDE provides multiple modes for different skill levels:

| Mode | Description |
|------|-------------|
| **Pro Mode** | Full text editor with syntax highlighting, compiler output, and device tools. |
| **Kids Mode** | Simplified interface for young learners. |
| **Learning Mode** | Guided lessons and block-based coding. |
| **Developer Mode** | Inspect compiler internals: tokens, AST, LLVM IR, and diagnostics. |

---

## Features

- ✅ Arabic right-to-left (RTL) user interface
- ✅ Syntax highlighting for Arabic and C++/Arduino keywords
- ✅ Line numbers and custom RTL code editor
- ✅ File open/save support
- ✅ Compile button that runs the Arabic Arduino Compiler
- ✅ Output panel for compiler logs
- ✅ Device tools panel for port selection and flashing
- ✅ Settings page for preferences
- ✅ Developer mode diagnostics panel

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x or newer
- Windows 10/11
- Visual Studio 2022 with C++ desktop workload (for building Windows desktop apps)

### Installation

1. Open a terminal in the `IDE/` directory.

2. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

3. Enable Windows desktop support (if not already enabled):

   ```bash
   flutter config --enable-windows-desktop
   ```

4. Run the app:

   ```bash
   flutter run -d windows
   ```

### Build a release version

```bash
flutter build windows
```

The executable will be located at:

```text
build/windows/x64/runner/Release/arabic_arduino_ide.exe
```

---

## Project Structure

```text
IDE/
├── lib/
│   ├── main.dart
│   ├── app/                  # App shell, theme, navigation, persistence
│   └── features/
│       ├── pro_mode/         # Professional text editor
│       ├── kids_mode/        # Simplified kids UI
│       ├── learning_mode/    # Guided learning
│       ├── developer_mode/   # Compiler diagnostics and internals
│       ├── settings/         # User preferences
│       └── help/             # Help page
├── pubspec.yaml
├── windows/                  # Windows CMake build files
└── README.md
```

---

## Usage

### Write Arabic Arduino code

In **Pro Mode**, type code using Arabic keywords:

```arabic
دالة اعداد():فارغ {
    وضع_الطرف(13, مخرج);
}

دالة تكرار():فارغ {
    اكتب_رقمي(13, عالي);
    انتظر(1000);
    اكتب_رقمي(13, منخفض);
    انتظر(1000);
}
```

### Compile

Click the **تشغيل** (Run) button. The IDE will call the Arabic Arduino Compiler and show the output in the bottom panel.

### Flash to Arduino

1. Connect your Arduino Uno via USB.
2. Select the correct COM port in the device tools panel.
3. Click **رفع إلى اللوحة** (Upload).

---

## Compiler Integration

The IDE shells out to the Python compiler located in `ArduinoArabicCompiler/`. Make sure the compiler is set up before using compile/flash features.

See `ArduinoArabicCompiler/docs/IDE_INTEGRATION_GUIDE.md` for the integration contract.

---

## Development

For detailed developer documentation, see:

📄 [`guide_docs/IDE_DEVELOPER_GUIDE.md`](../guide_docs/IDE_DEVELOPER_GUIDE.md)

It covers:

- Architecture and state management
- How to add new features
- Step-by-step workflows
- Testing strategy
- Troubleshooting
- Code style conventions

### Quick commands

```bash
flutter pub get          # Install dependencies
flutter analyze          # Static analysis
flutter run -d windows   # Run the app
flutter test             # Run tests
flutter build windows    # Build release
```

---

## Contributing

Contributions are welcome! Please:

1. Read the developer guide.
2. Follow the feature-based folder structure.
3. Run `flutter analyze` and `flutter test` before submitting changes.
4. Keep the UI RTL-friendly.

---

## License

This project is part of the Arabic Arduino IDE workspace. See the repository license for details.

---

## Support

If you encounter issues:

- Check the troubleshooting section in the developer guide.
- Verify the compiler is installed and working.
- Ensure your Arduino board drivers (CH340/CP210x) are installed if using a clone board.
