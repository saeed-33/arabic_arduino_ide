import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'application/pro_mode_session_controller.dart';
import 'domain/pro_mode_log_entry.dart';
import 'domain/serial_log_entry.dart';

// ═══════════════════════════════════════════════════════════════
//  ما يلزم إضافته في ProModeSessionController:
//
//  // الحالة
//  bool                    get isSerialOpen;
//  List<SerialLogEntry>    get serialLog;
//
//  // الأوامر
//  Future<void> openSerial(int baudRate);
//  void         closeSerial();
//  void         serialSend(String message);
//  void         clearSerialLog();
//  void         setSerialBaudRate(int baudRate);
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
//  ثوابت التنسيق — غيّرها من مكان واحد
// ═══════════════════════════════════════════════════════════════
const _kEditorFontFamily = 'Cascadia Code';
const _kEditorFontSize   = 14.0;
const _kEditorLineHeight = 1.6;
const _kLineNumberWidth  = 52.0;

// ═══════════════════════════════════════════════════════════════
//  ألوان الـ Syntax Highlighting
// ═══════════════════════════════════════════════════════════════
class _SyntaxColors {
  static const keyword  = Color(0xFF569CD6);
  static const type     = Color(0xFF4EC9B0);
  static const string   = Color(0xFFCE9178);
  static const comment  = Color(0xFF6A9955);
  static const number   = Color(0xFFB5CEA8);
  static const annotate = Color(0xFF9CDCFE);
  // المعرّفات العربية — لون دافئ مميّز عن النص العادي
  static const arabicId = Color(0xFFDCDCAA);
}

// ═══════════════════════════════════════════════════════════════
//  Syntax Highlighter بسيط لـ Dart / Arduino / C++
// ═══════════════════════════════════════════════════════════════
class _ArabicSyntaxHighlighter extends TextEditingController {
  _ArabicSyntaxHighlighter({String text = ''}) : super(text: text);

  static final _patterns = <_TokenKind, RegExp>{
    // ── تعليقات: سطر واحد وblock ──────────────────────────────
    _TokenKind.comment : RegExp(r'//[^\n]*|/\*[\s\S]*?\*/'),

    // ── النصوص: بالعربي نستخدم ' ' و" " والعادية ──────────────
    // يشمل: "..." و '...' والأقواس العربية ' ' و " "
    _TokenKind.string  : RegExp(
      '\"[^\"\\n]*\"|'       // "string"
          "\\'[^\\'\\n]*\\'"     // 'char'
          '|\u2018[^\u2019]*\u2019'  // 'نص عربي'
          '|\u201C[^\u201D]*\u201D', // "نص عربي"
    ),

    // ── الكلمات المحجوزة العربية (أولوية على الـ ID) ────────────
    _TokenKind.arabicKeyword: RegExp(
      // تحكم
      'لو|اذا|إذا|والا|وإلا|طالما|نفذ|اقطع|تجاوز|ارجع|'
      // دوال / بنية
          'دالة|مهمة|امر|أمر|اعداد|إعداد|تكرار|حلقة|'
      // قيم منطقية
          'صح|غلط|'
      // عمليات منطقية
          'او|أو|و|ليس|'
      // مكتبات
          'اضافة|إضافة|مكتبة|استيراد|'
      // طباعة
          'اكتب|أكتب',
    ),

    // ── أنواع البيانات العربية ───────────────────────────────────
    _TokenKind.arabicType: RegExp(
      'صحيح|رقم|عشري|كسري|فارغ|منطقي|نص|حرف|متغير',
    ),

    // ── الأرقام: عربية (٠-٩) وعادية + ثنائي بـ"ث" ──────────────
    _TokenKind.number: RegExp(
      r'ث[01٠١]+|'           // ثنائي: ث01 أو ث٠١
      r'[\d\u0660-\u0669]+(?:\.[\d\u0660-\u0669]+)?', // عشري عربي/لاتيني
    ),

    // ── كلمات Arduino / C++ الإنجليزية ──────────────────────────
    _TokenKind.keyword: RegExp(
      r'\b(void|int|double|float|bool|char|String|var|final|const|'
      r'return|if|else|for|while|do|switch|case|break|continue|'
      r'true|false|null|new|this|super|'
      r'setup|loop|pinMode|digitalWrite|digitalRead|analogWrite|'
      r'analogRead|delay|Serial|println|print|HIGH|LOW|INPUT|OUTPUT|'
      r'include|define|import)\b',
    ),

    // ── أنواع إنجليزية (تبدأ بحرف كبير) ─────────────────────────
    _TokenKind.type: RegExp(r'\b[A-Z][A-Za-z0-9_]*\b'),

    // ── المعرّفات العربية (ID) ────────────────────────────────────
    // [\u0621-\u064A] = أحرف عربية
    _TokenKind.arabicId: RegExp(r'[\u0621-\u064A][\u0621-\u064A\u0660-\u06690-9_]*'),

    // ── annotations ──────────────────────────────────────────────
    _TokenKind.annotate: RegExp(r'@\w+'),
  };

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final base = style ?? const TextStyle();
    final plain = base.copyWith(color: const Color(0xFF1E1E1E));
    final src   = text;

