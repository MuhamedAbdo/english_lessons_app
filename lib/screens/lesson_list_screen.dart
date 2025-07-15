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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'الدروس',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: lessons.orderBy("order").snapshots(), // ← هنا يتم الفرز
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

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

          final lessonDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: lessonDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot lesson = lessonDocs[index];
              final data = lesson.data() as Map<String, dynamic>;

              return Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  title: Text(
                    data['title_ar'] ?? 'عنوان غير موجود',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    data['title_en'] ?? 'Lesson Title',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    child: Text('${data['order']}'),
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
