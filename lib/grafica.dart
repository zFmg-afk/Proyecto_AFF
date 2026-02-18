import 'package:flutter/material.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
//import 'dart:html';
import 'package:flutter/rendering.dart';
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
      ), // Aquí terminaba AppBar PONCHITO BB
      //le puse lo demas del body, no encontre una pagina para ver como va el progreso es que esa parte no me la se bien.
      // --- INICIO DEL BODY---
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Detecta si el ancho es mayor a 600 para reacomodar los elementos
          bool esHorizontal = constraints.maxWidth > 600;

          return Flex(
            direction: esHorizontal ? Axis.horizontal : Axis.vertical,
            children: [
              // ELEMENTO 1: ÁREA DE GRÁFICA / RESUMEN TOTAL
              Expanded(
                flex: esHorizontal ? 1 : 0, 
                child: Container(
                  height: esHorizontal ? double.infinity : 200,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Total Gastado:\n\$${_calcularTotal().toStringAsFixed(2)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
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
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Icon(_getIcono(item.categoria)),
                              ),
                              title: Text(item.titulo),
                              subtitle: Text("${item.fecha.day}/${item.fecha.month}/${item.fecha.year}"),
                              trailing: Text("\$${item.monto.toStringAsFixed(2)}"),
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

  // --- FUNCIONES DE APOYO (Fuera del Build para no afectar el código original) ---
  
  double _calcularTotal() {
    return listaGastos.fold(0, (sum, item) => sum + item.monto);
  }

  IconData _getIcono(TipoCategoria categoria) {
    switch (categoria) {
      case TipoCategoria.comida: return Icons.restaurant;
      case TipoCategoria.entretenimiento: return Icons.movie;
      case TipoCategoria.viajes: return Icons.flight;
      case TipoCategoria.trabajo: return Icons.work;
    }
  }
} // CIERRE FINAL DE LA CLASE