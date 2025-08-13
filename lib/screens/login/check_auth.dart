// check_auth_screen.dart
import 'package:flutter/material.dart';
import 'package:jimile/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jimile/screens/login/login_screen.dart';

class CheckAuthScreen extends StatefulWidget {
  const CheckAuthScreen({super.key});

  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final usuario = prefs.getString('auth_usuario');
    final token = prefs.getString('auth_token');

    if (usuario == null) {
      // Usuario autenticado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // No autenticado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
