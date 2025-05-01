import 'package:flutter/material.dart';
import 'package:taeapp/pruebas/paginas/sesion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Registro(),
    );
  }
}

// Cambia StatelessWidget a StatefulWidget
class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

// Estado de la pantalla de registro
class _RegistroState extends State<Registro> {
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  String selectedUserType = "Alumno"; // Valor inicial del DropdownButton

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrarse"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: cuerpo(context), // Pasa el context al cuerpo
        ),
      ),
    );
  }

  // Cuerpo de la pantalla de registro
  Widget cuerpo(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          registro(),
          _buildTextField("Nombre", validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingresa tu nombre';
            }
            return null;
          }),
          _buildTextField("Apellidos", validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingresa tus apellidos';
            }
            return null;
          }),
          _buildTextField("Usuario", validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingresa un usuario';
            }
            return null;
          }),
          _buildTextField("Correo", validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingresa tu correo';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Correo no válido';
            }
            return null;
          }),
          _buildTextField("Edad", validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingresa tu edad';
            }
            if (int.tryParse(value) == null) {
              return 'Edad no válida';
            }
            return null;
          }),
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
          // DropdownButton para seleccionar el tipo de usuario
          DropdownButton<String>(
            value: selectedUserType,
            onChanged: (String? newValue) {
              setState(() {
                selectedUserType = newValue!;
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
          const SizedBox(height: 20),
          registrar(context), // Pasa el context al botón
        ],
      ),
    );
  }

  // Título de la pantalla
  Widget registro() {
    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      child: const Text(
        "Registro",
        style: TextStyle(
          color: Color.fromARGB(255, 4, 135, 242),
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
        ),
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

  // Botón para registrar
  Widget registrar(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Si todos los campos son válidos, procede con el registro
          print('Registro exitoso');
          print('Tipo de usuario seleccionado: $selectedUserType');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Sesion()),
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
      child: const Text("Registrar"),
    );
  }
}