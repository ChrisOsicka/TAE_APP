import 'package:flutter/material.dart';
import 'package:taeapp/pruebas/paginas/pagos.dart';
import 'package:taeapp/pruebas/paginas/calendaro.dart';
import 'package:taeapp/pruebas/paginas/grados.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantalla de Administrador',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Lista de alumnos con sus cintas y rangos
  final List<Map<String, String>> alumnos = const [
    {"nombre": "Juan Pérez", "cinta": "Blanca", "rango": "10º GUP"},
    {"nombre": "María López", "cinta": "Amarilla", "rango": "8º GUP"},
    {"nombre": "Carlos Gómez", "cinta": "Verde", "rango": "6º GUP"},
    {"nombre": "Ana Martínez", "cinta": "Azul", "rango": "4º GUP"},
    {"nombre": "Luis Rodríguez", "cinta": "Roja", "rango": "2º GUP"},
    {"nombre": "Sofía García", "cinta": "Negra", "rango": "1º DAN"},
  ];

  String selectedCinta = "Todas"; // Valor inicial del filtro

  @override
  Widget build(BuildContext context) {
    // Filtrar la lista de alumnos según la cinta seleccionada
    final filteredAlumnos = selectedCinta == "Todas"
        ? alumnos
        : alumnos.where((alumno) => alumno["cinta"] == selectedCinta).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Administrador"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // DropdownButton para filtrar por cinta
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarioClasesPage()),
                );
              },
              icon: const Icon(Icons.calendar_today, size: 20),
              label: const Text("Ver Calendario de Clases", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedCinta,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCinta = newValue!;
                });
              },
              items: <String>["Todas", "Blanca", "Amarilla", "Verde", "Azul", "Roja", "Negra"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          // Lista de alumnos filtrada
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredAlumnos.length,
              itemBuilder: (context, index) {
                final alumno = filteredAlumnos[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: _buildCintaIcon(alumno["cinta"]!),
                    title: Text(
                      alumno["nombre"]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Rango: ${alumno["rango"]}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Acción al seleccionar un alumno
                      print("Alumno seleccionado: ${alumno["nombre"]}");
                    },
                  ),
                );
              },
            ),
          ),
          // Botón para ir a la página de pagos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navegar a la página de pagos
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PagosScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text("Ver Pagos"),
            ),
          ),
          // Botón para ir a la página de grados
Padding(
  padding: const EdgeInsets.all(16.0),
  child: ElevatedButton(
    onPressed: () {
      // Navegar a la página de grados
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExamenesGradosPage()),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    child: const Text("Ver Grados"),
  ),
),

        ],
      ),
    );
  }

  // Método para construir el ícono de la cinta
  Widget _buildCintaIcon(String cinta) {
    Color color;
    switch (cinta) {
      case "Blanca":
        color = Colors.white;
        break;
      case "Amarilla":
        color = Colors.yellow;
        break;
      case "Verde":
        color = Colors.green;
        break;
      case "Azul":
        color = Colors.blue;
        break;
      case "Roja":
        color = Colors.red;
        break;
      case "Negra":
        color = Colors.black;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          cinta[0], // Muestra la primera letra de la cinta
          style: TextStyle(
            color: color == Colors.black ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

