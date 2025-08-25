import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jimile/model/productos.dart';
import 'package:jimile/screens/home_screen.dart';
import 'package:jimile/screens/carrito/carrito.dart';
import 'package:jimile/services/api.dart' as api_service;
import 'package:jimile/services/db_helper.dart';
import 'package:jimile/widget/bottom_nav.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final int _selectedIndex = 0;

  final List<String> etiquetas = ["Éstres", "AutoConfianza", "Concentración"];
  List<Map<String, dynamic>> variables = [];
  List<Productos> _productos = [];
  final List<Productos> _seleccionados = [];
  final Map<String, String> _presentacionesSeleccionadas = {};
  List<Map<String, dynamic>> pedido = [];
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      producto.tendencia,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _seleccionados.remove(producto);
                                          _presentacionesSeleccionadas.remove(
                                            producto.clave,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
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
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text("Categoria: "),
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
                                          final item = pedido.firstWhere(
                                            (p) => p["clave"] == producto.clave,
                                          );
                                          item["presentacion"] = value;
                                        });
                                        print(
                                          "Producto ${producto.clave} -> $value",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Género: ${producto.genero == 'C' ? 'Caballero' : (producto.genero == 'D' ? 'Dama' : 'Unisex')}",
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "Cantidad",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    final item = pedido.firstWhere(
                                      (p) => p["clave"] == producto.clave,
                                    );
                                    item["cantidad"] = int.tryParse(value) ?? 0;
                                  }, // para que salga teclado numérico
                                ),
                                const SizedBox(height: 8),
                                Text("Precio: 0"),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

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
                                pedido.add({
                                  "idproducto": producto.id,
                                  "clave": producto.clave,
                                  "tendencia": producto
                                      .tendencia, // se define luego con dropdown
                                  "presentacion": null,
                                  "categoria": null,
                                  "genero": producto.genero,
                                  "cantidad": 0,
                                  "precio": 0,
                                });
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
                onPressed: () async {
                  print("JSON del pedido:");
                  print(pedido);
                  for (var item in pedido) {
                    print(
                      "Producto: ${item['idproducto']} - Cantidad: ${item['cantidad']}",
                    );
                    final result = await DBHelper.AddPedido([
                      {
                        'idproducto': item['idproducto'],
                        'clave': item['clave'],
                        'tendencia': item['tendencia'],
                        'genero': item['genero'],
                        'cantidad': item['cantidad'],
                        'precio': item['precio'],
                      },
                    ]);
                  }
                  // Si quieres enviarlo como JSON string:
                  final jsonPedido = jsonEncode(pedido);
                  print(jsonPedido);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // 🎨 Color de fondo
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
                child: Text('Agregar a Carrito'),
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
