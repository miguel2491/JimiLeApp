class Pedido {
  final int id;
  final String fechaPedido;
  final String usuario;
  final double total;
  final String estatus;

  Pedido({
    required this.id,
    required this.fechaPedido,
    required this.usuario,
    required this.total,
    required this.estatus,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: int.parse(json['id'].toString()),
      fechaPedido: json['fechaPedido'].toString(),
      usuario: json['usuario'].toString(),
      total: double.parse(json['total'].toString()),
      estatus: json['estatus'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fechaPedido': fechaPedido,
      'usuario': usuario,
      'total': total,
      'estatus': estatus,
    };
  }

  @override
  String toString() =>
      'Pedido(id: $id, fechaPedido: $fechaPedido, usuario $usuario, estatus: $estatus, total: $total)';
}