    if (src.isEmpty) {
      return TextSpan(text: src, style: plain);
    }

    // نبني قائمة من الـ tokens بترتيب الظهور
    final tokens = <_Token>[];

    for (final entry in _patterns.entries) {
      for (final m in entry.value.allMatches(src)) {
        tokens.add(_Token(start: m.start, end: m.end, kind: entry.key));
      }
    }

    // نرتّب ونزيل التداخلات (الأولوية: comment > string > keyword …)
    tokens.sort((a, b) {
      final cmp = a.start.compareTo(b.start);
      if (cmp != 0) return cmp;
      return a.kind.index.compareTo(b.kind.index);
    });

    final spans = <TextSpan>[];
    var cursor  = 0;

    for (final tok in tokens) {
      if (tok.start < cursor) continue; // متداخل مع سابقه

      if (tok.start > cursor) {
        spans.add(TextSpan(
          text: src.substring(cursor, tok.start),
          style: plain,
        ));
      }

      spans.add(TextSpan(
        text : src.substring(tok.start, tok.end),
        style: plain.copyWith(color: _colorFor(tok.kind)),
      ));
      cursor = tok.end;
    }

    if (cursor < src.length) {
      spans.add(TextSpan(text: src.substring(cursor), style: plain));
    }

    return TextSpan(style: plain, children: spans);
  }

  static Color _colorFor(_TokenKind kind) => switch (kind) {
    _TokenKind.comment       => _SyntaxColors.comment,
    _TokenKind.string        => _SyntaxColors.string,
    _TokenKind.keyword       => _SyntaxColors.keyword,
    _TokenKind.arabicKeyword => _SyntaxColors.keyword,   // نفس لون الكلمات المحجوزة
    _TokenKind.type          => _SyntaxColors.type,
    _TokenKind.arabicType    => _SyntaxColors.type,      // نفس لون الأنواع
    _TokenKind.number        => _SyntaxColors.number,
    _TokenKind.annotate      => _SyntaxColors.annotate,
    _TokenKind.arabicId      => _SyntaxColors.arabicId,
  };
}

enum _TokenKind {
  comment,
  string,
  keyword,
  arabicKeyword,  // كلمات محجوزة عربية
  type,
  arabicType,     // أنواع بيانات عربية
  number,
  annotate,
  arabicId,       // معرّفات عربية (أسماء متغيرات/دوال)
}

class _Token {
  const _Token({required this.start, required this.end, required this.kind});
  final int start, end;
  final _TokenKind kind;
}

// ═══════════════════════════════════════════════════════════════
//  ProModePage
// ═══════════════════════════════════════════════════════════════
class ProModePage extends StatefulWidget {
  const ProModePage({super.key, required this.controller});
  final ProModeSessionController controller;

  @override
  State<ProModePage> createState() => _ProModePageState();
}

class _ProModePageState extends State<ProModePage> {
  double _outputPanelFraction = 0.40;
  bool   _isResizingOutputPanel = false;
  int    _bottomTabIndex = 0; // 0 = مخرجات، 1 = سيريال مونيتور

