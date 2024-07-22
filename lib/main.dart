import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ai_assistant/onboarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistant',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const OnBoardingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
