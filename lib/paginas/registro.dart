import 'package:flutter/material.dart';

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

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrarse"),
      ),
      body: Form(
        key: _formKey,
        child: cuerpo(),
      ),
    );
  }
}

final _formKey = GlobalKey<FormState>();

Widget cuerpo() {
  return Container(
    padding: const EdgeInsets.only(bottom: 100),
    child: Center(
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
          registrar(),
        ],
      ),
    ),
  );
}

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

Widget _buildTextField(String hintText, {bool isPassword = false, String? Function(String?)? validator}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
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

Widget registrar() {
  return ElevatedButton(
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        // Si todos los campos son válidos, procede con el registro
        print('Registro exitoso');
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