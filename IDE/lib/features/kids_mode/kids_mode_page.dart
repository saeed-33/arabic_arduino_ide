import 'package:flutter/material.dart';

class KidsModePage extends StatelessWidget {
  const KidsModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('وضع التعلم', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('سيتم بناء بيئة السحب والإفلات بعد اكتمال وضع المحترف.'),
      ],
    );
  }
}
