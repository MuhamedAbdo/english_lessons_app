import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewWordsScreen extends StatelessWidget {
  final DocumentSnapshot lesson;

  const NewWordsScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    // معالجة لو الحقل غير موجود
    final List words = (lesson.data() as Map<String, dynamic>)['words'] ?? [];

    final wordsList = words
        .map<Map<String, String>>(
          (w) => {
            'ar': w['ar']?.toString() ?? '',
            'en': w['en']?.toString() ?? '',
          },
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'الكلمات الجديدة',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: wordsList.isEmpty
            ? const Center(child: Text('لا توجد كلمات بعد'))
            : ListView.builder(
                itemCount: wordsList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      wordsList[index]['ar']!,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    trailing: Text(
                      wordsList[index]['en']!,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  );
                },
              ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showAddWordDialog(context),
      //   tooltip: 'إضافة كلمة جديدة',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
