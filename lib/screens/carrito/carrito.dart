import 'package:flutter/material.dart';
import 'package:jimile/screens/catalogo/catalogo.dart';
import 'package:jimile/screens/home_screen.dart';
import 'package:jimile/services/api.dart' as api_service;
import 'package:jimile/services/db_helper.dart';
import 'package:jimile/widget/bottom_nav.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  List<Map<String, dynamic>> _pedidos = [];
  final int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      return; // no cambies _selectedIndex si navegas
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CatalogoScreen()),
      );
      return;
    }
  }

  Future<void> _loadPedidos() async {
    try {
      final pedidos = await api_service.mPedidos(); // ahora devuelve List<Map>
      setState(() {
        _pedidos = pedidos;
      });
    } catch (e) {
      print('Error al cargar pedidos: $e');
    }
  }

  Future<void> _eliminarPedido(int id) async {
    await DBHelper.deletePedido(id); // Método en tu DBHelper
    _loadPedidos(); // Recarga lista
  }

  Future<void> _vaciarCarrito() async {
    await DBHelper.deleteAllPedidos();
    _loadPedidos();
  }

  double _calcularTotal() {
    double total = 0;
    for (var item in _pedidos) {
      total += (item['precio'] ?? 0) * (item['cantidad'] ?? 1);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        backgroundColor: Color(0xFF78A4BF),
        foregroundColor: Colors.white,
        actions: [
          if (_pedidos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: _vaciarCarrito,
              tooltip: 'Vaciar carrito',
            ),
        ],
      ),
      body: _pedidos.isEmpty
          ? const Center(child: Text('🛒 No hay productos en el carrito'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = _pedidos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            'Clave: ${pedido['clave']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Producto: ${pedido['tendencia'] ?? 'N/A'}'),
                              Text(
                                'Presentación: ${pedido['presentacion'] ?? 'N/A'}',
                              ),
                              Text('Cantidad: ${pedido['cantidad']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$${pedido['precio']}'),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _eliminarPedido(pedido['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_calcularTotal().toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          print('👻⚽☠️🌋');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blueAccent, // 🎨 Color de fondo
                          foregroundColor:
                              Colors.white, // 🎨 Color del texto e íconos
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
                        child: Text('Comprar'),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
