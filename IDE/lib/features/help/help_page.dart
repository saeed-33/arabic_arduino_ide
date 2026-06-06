import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('المساعدة', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        const _HelpItem(
          title: 'ما هي بيئة أردوينو العربية؟',
          body: 'تطبيق ويندوز بسيط لتعليم برمجة الأردوينو باستخدام لغة عربية.',
        ),
        const _HelpItem(
          title: 'وضع المحترف',
          body:
              'يحتوي الآن على محرر عربي بسيط مع مثال أولي، وشريط أوامر، ومخرجات وسجلات، ولوحة أجهزة وأدوات.',
        ),
        const _HelpItem(
          title: 'المحرر العربي',
          body:
              'يمكنك تعديل النص داخل المحرر. عند تغيير الكود تظهر حالة تغييرات غير محفوظة.',
        ),
        const _HelpItem(
          title: 'الملفات',
          body:
              'أزرار ملف جديد، فتح، وحفظ تعمل الآن مع ملفات نصية محلية على ويندوز.',
        ),
        const _HelpItem(
          title: 'المخرجات والسجلات',
          body:
              'تعرض لوحة المخرجات آخر حالة وسجلا زمنيا لإجراءات الملفات، ويمكن مسح السجلات من الزر داخل اللوحة.',
        ),
        const _HelpItem(
          title: 'التشغيل والتصحيح',
          body:
              'أزرار التشغيل والإيقاف وإعادة التشغيل والتصحيح تعرض رسائل توضيحية الآن، لكن المترجم وتشغيل الأردوينو لم يضافا بعد.',
        ),
        const _HelpItem(
          title: 'الإعدادات',
          body:
              'تحتوي الإعدادات الآن على حقول مؤقتة لمسار Arduino CLI، اللوحة، المنفذ، وخادم المكتبات. الحفظ الدائم سيأتي لاحقا.',
        ),
        const _HelpItem(
          title: 'وضع المطور',
          body:
              'يوفر واجهة تشخيصية للمطورين تحتوي على AST، الرموز، الأخطاء الخام، الكود المولد، وخطوات البناء كبيانات مؤقتة.',
        ),
        const _HelpItem(
          title: 'وضع التعلم',
          body:
              'واجهة بلوكات للأطفال والمبتدئين، وستأتي بعد إكمال وضع المحترف.',
        ),
      ],
    );
  }
}

class _HelpItem extends StatelessWidget {
  const _HelpItem({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(body),
        ],
      ),
    );
  }
}
