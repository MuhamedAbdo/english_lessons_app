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
  late final List<Map<String, String>> wordsList;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();

    final data = widget.lesson.data() as Map<String, dynamic>;
    final words = data['words'] ?? [];

    wordsList = words
        .map<Map<String, String>>(
          (w) => {
            'ar': w['word_ar']?.toString() ?? '',
            'en': w['word_en']?.toString() ?? '',
          },
        )
        .toList();

    flutterTts.setLanguage("en-US");
  }

  Future<void> speakWord(String word) async {
    if (word.isNotEmpty) {
      await flutterTts.speak(word);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${widget.lesson['title_ar']} | الكلمات الجديدة",
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: wordsList.isEmpty
            ? const Center(child: Text('لا توجد كلمات جديدة لهذا الدرس'))
            : ListView.builder(
                itemCount: wordsList.length,
                itemBuilder: (context, index) {
                  final ar = wordsList[index]['ar']!;
                  final en = wordsList[index]['en']!;

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // النص الإنجليزي ← يسار الشاشة
                          Expanded(
                            flex: 1,
                            child: Text(
                              en,
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // زر النطق ← وسط
                          IconButton(
                            icon: const Icon(Icons.volume_up,
                                color: Colors.green),
                            onPressed: () => speakWord(en),
                          ),

                          // النص العربي ← يمين الشاشة
                          Expanded(
                            flex: 1,
                            child: Text(
                              ar,
                              style: const TextStyle(fontSize: 25),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
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
