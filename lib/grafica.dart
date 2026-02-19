//Gráfica y lista
import 'package:flutter/material.dart';
import 'package:proyecto/pantalla_registro.dart';
import 'package:proyecto/modelos/modelo_registro.dart';

class Grafica extends StatefulWidget {
  const Grafica({super.key});

  @override
  State<Grafica> createState() => _GraficaState();
}

class _GraficaState extends State<Grafica> {
  final List<Gasto> listaGastos = [];

  void abrirFormulario() async {
    final gasto = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddScreen()),
    );

    if (gasto != null) {
      setState(() {
        listaGastos.add(gasto);
      });
    }
  }

  void editarGasto(int index) async {
    final gastoEditado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddScreen(gasto: listaGastos[index])),
    );

    if (gastoEditado != null) {
      setState(() {
        listaGastos[index] = gastoEditado;
      });
    }
  }

  void eliminarGasto(int index) {
    setState(() {
      listaGastos.removeAt(index);
    });
  }

  double _calcularTotal() {
    return listaGastos.fold(0, (sum, item) => sum + item.monto);
  }

  Icon _getIcono(TipoCategoria categoria, {double size = 20}) {
    switch (categoria) {
      case TipoCategoria.comida:
        return Icon(Icons.restaurant, color: Colors.orange, size: size);

      case TipoCategoria.entretenimiento:
        return Icon(Icons.movie, color: Colors.purple, size: size);

      case TipoCategoria.viajes:
        return Icon(Icons.flight, color: Colors.blue, size: size);

      case TipoCategoria.trabajo:
        return Icon(Icons.work, color: Colors.green, size: size);
    }
  }

  Color _colorFondoCategoria(TipoCategoria categoria) {
    switch (categoria) {
      case TipoCategoria.comida:
        return Colors.orange.shade50;
      case TipoCategoria.entretenimiento:
        return Colors.purple.shade50;
      case TipoCategoria.viajes:
        return Colors.blue.shade50;
      case TipoCategoria.trabajo:
        return Colors.green.shade50;
    }
  }

  List<Widget> _generarBarras() {
    Map<TipoCategoria, double> totalesPorCategoria = {
      TipoCategoria.comida: 0,
      TipoCategoria.entretenimiento: 0,
      TipoCategoria.viajes: 0,
      TipoCategoria.trabajo: 0,
    };

    for (var gasto in listaGastos) {
      totalesPorCategoria[gasto.categoria] =
          totalesPorCategoria[gasto.categoria]! + gasto.monto;
    }

    double maxGasto = totalesPorCategoria.values.fold(
      0,
      (max, e) => e > max ? e : max,
    );
    if (maxGasto == 0) maxGasto = 1;

    //Barras de las 4 categorías
    return TipoCategoria.values.map((cat) {
      double alturaCalculada = (totalesPorCategoria[cat]! / maxGasto) * 100;

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _getIcono(cat, size: 12),
          const SizedBox(height: 4),
          Container(
            width: 25,
            height: alturaCalculada + 5,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                if (totalesPorCategoria[cat]! > 0)
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control de Gastos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: abrirFormulario,
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Detecta si el ancho es mayor a 600 para reacomodar los elementos
          bool esHorizontal = constraints.maxWidth > 600;

          return Flex(
            direction: esHorizontal ? Axis.horizontal : Axis.vertical,
            children: [
              // ELEMENTO 1: ÁREA DE GRÁFICA / RESUMEN GENERAL
              Expanded(
                flex: esHorizontal ? 1 : 0,
                child: Container(
                  height: esHorizontal ? double.infinity : 200,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(
                    10,
                  ), // Espacio interno para que las barras no toquen el borde
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total: \$${_calcularTotal().toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ), // Espacio entre texto y barras
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment
                              .end, //Permite generar las barras de abajo hacia arriba dependiendo lo que se agregue
                          children:
                              _generarBarras(), //Función nueva. Agrega las barras a la gráfica
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ELEMENTO 2: LISTA DE GASTOS (CON DESPLAZAMIENTO)
              Expanded(
                child: listaGastos.isEmpty
                    ? const Center(child: Text("No hay datos guardados"))
                    : ListView.builder(
                        itemCount: listaGastos.length,
                        itemBuilder: (context, index) {
                          final item = listaGastos[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),

                            child: ListTile(
                              contentPadding: const EdgeInsets.only(
                                left: 10,
                                right: 0,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: _colorFondoCategoria(
                                  item.categoria,
                                ),
                                child: _getIcono(item.categoria),
                              ),
                              title: Text(
                                item.titulo,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${item.fecha.day}/${item.fecha.month}/${item.fecha.year}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "\$${item.monto.toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      Icons.create_outlined,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => editarGasto(index),
                                  ),
                                  const SizedBox(width: 0),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => eliminarGasto(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    ); // Cierre del Scaffold
  } // Cierre del Build
} // CIERRE FINAL DE LA CLASE
