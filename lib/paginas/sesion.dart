import 'package:flutter/material.dart';

// Página de inicio de sesión
class Sesion extends StatelessWidget {
  const Sesion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
        body: cuerpo(),
    );
  }
}

Widget cuerpo(){
  return Container(
    decoration: BoxDecoration(
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          nombre(),
          campoUsuario(),
          campocontra(),
          const SizedBox(height: 20,),
          entrar(),
        ],
      )
      ),
  );
}

Widget nombre(){
return Text("Iniciar Sesion", style: TextStyle(color: const Color.fromARGB(255, 4, 135, 242), fontSize: 35.0, fontWeight: FontWeight.bold),);
}

Widget campoUsuario(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical:5),
      child: TextField(
      decoration: InputDecoration(
        hintText: "User",
        fillColor: Colors.grey,
        filled: true,
      ),
    ),
    );
}

Widget campocontra(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical:5),
      child: TextField(
      decoration: InputDecoration(
        hintText: "Contraseña",
        fillColor: Colors.grey,
        filled: true,
      ),
    ),
    );
}

Widget entrar(){
    return ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de registro
                // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 249, 71, 11), // Color de fondo
                foregroundColor: Colors.white, // Color del texto
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text("Entrar"),
            );
}