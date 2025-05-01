import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamenesGradosPage extends StatefulWidget {
  const ExamenesGradosPage({super.key});

  @override
  State<ExamenesGradosPage> createState() => _ExamenesGradosPageState();
}

class _ExamenesGradosPageState extends State<ExamenesGradosPage> {
  // Lista de alumnos (simulada)
  final List<Alumno> _alumnos = [
    Alumno(nombre: 'Juan Pérez', cintaActual: 'Blanca', edad: 12),
    Alumno(nombre: 'María López', cintaActual: 'Amarilla', edad: 14),
  ];

  // Técnicas requeridas por cinturón
  final Map<String, List<String>> _tecnicasPorCinta = {
    'Blanca': ['Forma Taegeuk 1', 'Patadas frontales', 'Defensas básicas'],
    'Amarilla': ['Forma Taegeuk 2', 'Patadas laterales', 'Defensas medias'],
    'Verde': ['Forma Taegeuk 3', 'Patadas giratorias', 'Combos básicos'],
    // Agrega más cinturones...
  };

  DateTime _fechaExamen = DateTime.now();
  Alumno? _alumnoSeleccionado;
  String? _cintaObjetivo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exámenes de Grados'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Formulario para programar examen
            _buildFormularioExamen(),
            const SizedBox(height: 20),
            // Lista de exámenes programados
            _buildListaExamenes(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.add),
        onPressed: () => _mostrarFormularioExamen(context),
      ),
    );
  }

  Widget _buildFormularioExamen() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Programar Examen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<Alumno>(
              decoration: const InputDecoration(labelText: 'Alumno'),
              items: _alumnos.map((alumno) {
                return DropdownMenuItem(
                  value: alumno,
                  child: Text('${alumno.nombre} (${alumno.cintaActual})'),
                );
              }).toList(),
              onChanged: (alumno) => setState(() => _alumnoSeleccionado = alumno),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Cinta Objetivo'),
              items: _tecnicasPorCinta.keys.map((cinta) {
                return DropdownMenuItem(
                  value: cinta,
                  child: Text(cinta),
                );
              }).toList(),
              onChanged: (cinta) => setState(() => _cintaObjetivo = cinta),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('Fecha: ${DateFormat('dd/MM/yyyy').format(_fechaExamen)}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _seleccionarFecha(context),
              ),
            ),
            ElevatedButton(
              onPressed: _alumnoSeleccionado == null || _cintaObjetivo == null
                  ? null
                  : () => _guardarExamen(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Programar Examen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaExamenes() {
    // Simulación de exámenes (en una app real vendrían de una base de datos)
    final examenes = [
      Examen(
        alumno: _alumnos[0],
        cintaObjetivo: 'Amarilla',
        fecha: DateTime.now().add(const Duration(days: 7)),
        tecnicas: _tecnicasPorCinta['Blanca']!,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Próximos Exámenes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...examenes.map((examen) => _buildCardExamen(examen)),
      ],
    );
  }

  Widget _buildCardExamen(Examen examen) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getColorCinta(examen.alumno.cintaActual),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              examen.alumno.cintaActual[0],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(examen.alumno.nombre),
        subtitle: Text('A ${examen.cintaObjetivo} - ${DateFormat('dd/MM').format(examen.fecha)}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Técnicas requeridas:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...examen.tecnicas.map((tecnica) => CheckboxListTile(
                  title: Text(tecnica),
                  value: examen.tecnicasEvaluadas[tecnica] ?? false,
                  onChanged: (value) {
                    // En una app real, actualizarías el estado del examen
                  },
                )),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _mostrarDetallesExamen(context, examen),
                  child: const Text('Evaluar Examen'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarFormularioExamen(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Formulario ya visible en la pantalla.')),
  );
}

Future<void> _seleccionarFecha(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _fechaExamen,
    firstDate: DateTime.now(),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != _fechaExamen) {
    setState(() {
      _fechaExamen = picked;
    });
  }
}

void _guardarExamen() {
  if (_alumnoSeleccionado == null || _cintaObjetivo == null) return;

  final nuevoExamen = Examen(
    alumno: _alumnoSeleccionado!,
    cintaObjetivo: _cintaObjetivo!,
    fecha: _fechaExamen,
    tecnicas: _tecnicasPorCinta[_alumnoSeleccionado!.cintaActual] ?? [],
  );

  // Aquí deberías guardar el examen en una lista o base de datos.
  // Por ahora mostramos un mensaje.
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Examen programado exitosamente')),
  );

  setState(() {
    _alumnoSeleccionado = null;
    _cintaObjetivo = null;
    _fechaExamen = DateTime.now();
  });
}

Color _getColorCinta(String cinta) {
  switch (cinta) {
    case 'Blanca':
      return Colors.white;
    case 'Amarilla':
      return Colors.yellow[700]!;
    case 'Verde':
      return Colors.green;
    case 'Azul':
      return Colors.blue;
    case 'Roja':
      return Colors.red;
    case 'Negra':
      return Colors.black;
    default:
      return Colors.grey;
  }
}

void _mostrarDetallesExamen(BuildContext context, Examen examen) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Detalles del Examen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alumno: ${examen.alumno.nombre}'),
            Text('Cinta actual: ${examen.alumno.cintaActual}'),
            Text('Cinta objetivo: ${examen.cintaObjetivo}'),
            Text('Fecha: ${DateFormat('dd/MM/yyyy').format(examen.fecha)}'),
            const SizedBox(height: 10),
            const Text('Técnicas:'),
            ...examen.tecnicas.map((t) => Text('- $t')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

}

// Modelos de datos
class Alumno {
  final String nombre;
  final String cintaActual;
  final int edad;

  Alumno({required this.nombre, required this.cintaActual, required this.edad});
}

class Examen {
  final Alumno alumno;
  final String cintaObjetivo;
  final DateTime fecha;
  final List<String> tecnicas;
  final Map<String, bool> tecnicasEvaluadas;

  Examen({
    required this.alumno,
    required this.cintaObjetivo,
    required this.fecha,
    required this.tecnicas,
  }) : tecnicasEvaluadas = {for (var t in tecnicas) t: false};
}