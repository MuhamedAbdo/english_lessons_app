import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lesson_detail_screen.dart';

class LessonListScreen extends StatelessWidget {
  const LessonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference lessons =
        FirebaseFirestore.instance.collection('lessons');

    return Scaffold(
      appBar: AppBar(title: const Text('الدروس'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: lessons.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ أثناء تحميل الدروس: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد دروس بعد'));
          }

          final lessonDocs =
              snapshot.data!.docs.reversed.toList(); // ← تم تعديل الترتيب هنا

          return ListView.builder(
            itemCount: lessonDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot lesson = lessonDocs[index];

              return Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  title: Text(
                    lesson['title_ar'] ?? 'عنوان غير موجود',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    lesson['title_en'] ?? 'Lesson Title',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LessonDetailScreen(lesson: lesson),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
