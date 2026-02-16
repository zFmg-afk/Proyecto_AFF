enum tipoCategoria {comida, entretenimiento, viajes, trabajo }

class gasto {
  final String id;
  final String titulo;
  final double monto;
  final DateTime fecha;
  final tipoCategoria categoria;

  gasto({
    required this.titulo,
    required this.monto,
    required this.fecha,
    required this.categoria,
  }) : id = DateTime.now().toString();
}