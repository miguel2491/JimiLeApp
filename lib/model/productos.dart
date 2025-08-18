class Productos {
  final int id;
  final String clave;
  final String tendencia;
  final String familiaOlfativa;
  final String notaPrincipal;
  final String diaNoche;
  final String genero;
  final String estatus;

  Productos({
    required this.id,
    required this.clave,
    required this.tendencia,
    required this.familiaOlfativa,
    required this.notaPrincipal,
    required this.diaNoche,
    required this.genero,
    required this.estatus,
  });

  factory Productos.fromJson(Map<String, dynamic> json) {
    return Productos(
      id: int.parse(json['id'].toString()),
      clave: json['clave'].toString(),
      tendencia: json['tendencia'].toString(),
      familiaOlfativa: json['familia_olfativa'].toString(),
      notaPrincipal: json['nota_principal'].toString(),
      diaNoche: json['dia_noche'].toString(),
      genero: json['genero'].toString(),
      estatus: json['estatus'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clave': clave,
      'tendencia': tendencia,
      'familia_olfativa': familiaOlfativa,
      'nota_principal': notaPrincipal,
      'dia_noche': diaNoche,
      'genero': genero,
      'estatus': estatus,
    };
  }

  @override
  String toString() =>
      'Producto(id: $id, clave: $clave, tendencia: $tendencia , familia_olfativa $familiaOlfativa, nota_principal $notaPrincipal,dia_noche: $diaNoche,estatus: $estatus, genero: $genero)';
}
