import 'package:flutter_test/flutter_test.dart';

import 'package:arabic_arduino_ide/app/arabic_arduino_app.dart';

void main() {
  testWidgets('shows Arabic IDE shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ArabicArduinoApp());

    expect(find.text('بيئة أردوينو العربية'), findsOneWidget);
    expect(find.text('المحترف'), findsOneWidget);
    expect(find.text('التعلم'), findsOneWidget);
    expect(find.text('مساعدة'), findsWidgets);
    expect(find.text('إعدادات'), findsOneWidget);

    await tester.tap(find.text('التعلم'));
    await tester.pump();

    expect(find.text('وضع التعلم'), findsOneWidget);
  });
}
