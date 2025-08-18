import 'dart:convert';
import 'package:jimile/model/productos.dart';
import 'package:http/http.dart' as http;
import 'package:jimile/services/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Fijas
Future<List<Productos>> fProductos() async {
  final response = await http.get(
    Uri.parse(
      'https://gcconsultoresmexico.com/api/api.php?action=get_variables',
    ),
  );
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => Productos.fromJson(json)).toList();
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
