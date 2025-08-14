import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jimile/screens/home_screen.dart';
import 'package:jimile/screens/carrito/carrito.dart';
//import 'package:jimile/services/api.dart' as api_services;
//import 'package:neru/services/db_helper.dart';
import 'package:jimile/widget/bottom_nav.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final int _selectedIndex = 0;
  String nombre = "Usuario"; // 🔹 Aquí pones el nombre dinámico
  double progreso = 0.65; // 🔹 Entre 0.0 y 1.0
  final List<String> etiquetas = ["Éstres", "AutoConfianza", "Concentración"];
  List<Map<String, dynamic>> variables = [];

  void _onItemTapped(int index) {
    if (index == 0) {
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

  @override
  void initState() {
    super.initState();
    //api_services.mVariablesLocales();
    _loadVariables();
  }

  Future<void> _loadVariables() async {
    //final vars = await DBHelper.getVariablesDB();

    // setState(() {
    //   variables = List<Map<String, dynamic>>.from(mergedVariables);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF78A4BF),
        foregroundColor: Color(0xFF402B1F),
        title: Stack(
          children: [
            // 🔹 Ícono centrado
            Align(
              alignment: Alignment.center,
              child: FaIcon(
                FontAwesomeIcons.bookBookmark,
                color: Colors.white,
                size: 20,
              ),
            ),
            // 🔹 Texto alineado a la derecha
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'L´Jimie',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFF8E1), // azul petróleo
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Text(
                    "Desarrolla tu mente, una habilidad por semana.",
                    style: TextStyle(color: Color(0xFF402B1F), fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
