import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jimile/screens/home_screen.dart';
import 'package:jimile/screens/catalogo/catalogo.dart';
//import 'package:jimile/services/api.dart' as api_services;
//import 'package:neru/services/db_helper.dart';
import 'package:jimile/widget/bottom_nav.dart';

// 🔹 Asegúrate de tener tus clases DBHelper, LoginScreen, CustomActionButton, CenteredDivider ya creadas

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  final int _selectedIndex = 2;
  String nombre = "Usuario"; // 🔹 Aquí pones el nombre dinámico
  double progreso = 0.65; // 🔹 Entre 0.0 y 1.0
  final List<String> etiquetas = ["Éstres", "AutoConfianza", "Concentración"];
  List<Map<String, dynamic>> variables = [];

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
        backgroundColor: Color(0xFF00406a),
        foregroundColor: Colors.white,
        title: Stack(
          children: [
            // 🔹 Ícono centrado
            Align(
              alignment: Alignment.center,
              child: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.white,
                size: 20,
              ),
            ),
            // 🔹 Texto alineado a la derecha
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'JimiLe',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
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
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
