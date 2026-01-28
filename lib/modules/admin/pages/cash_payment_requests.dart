// cash_payment_requests.dart
import 'package:flutter/material.dart';

class CashPaymentRequestsScreen extends StatefulWidget {
  const CashPaymentRequestsScreen({super.key});

  @override
  State<CashPaymentRequestsScreen> createState() =>
      _CashPaymentRequestsScreenState();
}

class _CashPaymentRequestsScreenState
    extends State<CashPaymentRequestsScreen> {
  final List<Map<String, String>> _todosLosAlumnos = [
    {'nombre': 'Maribel Castillo', 'inscripcion': '1,500', 'grupo': 'Cinta Blanca'},
    {'nombre': 'Jose Jose', 'inscripcion': '1,500', 'grupo': 'Cinta Blanca'},
    {'nombre': 'Nancy Herrera', 'inscripcion': '1,500', 'grupo': 'Cinta Blanca'},
    {'nombre': 'Josue De Vicente', 'inscripcion': '1,500', 'grupo': 'Cinta Blanca'},
    {'nombre': 'Israel García', 'inscripcion': '1,500', 'grupo': 'Cinta Amarilla'},
    
  ];

  late List<Map<String, String>> _alumnosMostrados;
  final Set<String> _alumnosSeleccionados = {};
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    _alumnosMostrados = List.from(_todosLosAlumnos);
  }

  void _filtrarAlumnos(String query) {
    setState(() {
      _busqueda = query;
      if (query.isEmpty) {
        _alumnosMostrados = List.from(_todosLosAlumnos);
      } else {
        _alumnosMostrados = _todosLosAlumnos
            .where((alumno) =>
                alumno['nombre']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleSeleccion(String nombre) {
    setState(() {
      if (_alumnosSeleccionados.contains(nombre)) {
        _alumnosSeleccionados.remove(nombre);
      } else {
        _alumnosSeleccionados.add(nombre);
      }
    });
  }

 void _confirmarSeleccionados() {
  if (_alumnosSeleccionados.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selecciona al menos un alumno')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
        title: const Text('Confirmar inscripciones'),
        content: SizedBox(
          width: double.maxFinite, // Asegura que use todo el ancho disponible
          child: ListView.builder(
            shrinkWrap: true,        // ← Clave: ajusta al contenido
            primary: false,          // ← Clave: evita scroll conflictivo
            itemCount: _alumnosSeleccionados.length,
            itemBuilder: (context, index) {
              final nombre = _alumnosSeleccionados.elementAt(index);
              return ListTile(
                leading: const Icon(Icons.person, color: Colors.purple),
                title: Text(nombre),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Confirmados ${_alumnosSeleccionados.length} alumnos'),
                ),
              );
              setState(() {
                _alumnosSeleccionados.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Confirmar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 20) ,
        title: const Text('Solicitudes de pago en efectivo'),
        backgroundColor: const Color.fromARGB(255, 41, 53, 119),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de búsqueda
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffe1e3eb),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _filtrarAlumnos,
                      decoration: const InputDecoration(
                        hintText: 'Buscar alumno por nombre',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color.fromARGB(255, 194, 191, 191)),
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Descripción
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solicitudes de pago en efectivo',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Se muestran todos los alumnos que hicieron el proceso de pago y aún no se ha confirmado la inscripción.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Lista de alumnos
            Expanded(
              child: ListView.separated(
                itemCount: _alumnosMostrados.length,
                separatorBuilder: (context, index) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final alumno = _alumnosMostrados[index];
                  final nombre = alumno['nombre']!;
                  final seleccionado = _alumnosSeleccionados.contains(nombre);

                  return Card(
                    child: CheckboxListTile(
                      value: seleccionado,
                      onChanged: (value) => _toggleSeleccion(nombre),
                      title: Text(nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pago realizado.'),
                          Text('Inscripción: \$${alumno['inscripcion']}'),
                          Text('Grupo: ${alumno['grupo']}'),
                        ],
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                    ),
                  );
                },
              ),
            ),

            // Botón "Confirmar"
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton.icon(
                onPressed: _confirmarSeleccionados,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirmar seleccionados'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 29, 92, 143),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}