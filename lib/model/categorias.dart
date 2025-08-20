class Categoria {
  final int id;
  final String categoria;
  final String estatus;

  Categoria({required this.id, required this.categoria, required this.estatus});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: int.parse(json['id'].toString()),
      categoria: json['categoria'].toString(),
      estatus: json['estatus'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'categoria': categoria, 'estatus': estatus};
  }

  @override
  String toString() =>
      'Categoria(id: $id, categoria: $categoria, estatus: $estatus)';
}
