import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Notas Alumno',

        theme: ThemeData(
      primarySwatch: Colors.blue,
      // Aquí defines el color de fondo del AppBar para TODA la app
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 39, 39, 39), //  Color de fondo
        foregroundColor: Colors.black, // Color del texto e íconos
      ),
    ),

      
      home: const NotasAlumnoScreen(),
    );

    
    
  }
}

class NotasAlumnoScreen extends StatefulWidget {
  const NotasAlumnoScreen({super.key});

  @override
  State<NotasAlumnoScreen> createState() => _NotasAlumnoScreenState();
}

class _NotasAlumnoScreenState extends State<NotasAlumnoScreen> {
  // Datos simulados del alumno
  final String nombre = "Julio";
  final String grupo = "Cinta Blancas";

  // Lista de notas (simuladas)
  List<Nota> notas = [
    Nota(
      id: 1,
      fecha: DateTime(2025, 3, 11),
      texto: "Julio tiene una buena disciplina pero le falta más paciencia",
      checked: true,
    ),
    Nota(
      id: 2,
      fecha: DateTime(2025, 3, 9),
      texto: "Es de los principales alumnos que muestra interes",
      checked: true,
    ),
    Nota(
      id: 3,
      fecha: DateTime(2025, 3, 1),
      texto: "Poner más atención en las tecnicas que usa",
      checked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notas del Alumno'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado: Avatar, Nombre, Grupo
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/image/Logo.png'), // Reemplaza con tu imagen o usa NetworkImage
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre: $nombre',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Grupo: $grupo',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Botones: Agregar Nota y Eliminar Notas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para agregar nota
                    _agregarNota();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar Nota"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Lógica para eliminar todas las notas seleccionadas
                    _eliminarNotasSeleccionadas();
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Eliminar Notas", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Título: Comentarios
            const Text(
              "Comentarios",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Lista de notas
            Expanded(
              child: ListView.builder(
                itemCount: notas.length,
                itemBuilder: (context, index) {
                  final nota = notas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: nota.checked,
                            onChanged: (value) {
                              setState(() {
                                nota.checked = value!;
                              });
                            },
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fecha: ${_formatDate(nota.fecha)}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(nota.texto),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _editarNota(nota);
                                },
                                icon: const Icon(Icons.edit, color: Colors.purple),
                              ),
                              IconButton(
                                onPressed: () {
                                  _eliminarNotaSeleccionadas(index);
                                },
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Botón Ver más notas
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  // Navegar a otra pantalla o mostrar más notas
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mostrando más notas...")),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Ver más notas"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _agregarNota() {
    // Simulamos agregar una nueva nota
    setState(() {
      notas.add(
        Nota(
          id: notas.length + 1,
          fecha: DateTime.now(),
          texto: "Nueva nota agregada...",
          checked: false,
        ),
      );
    });
  }

 void _eliminarNotasSeleccionadas() {
  // Primero, verifica si hay notas seleccionadas
  if (notas.any((nota) => nota.checked)) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          title: const Text("¿Eliminar notas?"),
          content: const Text("¿Estás seguro de que deseas eliminar las notas seleccionadas?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancelar
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                //  Solo aquí eliminamos las notas
                setState(() {
                  notas.removeWhere((nota) => nota.checked);
                });
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Eliminar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  } else {
    // Opcional: mostrar mensaje si no hay notas seleccionadas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No hay notas seleccionadas para eliminar")),
    );
  }
}

void _eliminarNotaSeleccionadas(int index) {
  // Primero, verifica si hay notas seleccionadas
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          title: const Text("¿Eliminar nota?"),
          content: const Text("¿Estás seguro de que deseas eliminar está nota?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancelar
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                //  Solo aquí eliminamos las notas
                setState(() {
                    notas.removeAt(index);
                });
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Eliminar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  
}

  void _editarNota(Nota nota) {
    // Mostrar diálogo para editar la nota
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: nota.texto);
        return AlertDialog(
          title: const Text("Editar Nota"),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(hintText: "Escribe tu comentario"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  nota.texto = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}

class Nota {
  int id;
  DateTime fecha;
  String texto;
  bool checked;

  Nota({
    required this.id,
    required this.fecha,
    required this.texto,
    required this.checked,
  });
}