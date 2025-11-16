// student_status_screen.dart
import 'package:flutter/material.dart';

class StudentStatusScreen extends StatefulWidget {
  const StudentStatusScreen({super.key});

  @override
  State<StudentStatusScreen> createState() => _StudentStatusScreenState();
}

class _StudentStatusScreenState extends State<StudentStatusScreen> {
  int _currentIndex = 0; // 0 = Inscripción pagada, 1 = Inscripción no pagada

  final List<Map<String, String>> _alumnosPagados = [
    {'nombre': 'Maribel Castillo', 'estado': 'Pagado', 'grupo': 'Cinta Blanca'},
    {'nombre': 'Jose Jose', 'estado': 'Pagado', 'grupo': 'Cinta Blanca'},
    {'nombre': 'Nancy Herrera', 'estado': 'Pagado', 'grupo': 'Cinta Blanca'},
  ];

  final List<Map<String, String>> _alumnosNoPagados = [
    {'nombre': 'Karen Medina', 'estado': 'Sin Pagar', 'grupo': 'Cinta Blanca'},
    {'nombre': 'Jose Medina', 'estado': 'Sin Pagar', 'grupo': 'Cinta Blanca'},
    {'nombre': 'Dafne Otero', 'estado': 'Sin Pagar', 'grupo': 'Cinta Amarilla'},
    {'nombre': 'Paulo Carrillo', 'estado': 'Sin Pagar', 'grupo': 'Cinta Roja'},
    {'nombre': 'Paulo Carrillo', 'estado': 'Sin Pagar', 'grupo': 'Cinta Roja'},
    {'nombre': 'Paulo Carrillo', 'estado': 'Sin Pagar', 'grupo': 'Cinta Roja'},
    {'nombre': 'Paulo Carrillo', 'estado': 'Sin Pagar', 'grupo': 'Cinta Roja'},
    {'nombre': 'Paulo Carrillo', 'estado': 'Sin Pagar', 'grupo': 'Cinta Roja'},
  ];

  String _busqueda = '';

  late List<Map<String, String>> _alumnosMostrados;

  @override
  void initState() {
    super.initState();
    _alumnosMostrados = List.from(_alumnosNoPagados); // Por defecto, mostramos los no pagados
  }

  void _filtrarAlumnos(String query) {
    setState(() {
      _busqueda = query;
      if (query.isEmpty) {
        _alumnosMostrados = _currentIndex == 0
            ? List.from(_alumnosPagados)
            : List.from(_alumnosNoPagados);
      } else {
        _alumnosMostrados = (_currentIndex == 0 ? _alumnosPagados : _alumnosNoPagados)
            .where((alumno) =>
                alumno['nombre']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 20),
        title: const Text('Estado de Alumnos'),
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
                color:  const Color(0xffe1e3eb),
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
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pestañas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                      _alumnosMostrados = List.from(_alumnosPagados);
                    });
                    _filtrarAlumnos(_busqueda);
                  },
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Inscripción pagada'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentIndex == 0 ? Colors.green[100] : Colors.grey[200],
                    foregroundColor: _currentIndex == 0 ? Colors.black : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                      _alumnosMostrados = List.from(_alumnosNoPagados);
                    });
                    _filtrarAlumnos(_busqueda);
                  },
                  icon: const Icon(Icons.info, size: 18),
                  label: const Text('Inscripción no pagada'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentIndex == 1 ? Colors.red[100] : Colors.grey[200],
                    foregroundColor: _currentIndex == 1 ? Colors.black : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Mensaje informativo
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
                      'Alumnos que aún no pagan.',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Se recomienda revisar las siguientes situaciones.',
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
                  final estado = alumno['estado']!;
                  final color = estado == 'Sin Pagar' ? Colors.red : Colors.green;

                  return Card(
                    child: ListTile(
                      title: Text(alumno['nombre']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Grupo: ${alumno['grupo']}'),
                          Text(
                            estado,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}