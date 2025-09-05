import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jimile/model/pedido.dart';
import 'package:jimile/screens/carrito/carrito.dart';
import 'package:jimile/screens/catalogo/catalogo.dart';
import 'package:jimile/screens/pedido/pedido.dart';
import 'package:jimile/widget/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }

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
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PedidoScreen()),
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
        backgroundColor: Color(0xFF78A4BF),
        foregroundColor: Color(0xFF402B1F),
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinea el título a la derecha
          children: [Text('L´Jimie')],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFF8E1), // azul petróleo
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 200),
            Image.asset('assets/logo.png', height: 150),
            const SizedBox(height: 4),
            const Text(
              'Bienvenido',
              style: TextStyle(color: Color(0xFF402B1F), fontSize: 22),
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
