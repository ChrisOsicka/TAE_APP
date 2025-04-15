// archivo: forgot_password_page.dart
import 'package:flutter/material.dart';

class TypeRegister extends StatelessWidget {
  const TypeRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pagina para elegir el tipo de registro que queremos')),
      body: Center(
        child: Text('Aquí ira las 2 opciones para registrarse'),
      ),
    );
  }
}
