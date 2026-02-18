enum TipoCategoria { comida, entretenimiento, viajes, trabajo }

class Gasto {
  final String id;
  final String titulo;
  final double monto;
  final DateTime fecha;
  final TipoCategoria categoria;

  Gasto({
    required this.titulo,
    required this.monto,
    required this.fecha,
    required this.categoria,
  }) : id = DateTime.now().toString();
}