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
      ),
    );
  }
}
