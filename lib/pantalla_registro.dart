//Pantalla de registros
import 'package:flutter/material.dart';
import 'package:proyecto/modelos/modelo_registro.dart';

class AddScreen extends StatefulWidget {
  final Gasto? gasto;

  const AddScreen({super.key, this.gasto});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  String titulo = "";
  double monto = 0;
  DateTime? fecha;
  TipoCategoria categoria = TipoCategoria.comida;

  @override
  void initState() {
    super.initState();

    if (widget.gasto != null) {
      titulo = widget.gasto!.titulo;
      monto = widget.gasto!.monto;
      fecha = widget.gasto!.fecha;
      categoria = widget.gasto!.categoria;
    }
  }

  Future<void> seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        fecha = picked;
      });
    }
  }

  String nombreCategoria(TipoCategoria cat) {
    switch (cat) {
      case TipoCategoria.comida:
        return "Comida";
      case TipoCategoria.entretenimiento:
        return "Entretenimiento";
      case TipoCategoria.viajes:
        return "Viajes";
      case TipoCategoria.trabajo:
        return "Trabajo";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gasto == null ? "Nuevo Gasto" : "Editar Gasto"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TITULO
              TextFormField(
                initialValue: titulo,
                maxLength: 30,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: UnderlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Ingrese título" : null,
                onSaved: (value) => titulo = value!,
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  /// MONTO (más ancho)
                  Expanded(
                    flex: 1,

                    child: TextFormField(
                      initialValue: monto == 0 ? "" : monto.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Monto",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingrese monto";
                        }
                        if (double.tryParse(value) == null) {
                          return "Monto inválido";
                        }
                        if (double.parse(value) <= 0) {
                          return "El monto debe ser mayor a 0";
                        }
                        return null;
                      },
                      onSaved: (value) => monto = double.parse(value!),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// ICONO CALENDARIO
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: seleccionarFecha,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fecha == null
                                ? "Fecha No Elegida"
                                : "${fecha!.day.toString().padLeft(2, '0')}/"
                                      "${fecha!.month.toString().padLeft(2, '0')}/"
                                      "${fecha!.year}",
                          ),

                          const SizedBox(width: 10),

                          Icon(
                            Icons.calendar_month_sharp,
                            color: fecha == null ? Colors.black : Colors.black,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // CATEGORIA
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<TipoCategoria>(
                      isExpanded: true,
                      initialValue: categoria,
                      items: TipoCategoria.values.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(nombreCategoria(cat)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          categoria = value!;
                        });
                      },
                    ),
                  ),

                  // BOTONES
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar"),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                fecha != null) {
                              _formKey.currentState!.save();

                              final gastoNuevo = Gasto(
                                titulo: titulo,
                                monto: monto,
                                fecha: fecha!,
                                categoria: categoria,
                              );

                              Navigator.pop(context, gastoNuevo);
                            }
                          },

                          child: const Text("Guardar"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