  static const double _kMinEditorHeight = 180;
  static const double _kMinOutputHeight = 140;
  static const double _kSplitterHeight  = 10;

  @override
  Widget build(BuildContext context) {
    final sc = widget.controller;

    return AnimatedBuilder(
      animation: sc,
      builder: (context, _) => Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _CommandBar(
              onNewFile:  sc.createNewFile,
              onOpenFile: sc.openFile,
              onSaveFile: sc.saveFile,
              onRun:      sc.runProgram,
              isRunning:  sc.isRunning,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: LayoutBuilder(builder: (ctx, constraints) {
                      final total     = constraints.maxHeight;
                      final available = (total - _kSplitterHeight).clamp(0.0, double.infinity);
                      final minOut    = _kMinOutputHeight;
                      final maxOut    = (available - _kMinEditorHeight).clamp(minOut, available);
                      final outputH   = (available * _outputPanelFraction).clamp(minOut, maxOut);
                      final editorH   = (available - outputH).clamp(0.0, available);

                      return Column(
                        children: [
                          SizedBox(
                            height: editorH,
                            child: _ArabicCodeEditor(
                              controller:       sc.editorController,
                              fileLabel:        sc.fileLabel,
                              hasUnsavedChanges: sc.hasUnsavedChanges,
                            ),
                          ),
                          _HorizontalSplitter(
                            height:        _kSplitterHeight,
                            isActive:      _isResizingOutputPanel,
                            onDragStart:   () => setState(() => _isResizingOutputPanel = true),
                            onDragUpdate:  (dy) => setState(() {
                              final newOut = (outputH - dy).clamp(minOut, maxOut);
                              _outputPanelFraction =
                                  (newOut / available).clamp(0.15, 0.85);
                            }),
                            onDragEnd:     () => setState(() => _isResizingOutputPanel = false),
                          ),
                          SizedBox(
                            height: outputH,
                            child: _BottomTabPanel(
                              selectedIndex:       _bottomTabIndex,
                              onTabChanged:        (i) => setState(() => _bottomTabIndex = i),
                              statusMessage:       sc.statusMessage,
                              executionStateLabel: sc.executionStateLabel,
                              logs:                sc.logs,
                              onClearLogs:         sc.clearLogs,
                              controller:          sc,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 260,
                    child: _DeviceToolsPanel(controller: sc),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ArabicCodeEditor  (الإصلاح الجوهري هنا)
// ═══════════════════════════════════════════════════════════════
class _ArabicCodeEditor extends StatefulWidget {
  const _ArabicCodeEditor({
    required this.controller,
    required this.fileLabel,
    required this.hasUnsavedChanges,
  });

  final TextEditingController controller;
  final String fileLabel;
  final bool   hasUnsavedChanges;

  @override
  State<_ArabicCodeEditor> createState() => _ArabicCodeEditorState();
}

class _ArabicCodeEditorState extends State<_ArabicCodeEditor> {
  // ─── Syntax-aware controller ───────────────────────────────
  late final _ArabicSyntaxHighlighter _syntaxController;

  // ─── Scroll controllers مشتركة بين الأرقام والمحرر ──────────
  final _scrollController      = ScrollController();
  final _lineNumScrollController = ScrollController();
  bool  _syncingScroll         = false;

  // ─── FocusNode للـ keyboard shortcuts ──────────────────────
  final _focusNode = FocusNode();

  // عدد الأسطر — نحسبه عند كل تغيير
  int _lineCount = 1;

  // الـ line height بالـ pixels — نحسبه مرة واحدة بعد الـ build
  double _lineHeightPx = _kEditorFontSize * _kEditorLineHeight;

  @override
  void initState() {
    super.initState();

    _syntaxController = _ArabicSyntaxHighlighter(text: widget.controller.text);

    // مزامنة ثنائية الاتجاه بين الـ controllers
    widget.controller.addListener(_onExternalChange);
    _syntaxController.addListener(_onSyntaxChange);

    _scrollController.addListener(_syncLineNumbers);
    _updateLineCount(_syntaxController.text);

    // نسجّل معالج الكيبورد على الـ FocusNode مباشرة
    // بدلاً من Focus widget منفصل لتفادي "child != this" assertion
    _focusNode.onKeyEvent = _handleKeyEvent;
  }

  @override
  void didUpdateWidget(_ArabicCodeEditor old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onExternalChange);
      widget.controller.addListener(_onExternalChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onExternalChange);
    _syntaxController.removeListener(_onSyntaxChange);
    _scrollController.removeListener(_syncLineNumbers);

    _syntaxController.dispose();
    _scrollController.dispose();
    _lineNumScrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── عند تغيير الـ controller الخارجي (مثلاً فتح ملف جديد) ──
  void _onExternalChange() {
    if (_syntaxController.text != widget.controller.text) {
      _syntaxController.text = widget.controller.text;
    }
  }

  // ── عند الكتابة في الـ editor → نحدّث الـ controller الخارجي ──
  void _onSyntaxChange() {
    if (widget.controller.text != _syntaxController.text) {
      widget.controller.value = _syntaxController.value;
    }
    _updateLineCount(_syntaxController.text);
  }

  void _updateLineCount(String text) {
    final count = text.isEmpty ? 1 : '\n'.allMatches(text).length + 1;
    if (count != _lineCount) setState(() => _lineCount = count);
  }

  // ── مزامنة scroll بين الأرقام والـ editor ──────────────────
  void _syncLineNumbers() {
    if (_syncingScroll) return;
    _syncingScroll = true;
    if (_lineNumScrollController.hasClients) {
      _lineNumScrollController.jumpTo(_scrollController.offset);
    }
    _syncingScroll = false;
  }

  // ── التنقل بالأسهم: ننقل الـ cursor بين الأسطر ──────────────
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.arrowUp &&
        key != LogicalKeyboardKey.arrowDown) {
      return KeyEventResult.ignored;
    }

    final text   = _syntaxController.text;
    final sel    = _syntaxController.selection;
    if (!sel.isValid || text.isEmpty) return KeyEventResult.ignored;

    final offset = sel.baseOffset.clamp(0, text.length);

    if (key == LogicalKeyboardKey.arrowUp) {
      // نلاقي بداية السطر الحالي
      final lineStart = text.lastIndexOf('\n', offset - 1) + 1;
      if (lineStart == 0 && offset <= lineStart) {
        // أول سطر — ننقل للبداية فقط
        _moveCursorTo(0);
        return KeyEventResult.handled;
      }
      // نلاقي بداية السطر اللي قبله
      final prevLineEnd   = lineStart - 1; // موقع الـ \n السابق
      final prevLineStart = text.lastIndexOf('\n', prevLineEnd - 1) + 1;
      // نحاول نحافظ على نفس العمود
      final colInCurrent  = offset - lineStart;
      final prevLineLen   = prevLineEnd - prevLineStart;
      final newOffset     = prevLineStart + colInCurrent.clamp(0, prevLineLen);
      _moveCursorTo(newOffset);

    } else {
      // arrowDown
      final nextNewline = text.indexOf('\n', offset);
      if (nextNewline == -1) {
        // آخر سطر — ننقل لآخر حرف
        _moveCursorTo(text.length);
        return KeyEventResult.handled;
      }
      final lineStart      = text.lastIndexOf('\n', offset - 1) + 1;
      final colInCurrent   = offset - lineStart;
      final nextLineStart  = nextNewline + 1;
      final nextNextNewline = text.indexOf('\n', nextLineStart);
      final nextLineEnd    = nextNextNewline == -1 ? text.length : nextNextNewline;
      final nextLineLen    = nextLineEnd - nextLineStart;
      final newOffset      = nextLineStart + colInCurrent.clamp(0, nextLineLen);
      _moveCursorTo(newOffset);
    }

    return KeyEventResult.handled;
  }

  void _moveCursorTo(int offset) {
    _syntaxController.selection = TextSelection.collapsed(offset: offset);

    // بعد تحريك الـ cursor — نتحقق هل هو داخل الـ viewport وإلا نـ scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      // نحسب رقم السطر الجديد (0-based)
      final text    = _syntaxController.text;
      final lineNum = '\n'.allMatches(text.substring(0, offset.clamp(0, text.length))).length;
      final cursorY = lineNum * _lineHeightPx;

      final scrollOffset  = _scrollController.offset;
      final viewportHeight = _scrollController.position.viewportDimension;

      // منطقة مرئية: [scrollOffset, scrollOffset + viewportHeight]
      // نضيف هامش سطر واحد من فوق ومن تحت
      final margin = _lineHeightPx;

      if (cursorY < scrollOffset + margin) {
        // الـ cursor فوق الـ viewport — نصعد
        final target = (cursorY - margin).clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        );
      } else if (cursorY + _lineHeightPx > scrollOffset + viewportHeight - margin) {
        // الـ cursor تحت الـ viewport — ننزل
        final target = (cursorY + _lineHeightPx - viewportHeight + margin).clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // نحسب الـ lineHeightPx من الـ TextPainter مرة واحدة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tp = TextPainter(
        text: TextSpan(
          text: '0',
          style: _editorStyle(context),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.height != _lineHeightPx) {
        setState(() => _lineHeightPx = tp.height);
      }
    });

    // خلفية المحرر — لون داكن قليلاً عن الـ surface
    const editorBg = Colors.white;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            icon: Icons.edit_note,
            title: 'المحرر',
            trailing:
            '${widget.fileLabel} — '
                '${widget.hasUnsavedChanges ? 'تغييرات غير محفوظة' : 'محفوظ'}',
          ),
          Expanded(
            child: ColoredBox(
              color: editorBg,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ─── عامود الأرقام ───────────────────────
                  _LineNumberGutter(
                    lineCount:        _lineCount,
                    lineHeightPx:     _lineHeightPx,
                    scrollController: _lineNumScrollController,
                  ),
                  // ─── فاصل ───────────────────────────────
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: cs.outlineVariant.withOpacity(0.4),
                  ),
                  // ─── منطقة الكتابة ───────────────────────
                  Expanded(
                    child: TextField(
                      controller:           _syntaxController,
                      scrollController:     _scrollController,
                      focusNode:            _focusNode,
                      expands:              true,
                      maxLines:             null,
                      minLines:             null,
                      textAlignVertical:    TextAlignVertical.top,
                      textDirection:        TextDirection.rtl,
                      textAlign:            TextAlign.right,
                      keyboardType:         TextInputType.multiline,
                      textInputAction:      TextInputAction.newline,
                      enableInteractiveSelection: true,
                      autocorrect:          false,
                      enableSuggestions:    false,
                      style:                _editorStyle(context),
                      strutStyle:           StrutStyle(
                        fontFamily:         _kEditorFontFamily,
                        fontSize:           _kEditorFontSize,
                        height:             _kEditorLineHeight,
                        forceStrutHeight:   true,
                      ),
                      decoration: InputDecoration(
                        border:         InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        fillColor:      editorBg,
                        filled:         true,
                      ),
                      cursorColor: cs.primary,
                      cursorWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _editorStyle(BuildContext context) =>
      TextStyle(
        fontFamily: _kEditorFontFamily,
        fontSize:   _kEditorFontSize,
        height:     _kEditorLineHeight,
        color:      Theme.of(context).colorScheme.onSurface,
      );
}

// ═══════════════════════════════════════════════════════════════
//  _LineNumberGutter — عامود الأرقام المعدَّل
// ═══════════════════════════════════════════════════════════════
class _LineNumberGutter extends StatelessWidget {
  const _LineNumberGutter({
    required this.lineCount,
    required this.lineHeightPx,
    required this.scrollController,
  });

  final int              lineCount;
  final double           lineHeightPx;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: _kLineNumberWidth,
      child: ColoredBox(
        color: const Color(0xFFF0F0F0),
        child: ScrollConfiguration(
          // نخفي الـ scrollbar للأرقام لأنها تتبع المحرر تلقائياً
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.builder(
            controller:   scrollController,
            itemCount:    lineCount,
            // الارتفاع الثابت مهم لمزامنة الـ scroll بدقة
            itemExtent:   lineHeightPx,
            padding:      const EdgeInsets.symmetric(vertical: 14),
            itemBuilder:  (_, i) => Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  '${i + 1}',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: _kEditorFontFamily,
                    fontSize:   _kEditorFontSize - 1,
                    height:     1,
                    color:      cs.onSurfaceVariant.withOpacity(0.55),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  باقي الـ Widgets (بدون تغيير جوهري، فقط تنظيف طفيف)
// ═══════════════════════════════════════════════════════════════

class _HorizontalSplitter extends StatelessWidget {
  const _HorizontalSplitter({
    required this.height,
    required this.isActive,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final double height;
  final bool   isActive;
  final VoidCallback          onDragStart;
  final void Function(double) onDragUpdate;
  final VoidCallback          onDragEnd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.resizeRow,
      child: GestureDetector(
        behavior:          HitTestBehavior.translucent,
        dragStartBehavior: DragStartBehavior.start,
        onVerticalDragStart:  (_) => onDragStart(),
        onVerticalDragUpdate: (d) => onDragUpdate(d.delta.dy),
        onVerticalDragEnd:    (_) => onDragEnd(),
        child: SizedBox(
          height: height,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: 4, width: 90,
              decoration: BoxDecoration(
                color:        isActive ? cs.primary : cs.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CommandBar extends StatelessWidget {
  const _CommandBar({
    required this.onNewFile,
    required this.onOpenFile,
    required this.onSaveFile,
    required this.onRun,
    required this.isRunning,
  });

  final Future<void> Function() onNewFile, onOpenFile, onSaveFile, onRun;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8, runSpacing: 8,
                children: [
                  _CommandButton(icon: Icons.note_add_outlined,   label: 'ملف جديد', onPressed: onNewFile),
                  _CommandButton(icon: Icons.folder_open_outlined, label: 'فتح',      onPressed: onOpenFile),
                  _CommandButton(icon: Icons.save_outlined,        label: 'حفظ',      onPressed: onSaveFile),
                  const SizedBox(width: 8),
                  _CommandButton(icon: Icons.play_arrow, label: 'تشغيل', onPressed: onRun, enabled: !isRunning),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text('وضع المحترف', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _CommandButton extends StatelessWidget {
  const _CommandButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final IconData icon;
  final String   label;
  final Future<void> Function() onPressed;
  final bool     enabled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: FilledButton.tonalIcon(
        onPressed: enabled ? () => onPressed() : null,
        icon:  Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }
}


class _LogEntryRow extends StatelessWidget {
  const _LogEntryRow({required this.log, required this.lineNumber});

  final ProModeLogEntry log;
  final int             lineNumber;

  @override
  Widget build(BuildContext context) {
    final color = _colorForLevel(context, log.level);
    final time  = TimeOfDay.fromDateTime(log.createdAt).format(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$lineNumber.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Icon(_iconForLevel(log.level), color: color, size: 18),
        const SizedBox(width: 8),
        Text(time, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 8),
        Expanded(child: Text(log.message)),
      ],
    );
  }

  Color _colorForLevel(BuildContext context, ProModeLogLevel level) => switch (level) {
    ProModeLogLevel.info    => Theme.of(context).colorScheme.primary,
    ProModeLogLevel.success => Colors.green.shade700,
    ProModeLogLevel.warning => Colors.orange.shade800,
    ProModeLogLevel.error   => Theme.of(context).colorScheme.error,
  };

  IconData _iconForLevel(ProModeLogLevel level) => switch (level) {
    ProModeLogLevel.info    => Icons.info_outline,
    ProModeLogLevel.success => Icons.check_circle_outline,
    ProModeLogLevel.warning => Icons.warning_amber_outlined,
    ProModeLogLevel.error   => Icons.error_outline,
  };
}

class _DeviceToolsPanel extends StatelessWidget {
  const _DeviceToolsPanel({required this.controller});
  final ProModeSessionController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('الأجهزة والأدوات', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.usb, title: 'الحالة', value: controller.deviceStatusMessage),
            const Divider(height: 28),
            _PortSelector(
              ports:        controller.availablePorts,
              selectedPort: controller.selectedPort,
              isRefreshing: controller.isRefreshingPorts,
              onRefresh:    controller.refreshAvailablePorts,
              onSelect:     controller.selectPort,
            ),
            const Divider(height: 28),
            ElevatedButton.icon(
              onPressed: controller.isFlashing ? null : controller.flashProgram,
              icon:  const Icon(Icons.upload_file_outlined),
              label: const Text('رفع إلى اللوحة'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: controller.refreshAvailablePorts,
              icon:  const Icon(Icons.refresh),
              label: const Text('تحديث المنافذ'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortSelector extends StatelessWidget {
  const _PortSelector({
    required this.ports,
    required this.selectedPort,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onSelect,
  });

  final List<String>  ports;
  final String?       selectedPort;
  final bool          isRefreshing;
  final Future<void> Function() onRefresh;
  final void Function(String?)  onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('اختر المنفذ', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value:     selectedPort,
              isExpanded: true,
              hint:      const Text('اختر منفذاً...'),
              items:     ports
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: onSelect,
            ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: isRefreshing ? null : onRefresh,
          icon: isRefreshing
              ? const SizedBox(height: 18, width: 18,
              child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.refresh),
          label: Text(isRefreshing ? 'جارٍ التحديث...' : 'تحديث المنافذ'),
        ),
      ],
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.icon,
    required this.title,
    required this.trailing,
    this.action,
  });

  final IconData icon;
  final String   title;
  final String   trailing;
  final Widget?  action;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:        cs.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Flexible(
            child: Text(
              trailing,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (action != null) ...[const SizedBox(width: 8), action!],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String   title;
  final String   value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _BottomTabPanel — يجمع المخرجات والسيريال مونيتور في تابين
// ═══════════════════════════════════════════════════════════════
class _BottomTabPanel extends StatelessWidget {
  const _BottomTabPanel({
    required this.selectedIndex,
    required this.onTabChanged,
    required this.statusMessage,
    required this.executionStateLabel,
    required this.logs,
    required this.onClearLogs,
    required this.controller,
  });

  final int    selectedIndex;
  final void Function(int) onTabChanged;
  final String statusMessage;
  final String executionStateLabel;
  final List<ProModeLogEntry> logs;
  final VoidCallback onClearLogs;
  final ProModeSessionController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── شريط التابات ──────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                _TabButton(
                  icon:     Icons.terminal,
                  label:    'المخرجات',
                  selected: selectedIndex == 0,
                  onTap:    () => onTabChanged(0),
                ),
                _TabButton(
                  icon:     Icons.cable,
                  label:    'السيريال مونيتور',
                  selected: selectedIndex == 1,
                  onTap:    () => onTabChanged(1),
                ),
                const Spacer(),
                if (selectedIndex == 0) ...[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '$executionStateLabel — $statusMessage',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip:   'مسح السجلات',
                    onPressed: onClearLogs,
                    icon: const Icon(Icons.clear_all, size: 20),
                  ),
                ],
              ],
            ),
          ),
          // ── محتوى التاب ──────────────────────────────────────
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [
                _OutputPanelBody(logs: logs),
                _SerialMonitorPanel(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── زر تاب ────────────────────────────────────────────────────
class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String   label;
  final bool     selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? cs.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16,
                color: selected ? cs.primary : cs.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color:      selected ? cs.primary : cs.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── جسم تاب المخرجات ──────────────────────────────────────────
class _OutputPanelBody extends StatelessWidget {
  const _OutputPanelBody({required this.logs});
  final List<ProModeLogEntry> logs;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(child: Text('لا توجد سجلات بعد.'));
    }
    return ListView.separated(
      padding:          const EdgeInsets.all(12),
      itemCount:        logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder:      (_, i) =>
          _LogEntryRow(log: logs[i], lineNumber: i + 1),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _SerialMonitorPanel
// ═══════════════════════════════════════════════════════════════
class _SerialMonitorPanel extends StatefulWidget {
  const _SerialMonitorPanel({required this.controller});
  final ProModeSessionController controller;

  @override
  State<_SerialMonitorPanel> createState() => _SerialMonitorPanelState();
}

class _SerialMonitorPanelState extends State<_SerialMonitorPanel> {
  final _inputController  = TextEditingController();
  final _scrollController = ScrollController();
  bool  _autoScroll       = true;
  int   _baudRate         = 9600;

  static const _baudRates = [
    300, 1200, 2400, 4800, 9600,
    19200, 38400, 57600, 74880, 115200, 230400, 250000,
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onNewData);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onNewData);
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onNewData() {
    if (!_autoScroll || !_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final msg = _inputController.text.trim();
    if (msg.isEmpty) return;
    widget.controller.serialSend(msg);
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final sc      = widget.controller;
    final entries = sc.serialLog;
    final isOpen  = sc.isSerialOpen;

    return ColoredBox(
      color: const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── شريط الإعدادات ────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: const Color(0xFF2D2D2D),
            child: Row(
              children: [
                const Text('Baud Rate:',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value:         _baudRate,
                  dropdownColor: const Color(0xFF2D2D2D),
                  style:         const TextStyle(color: Colors.white, fontSize: 12),
                  underline:     const SizedBox(),
                  isDense:       true,
                  items: _baudRates.map((r) =>
                      DropdownMenuItem(value: r, child: Text('$r'))).toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _baudRate = v);
                    widget.controller.setSerialBaudRate(v);
                  },
                ),
                const SizedBox(width: 16),
                // فتح / إغلاق
                TextButton.icon(
                  onPressed: isOpen
                      ? widget.controller.closeSerial
                      : () => widget.controller.openSerial(_baudRate),
                  icon: Icon(
                    isOpen ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                    size: 16,
                    color: isOpen ? Colors.redAccent : Colors.greenAccent,
                  ),
                  label: Text(
                    isOpen ? 'إغلاق' : 'فتح',
                    style: TextStyle(
                      color:    isOpen ? Colors.redAccent : Colors.greenAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                // Auto-scroll
                const Text('تمرير تلقائي',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(width: 4),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value:     _autoScroll,
                    onChanged: (v) => setState(() => _autoScroll = v),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip:   'مسح',
                  onPressed: widget.controller.clearSerialLog,
                  icon: const Icon(Icons.clear_all, size: 18, color: Colors.white54),
                ),
              ],
            ),
          ),

          // ── منطقة العرض ──────────────────────────────────────
          Expanded(
            child: entries.isEmpty
                ? Center(
              child: Text(
                isOpen ? 'في انتظار البيانات...' : 'افتح المنفذ للبدء',
                style: const TextStyle(color: Colors.white38),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding:    const EdgeInsets.all(12),
              itemCount:  entries.length,
              itemBuilder: (_, i) {
                final e = entries[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: RichText(
                    textDirection: TextDirection.ltr,
                    text: TextSpan(children: [
                      TextSpan(
                        text: '[${e.timestamp}] ',
                        style: const TextStyle(
                          color: Color(0xFF569CD6),
                          fontSize: 12,
                          fontFamily: 'Cascadia Code',
                        ),
                      ),
                      TextSpan(
                        text: e.data,
                        style: TextStyle(
                          color: e.isSent
                              ? const Color(0xFF4EC9B0)
                              : Colors.white87,
                          fontSize: 13,
                          fontFamily: 'Cascadia Code',
                        ),
                      ),
                      if (e.isSent)
                        const TextSpan(
                          text: '  ←',
                          style: TextStyle(
                              color: Color(0xFF4EC9B0), fontSize: 11),
                        ),
                    ]),
                  ),
                );
              },
            ),
          ),

          // ── صندوق الإرسال ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF2D2D2D),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:    _inputController,
                    enabled:       isOpen,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Cascadia Code',
                    ),
                    decoration: InputDecoration(
                      hintText:  isOpen
                          ? 'اكتب رسالة للإرسال...'
                          : 'افتح المنفذ أولاً',
                      hintStyle: const TextStyle(
                          color: Colors.white38, fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide:
                        const BorderSide(color: Color(0xFF444444)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide:
                        const BorderSide(color: Color(0xFF444444)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: cs.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      filled:    true,
                      fillColor: const Color(0xFF1E1E1E),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: isOpen ? _sendMessage : null,
                  icon:  const Icon(Icons.send, size: 16),
                  label: const Text('إرسال'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}