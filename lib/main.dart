import 'package:flutter/material.dart';
import 'package:jimile/screens/login/check_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JimiLe',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primaryColor: const Color(0xFF494859),
        fontFamily: 'Monserrat',
      ),
      home: CheckAuthScreen(),
    );
  }
}
