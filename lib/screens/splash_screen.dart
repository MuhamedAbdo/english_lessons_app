import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // ← لاستخدام Future.delayed
import 'package:english_lessons_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // الانتظار لمدة ثانيتين ثم الانتقال إلى HomeScreen
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الصورة
            Image.asset(
              'asset/images/logo.png', // ← يجب أن تكون موجودة في assets/images/
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // نص الترحيب
            const Text(
              'Loading...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // مؤشر التحميل
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
