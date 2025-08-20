import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jimile/model/productos.dart';
import 'package:jimile/screens/home_screen.dart';
import 'package:jimile/screens/carrito/carrito.dart';
import 'package:jimile/services/api.dart' as api_service;
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
  List<Productos> _productos = [];
  List<Productos> _seleccionados = [];
  Map<String, String> _presentacionesSeleccionadas = {};
  String query = "";

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

  Future<void> _loadProductos() async {
    try {
      final productos = await api_service.fProductos();
      setState(() {
        _productos = productos;
      });
      print('💀 $_productos');
    } catch (e) {
      print(' $e');
    }
  }

  @override
  void initState() {
    super.initState();
    //api_services.mVariablesLocales();
    _loadProductos();
  }

  @override
  Widget build(BuildContext context) {
    // filtramos según lo escrito
    final List<Productos> productosFiltrados = _productos.where((p) {
      final nombre = p.tendencia.toLowerCase();
      final busqueda = query.toLowerCase();
      return nombre.contains(busqueda);
    }).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFFFF8E1)),
        child: SafeArea(
          child: Column(
            children: [
              // 🔍 Buscador
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar producto...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                ),
              ),

              // 📝 Cards de seleccionados (permanentes en la vista)
              Expanded(
                child: ListView(
                  children: [
                    ..._seleccionados.map((producto) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto.tendencia,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text("Clave: ${producto.clave}"),
                                Text(
                                  "Familia: ${producto.familiaOlfativa ?? '-'}",
                                ),
                                Text("Nota: ${producto.notaPrincipal ?? '-'}"),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text("Presentación: "),
                                    DropdownButton<String>(
                                      value:
                                          _presentacionesSeleccionadas[producto
                                              .clave],
                                      hint: const Text("Seleccionar"),
                                      items: ["10ml", "50ml", "100ml"]
                                          .map(
                                            (value) => DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _presentacionesSeleccionadas[producto
                                                  .clave] =
                                              value!;
                                        });
                                        print(
                                          "Producto ${producto.clave} -> $value",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    // 📋 Mostrar lista solo cuando hay texto en buscador
                    if (query.isNotEmpty)
                      ...productosFiltrados.map((producto) {
                        return ListTile(
                          tileColor: Colors.white,
                          title: Text(producto.tendencia),
                          subtitle: Text(producto.familiaOlfativa ?? ""),
                          onTap: () {
                            setState(() {
                              if (!_seleccionados.contains(producto)) {
                                _seleccionados.add(producto);
                              }
                              query = ""; // limpia buscador al seleccionar
                            });
                          },
                        );
                      }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  print('¡Botón presionado!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // 🎨 Color de fondo
                  foregroundColor: Colors.white, // 🎨 Color del texto e íconos
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Bordes redondeados
                  ),
                  elevation: 4, // Sombra
                ),
                child: Text('Realizar Pedido'),
              ),
              const SizedBox(height: 12),
            ],
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
