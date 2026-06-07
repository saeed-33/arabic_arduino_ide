import '../domain/friendly_diagnostic.dart';
import '../domain/raw_diagnostic.dart';

class FriendlyDiagnosticMapper {
  const FriendlyDiagnosticMapper();

  List<FriendlyDiagnostic> mapAll(List<RawDiagnostic> diagnostics) {
    return diagnostics.map(map).toList();
  }

  FriendlyDiagnostic map(RawDiagnostic diagnostic) {
    final message = diagnostic.message;
    if (diagnostic.code == 'PARSER_SYNTAX_ERROR' &&
        message.contains('extraneous input')) {
      return _extraneousInput(diagnostic);
    }

    if (diagnostic.code == 'PARSER_SYNTAX_ERROR' &&
        message.contains('missing')) {
      return _missingToken(diagnostic);
    }

    return FriendlyDiagnostic(
      title: 'رسالة من المترجم',
      explanation: 'أعاد المترجم رسالة تشخيصية تحتاج إلى مراجعة.',
      suggestion: 'راجع تبويب Raw Errors لمعرفة النص الكامل القادم من المترجم.',
      location: _location(diagnostic),
    );
  }

  FriendlyDiagnostic _extraneousInput(RawDiagnostic diagnostic) {
    final input = _quotedValue(diagnostic.message);
    return FriendlyDiagnostic(
      title: 'رمز في مكان غير مناسب',
      explanation: input == null
          ? 'وجد المترجم رمزا لا يسمح به مكانه الحالي في البرنامج.'
          : 'وجد المترجم "$input" في مكان لا تسمح به قواعد اللغة الحالية.',
      suggestion:
          'تأكد أن البرنامج يبدأ بتعريف متغير أو تعريف دالة. الأوامر مثل "اكتب" يجب أن تكون داخل دالة أو بلوك يسمح بالجمل.',
      location: _location(diagnostic),
    );
  }

  FriendlyDiagnostic _missingToken(RawDiagnostic diagnostic) {
    return FriendlyDiagnostic(
      title: 'جزء ناقص في الكود',
      explanation: 'يتوقع المترجم وجود رمز أو كلمة قبل أن يكتمل هذا الجزء.',
      suggestion:
          'راجع الأقواس والفواصل المنقوطة العربية "؛" ونهاية البلوكات حول هذا السطر.',
      location: _location(diagnostic),
    );
  }

  String _location(RawDiagnostic diagnostic) {
    return 'السطر ${diagnostic.line}، العمود ${diagnostic.column}';
  }

  String? _quotedValue(String message) {
    final match = RegExp("'([^']+)'").firstMatch(message);
    return match?.group(1);
  }
}
