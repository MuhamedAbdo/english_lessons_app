import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NewWordsScreen extends StatefulWidget {
  final DocumentSnapshot lesson;

  const NewWordsScreen({super.key, required this.lesson});

  @override
  State<NewWordsScreen> createState() => _NewWordsScreenState();
}

class _NewWordsScreenState extends State<NewWordsScreen> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speakWord(String word) async {
    if (word.isNotEmpty) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(word);
    }
  }

  @override
  void dispose() async {
    await flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.lesson.data() as Map<String, dynamic>;
    final words = data['words'] ?? []; // ← هنا نتعامل مع البيانات داخل build()

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
        title: Text(
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            "${data['title_ar']} | الكلمات الجديدة"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: wordsList.isEmpty
            ? const Center(child: Text('لا توجد كلمات جديدة لهذا الدرس'))
            : ListView.builder(
                itemCount: wordsList.length,
                itemBuilder: (context, index) {
                  final en = wordsList[index]['en']!;
                  final ar = wordsList[index]['ar']!;

                  return ListTile(
                    title: Text(ar, style: const TextStyle(fontSize: 25)),
                    trailing: GestureDetector(
                      onTap: () => speakWord(en),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            en,
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.volume_up, color: Colors.green),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
