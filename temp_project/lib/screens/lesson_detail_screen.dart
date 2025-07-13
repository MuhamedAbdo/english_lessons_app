import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'new_words_screen.dart';

class LessonDetailScreen extends StatelessWidget {
  final DocumentSnapshot lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final data = lesson.data() as Map<String, dynamic>;
    final contentBlocks = data['content_blocks'] as List?;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(data['title_ar'] ?? 'عنوان غير موجود'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'الشرح:',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (contentBlocks != null && contentBlocks.isNotEmpty)
                ...contentBlocks.map((block) {
                  final item = block as Map<String, dynamic>;
                  final String type = item['type'] ?? '';
                  final String value = item['value'] ?? '';
                  switch (type) {
                    case 'text':
                      return _buildArabicText(value);
                    case 'english_word':
                      return _buildEnglishWord(value);
                    default:
                      return Container();
                  }
                }).toList()
              else
                const Text(
                  'لا يوجد محتوى للدرس.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewWordsScreen(lesson: lesson),
                    ),
                  );
                },
                icon: const Icon(Icons.translate),
                label: const Text('الكلمات الجديدة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArabicText(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildEnglishWord(String word) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        word,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
