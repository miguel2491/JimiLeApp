import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jimile/main.dart';
import 'package:jimile/screens/carrito/carrito.dart';
import 'package:jimile/screens/catalogo/catalogo.dart';
import 'package:jimile/widget/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CatalogoScreen()),
      );
      return; // no cambies _selectedIndex si navegas
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CarritoScreen()),
      );
      return;
    }
  }

  final List<Widget> _pages = [
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
    // Center(
    //   child: Text("Progreso", style: TextStyle(color: Colors.white)),
    // ),
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
  ];
  Future<void> solicitarPermisoExactAlarms() async {
    if (Platform.isAndroid) {
      final plugin = FlutterLocalNotificationsPlugin();
      final androidImplementation = plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final permitido = await androidImplementation
          ?.canScheduleExactNotifications();
      if (permitido == false) {
        await androidImplementation?.requestExactAlarmsPermission();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF00406a),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinea el título a la derecha
          children: [Text('JimiLe')],
        ),
      ),
      // drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          print('FAB presionado');
        },
        child: const Icon(Icons.help),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/fondo.png',
            ), // Aquí pones tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 10),
            Image.asset('assets/logo.png', height: 150),
            const SizedBox(height: 4),
            const Text(
              'Bienvenido',
              style: TextStyle(color: Colors.white, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _pages[_selectedIndex],
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
