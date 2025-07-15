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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          data['title_ar'] ?? 'عنوان غير موجود',
          style: const TextStyle(color: Colors.white),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'الشرح:',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (contentBlocks != null && contentBlocks.isNotEmpty)
                      ...contentBlocks.map((block) {
                        final item = block as Map<String, dynamic>;
                        final String type = item['type'] ?? '';
                        final String value = item['value'] ?? '';
                        final String enExample = item['en'] ?? '';
                        final String arExample = item['ar'] ?? '';
                        final String imageUrl = item['image_url'] ?? '';

                        switch (type) {
                          case 'text':
                            return _buildArabicText(value, imageUrl);

                          case 'english_word':
                            return _buildEnglishWord(value, imageUrl);

                          case 'example_sentence':
                            return _buildExampleSentence(
                                en: enExample,
                                ar: arExample,
                                imageUrl: imageUrl);

                          default:
                            return Container();
                        }
                      }).toList()
                    else
                      const Text(
                        'لا يوجد محتوى للدرس.',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // الزر دائمًا ظاهر في أسفل الشاشة
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(180, 40),
                maximumSize: const Size(250, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 بناء الفقرات العربية مع صورة اختيارية
  Widget _buildArabicText(String text, String imageUrl) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (_, __, ___) => const Text("فشل تحميل الصورة"),
              ),
            ),
          Text(
            text,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // 🔹 بناء الكلمات الإنجليزية مع دعم LTR
  Widget _buildEnglishWord(String word, String imageUrl) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.fitWidth,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (_, __, ___) => const Text("فشل تحميل الصورة"),
              ),
            ),
          Text(
            word,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // 🔹 بناء الأمثلة الثنائية اللغة مع دعم المحاذاة الصحيحة
  Widget _buildExampleSentence(
      {required String en, required String ar, required String imageUrl}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          if (imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (_, __, ___) => const Text("فشل تحميل الصورة",
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          // الجملة الإنجليزية ← LTR
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              en,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          ),
          // الجملة العربية ← RTL
          Text(
            ar,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 16),
          ),
          // const Divider(color: Colors.grey, height: 20),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
