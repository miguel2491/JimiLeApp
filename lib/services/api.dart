import 'dart:convert';
import 'package:jimile/model/categorias.dart';
import 'package:jimile/model/presentacion.dart';
import 'package:jimile/model/productos.dart';
import 'package:http/http.dart' as http;
import 'package:jimile/services/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Fijas
Future<List<Productos>> fProductos() async {
  final response = await http.get(
    Uri.parse('http://apicatsa.catsaconcretos.mx:2543/api/LJ/GetProducto'),
  );
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => Productos.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar productos');
  }
}

Future<List<Presentacion>> fPresentacion(idCategoria) async {
  final response = await http.get(
    Uri.parse(
      'http://apicatsa.catsaconcretos.mx:2543/api/LJ/GetPresentacion/$idCategoria',
    ),
  );
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => Presentacion.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar productos');
  }
}

Future<List<Categoria>> fCategoria() async {
  final response = await http.get(
    Uri.parse('http://apicatsa.catsaconcretos.mx:2543/api/LJ/GetCategoria'),
  );
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => Categoria.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar productos');
  }
}

//LOCALES
void mProductosLocales() async {
  final productos = await DBHelper.getProductosDB();
  if (productos.isEmpty) {
    //print('❌ No hay variables guardadas');
  } else {
    for (var user in productos) {
      print(
        '📦 Productos: ${user['id']} | ${user['tendencia']} | ${user['estatus']}',
      );
    }
  }
}
