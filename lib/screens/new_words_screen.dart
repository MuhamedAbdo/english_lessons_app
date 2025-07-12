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
      appBar: AppBar(title: const Text('الكلمات الجديدة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: wordsList.isEmpty
            ? const Center(child: Text('لا توجد كلمات بعد'))
            : ListView.builder(
                itemCount: wordsList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(wordsList[index]['ar']!),
                    trailing: Text(wordsList[index]['en']!),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWordDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'إضافة كلمة جديدة',
      ),
    );
  }

  void _showAddWordDialog(BuildContext context) {
    final _arController = TextEditingController();
    final _enController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة كلمة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _arController,
              decoration: const InputDecoration(labelText: 'الكلمة بالعربية'),
              textDirection: TextDirection.rtl,
            ),
            TextField(
              controller: _enController,
              decoration: const InputDecoration(
                labelText: 'الكلمة بالإنجليزية',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('إضافة'),
            onPressed: () async {
              final ar = _arController.text.trim();
              final en = _enController.text.trim();
              if (ar.isNotEmpty && en.isNotEmpty) {
                final ref = lesson.reference;
                await ref.update({
                  'words': FieldValue.arrayUnion([
                    {'ar': ar, 'en': en},
                  ]),
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
