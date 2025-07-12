import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LessonDetailScreen extends StatelessWidget {
  final DocumentSnapshot lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.get('title_ar') ?? 'عنوان غير موجود'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الدرس بالعربية:',
                style: const TextStyle(fontSize: 18, color: Colors.green),
              ),
              const SizedBox(height: 8),
              Text(
                lesson.get('content_ar') ?? 'لا يوجد محتوى عربي',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 20),
              Text(
                'Lesson in English:',
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              Text(
                lesson.get('content_en') ?? 'No English content available',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
