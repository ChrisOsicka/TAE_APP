import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioClasesPage extends StatefulWidget {
  const CalendarioClasesPage({super.key});

  @override
  State<CalendarioClasesPage> createState() => _CalendarioClasesPageState();
}

class _CalendarioClasesPageState extends State<CalendarioClasesPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  // Función para normalizar fechas (ignorar hora)
  DateTime _fechaSinHora(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  // Lista de clases con fechas normalizadas
  final Map<DateTime, List<Clase>> _clases = {
    DateTime(2023, 11, 15): [
      Clase('Clase niños', '17:00 - 18:00', 'Instructor Carlos', 'Verde'),
    ],
    DateTime(2023, 11, 17): [
      Clase('Clase adultos', '19:00 - 20:30', 'Instructor Ana', 'Negra'),
      Clase('Clase privada', '16:00 - 17:00', 'Instructor Luis', 'Roja'),
    ],
    DateTime.now().subtract(const Duration(days: 1)): [
      Clase('Clase principiantes', '18:00 - 19:00', 'Instructor María', 'Amarilla'),
    ],
    DateTime.now(): [
      Clase('Clase avanzados', '20:00 - 21:30', 'Instructor Juan', 'Negra'),
    ],
  };

  // Cargador de eventos con fechas normalizadas
  List<Clase> _eventLoader(DateTime day) {
    return _clases[_fechaSinHora(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Clases'),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _mostrarFormularioClase(context),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: _fechaSinHora(DateTime.now().subtract(const Duration(days: 30))),
            lastDay: _fechaSinHora(DateTime.now().add(const Duration(days: 30))),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            eventLoader: _eventLoader,
            calendarStyle: CalendarStyle(
              markersAlignment: Alignment.bottomCenter,
              markerDecoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green[400],
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.green[200],
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(20),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildListaClases(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add),
        onPressed: () => _mostrarFormularioClase(context),
      ),
    );
  }

  Widget _buildListaClases() {
    final clasesDelDia = _eventLoader(_selectedDay ?? DateTime.now());

    if (clasesDelDia.isEmpty) {
      return const Center(
        child: Text(
          'No hay clases programadas',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: clasesDelDia.length,
      itemBuilder: (context, index) {
        final clase = clasesDelDia[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getColorCinta(clase.cinta),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  clase.cinta[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              clase.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clase.horario),
                Text(clase.instructor),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.people, color: Colors.green),
              onPressed: () => _mostrarAsistencia(context, clase),
            ),
            onLongPress: () => _confirmarEliminarClase(context, clase),
          ),
        );
      },
    );
  }
  void _mostrarFormularioClase(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Nueva Clase', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(decoration: const InputDecoration(labelText: 'Nombre de la clase')),
                TextField(decoration: const InputDecoration(labelText: 'Horario')),
                TextField(decoration: const InputDecoration(labelText: 'Instructor')),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Cinta'),
                  items: ['Blanca', 'Amarilla', 'Verde', 'Azul', 'Roja', 'Negra']
                      .map((cinta) => DropdownMenuItem(
                            value: cinta,
                            child: Text(cinta),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para guardar la clase
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar Clase'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

void _mostrarAsistencia(BuildContext context, Clase clase) {
  // Lista tipada con la clase Alumno
  final List<Alumno> alumnos = [
    Alumno(nombre: 'Juan Pérez', asistio: false),
    Alumno(nombre: 'María López', asistio: true),
    Alumno(nombre: 'Carlos Gómez', asistio: false),
  ];

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Asistencia: ${clase.nombre}'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: alumnos.length,
                itemBuilder: (context, index) {
                  final alumno = alumnos[index];
                  return CheckboxListTile(
                    title: Text(alumno.nombre), // Acceso seguro
                    value: alumno.asistio,      // Acceso seguro
                    onChanged: (bool? value) {
                      setState(() {
                        alumno.asistio = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Aquí puedes guardar los cambios si necesitas
                  Navigator.pop(context);
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}
  

  void _confirmarEliminarClase(BuildContext context, Clase clase) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar clase'),
          content: Text('¿Seguro que deseas eliminar "${clase.nombre}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para eliminar
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Clase "${clase.nombre}" eliminada')),
                );
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  Color _getColorCinta(String cinta) {
    switch (cinta) {
      case 'Negra': return Colors.black;
      case 'Roja': return Colors.red;
      case 'Verde': return Colors.green;
      case 'Azul': return Colors.blue;
      case 'Amarilla': return Colors.yellow[700]!;
      default: return Colors.grey;
    }
  }
  
}

class Clase {
  final String nombre;
  final String horario;
  final String instructor;
  final String cinta;

  Clase(this.nombre, this.horario, this.instructor, this.cinta);

  @override
  String toString() => nombre; // Importante para los marcadores
}

class Alumno {
  final String nombre;
  bool asistio;

  Alumno({required this.nombre, required this.asistio});
}