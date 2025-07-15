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

  double speechRate = 0.3; // ← Default: متوسط

  final Map<String, double> rateOptions = {
    "بطيء": 0.1,
    "متوسط": 0.3,
    "سريع": 0.7,
  };

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
    flutterTts.setSpeechRate(speechRate);
  }

  Future<void> speakWord(String word) async {
    if (word.isNotEmpty) {
      await flutterTts
          .setSpeechRate(speechRate); // ← تأكد من تطبيق السرعة الحالية
      await flutterTts.speak(word);
    }
  }

  void changeSpeechRate(double newRate) {
    setState(() {
      speechRate = newRate;
    });
    flutterTts.setSpeechRate(newRate);
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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          "${widget.lesson['title_ar']} | الكلمات الجديدة",
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // خيارات سرعة النطق
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: rateOptions.entries.map((entry) {
                  final isSelected = speechRate == entry.value;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => changeSpeechRate(entry.value),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurple : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.deepPurple),
                        ),
                        child: Text(
                          entry.key,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : Colors.deepPurple,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // قائمة الكلمات الجديدة
            Expanded(
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
                                // النص الإنجليزي ← يسار
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

                                // النص العربي ← يمين
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
          ],
        ),
      ),
    );
  }
}
