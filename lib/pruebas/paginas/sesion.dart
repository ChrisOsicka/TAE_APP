import 'package:flutter/material.dart';
import 'package:taeapp/pruebas/paginas/adminpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iniciar Sesión',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Sesion(),
    );
  }
}

// Cambia StatelessWidget a StatefulWidget
class Sesion extends StatefulWidget {
  const Sesion({super.key});

  @override
  State<Sesion> createState() => _SesionState();
}

// Estado de la pantalla de inicio de sesión
class _SesionState extends State<Sesion> {
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  String selectedValue = "Admin"; // Valor seleccionado en el DropdownButton

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
      ),
      body: Form(
        key: _formKey,
        child: cuerpo(context), // Pasa el context al cuerpo
      ),
    );
  }

  // Cuerpo de la pantalla de inicio de sesión
  Widget cuerpo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            nombre(),
            const SizedBox(height: 20),
            // DropdownButton para seleccionar una opción
            DropdownButton<String>(
              value: selectedValue,
              onChanged: (newValue) {
                // Actualiza el estado cuando el usuario selecciona una opción
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items: <String>["Admin", "Instructor", "Alumno"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            // Campo de texto para la contraseña
            _buildTextField("Contraseña", isPassword: true, validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu contraseña';
              }
              if (value.length < 8) {
                return 'La contraseña debe tener al menos 8 caracteres';
              }
              return null;
            }),
            const SizedBox(height: 20),
            // Botón para iniciar sesión
            entrar(context),
          ],
        ),
      ),
    );
  }

  // Título de la pantalla
  Widget nombre() {
    return const Text(
      "Iniciar Sesión",
      style: TextStyle(
        color: Color.fromARGB(255, 4, 135, 242),
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Método para construir un campo de texto
  Widget _buildTextField(String hintText, {bool isPassword = false, String? Function(String?)? validator}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        validator: validator,
      ),
    );
  }

  // Botón para iniciar sesión
  Widget entrar(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Si todos los campos son válidos, procede con el inicio de sesión
          print('Inicio de sesión exitoso');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 249, 71, 11),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text("Entrar"),
    );
  }
}