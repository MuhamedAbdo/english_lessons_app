import 'package:flutter/material.dart';

class NewWordsScreen extends StatelessWidget {
  const NewWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // مثال على الكلمات (يمكنك استبدالها من Firebase لاحقًا)
    final List<Map<String, String>> words = [
      {'ar': 'كتاب', 'en': 'Book'},
      {'ar': 'قلم', 'en': 'Pen'},
      {'ar': 'مدرسة', 'en': 'School'},
      {'ar': 'طالب', 'en': 'Student'},
      {'ar': 'معلم', 'en': 'Teacher'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الكلمات الجديدة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: words.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(words[index]['ar']!),
              trailing: Text(words[index]['en']!),
            );
          },
        ),
      ),
    );
  }
}
