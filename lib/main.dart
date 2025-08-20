import 'package:flutter/material.dart';
import 'package:jimile/screens/login/check_auth.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'L´Jimie',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primaryColor: const Color(0xFF494859),
        fontFamily: 'Monserrat',
      ),
      home: CheckAuthScreen(),
    );
  }
}
