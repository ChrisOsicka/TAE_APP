import 'package:flutter/material.dart';
import 'package:taeapp/paginas/registro.dart';
import 'package:taeapp/paginas/sesion.dart';

void main() => runApp(const TaeApp());

class TaeApp extends StatelessWidget {
  const TaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Para quitar el banner de debug
      title: "TaeApp",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo de la aplicación
            Image.asset(
              'assets/Logo.png', // Asegúrate de que la ruta de la imagen sea correcta
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20), // Espacio entre el logo y los botones
            
            Text(
            "Bienvenido a TaeApp", // Texto del título
            style: TextStyle(
            fontSize: 24, // Tamaño de la fuente
            fontWeight: FontWeight.bold, // Negrita
            color: Colors.blue, // Color del texto
            fontStyle: FontStyle.italic, // Cursiva
            letterSpacing: 1.5, // Espaciado entre letras
            ),
            ),
            
            const SizedBox(height: 20),
            // Botón de Iniciar Sesión
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de inicio de sesión
                // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Sesion()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo
                foregroundColor: Colors.white, // Color del texto
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                
              ),
              child: const Text("Iniciar Sesión"),
            ),

            const SizedBox(height: 10), // Espacio entre los botones

            // Botón de Registrarse
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de registro
                // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Registro()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 249, 71, 11), // Color de fondo
                foregroundColor: Colors.white, // Color del texto
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }
}