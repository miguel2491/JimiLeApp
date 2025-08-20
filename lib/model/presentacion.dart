class Presentacion {
  final int id;
  final int id_categoria;
  final String presentacion;
  final double precio;
  final String genero;
  final String estatus;

  Presentacion({
    required this.id,
    required this.id_categoria,
    required this.presentacion,
    required this.precio,
    required this.genero,
    required this.estatus,
  });

  factory Presentacion.fromJson(Map<String, dynamic> json) {
    return Presentacion(
      id: int.parse(json['id'].toString()),
      id_categoria: int.parse(json['id_categoria'].toString()),
      presentacion: json['presentacion'].toString(),
      precio: double.parse(json['precio'].toString()),
      genero: json['genero'].toString(),
      estatus: json['estatus'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_categoria': id_categoria,
      'presentacion': presentacion,
      'precio': precio,
      'genero': genero,
      'estatus': estatus,
    };
  }

  @override
  String toString() =>
      'Presentacion(id: $id, id_categoria: $id_categoria, presentacion: $presentacion , precio $precio, estatus: $estatus, genero: $genero)';
}
