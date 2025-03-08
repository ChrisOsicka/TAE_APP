import 'package:flutter/material.dart';

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrarse"),
      ),
      body: cuerpo()
      );
  }
}

Widget cuerpo(){
  return Container(
    padding: EdgeInsets.only(bottom: 100),
    decoration: BoxDecoration(
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          registro(),
          nombre(),
          apellidos(),
          correo(),
          edad(),
          const SizedBox(height: 20,),
          registrar(),
        ],
      )
      ),
  );
}

Widget registro(){
return Container(
  padding: const EdgeInsets.only(bottom: 80), // Padding del Container
  child: const Text(
    "Registro",
    style: TextStyle(
      color: Color.fromARGB(255, 4, 135, 242), // Color del texto
      fontSize: 35.0, // Tamaño de la fuente
      fontWeight: FontWeight.bold, // Negrita
    ),
  ),
);
}

Widget nombre(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100, vertical:5),
      child: TextField(
      decoration: InputDecoration(
        hintText: "Nombre",
        fillColor: Colors.grey,
        filled: true,
      ),
    ),
    );
}

Widget apellidos(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100, vertical:5),
      child: TextField(
      decoration: InputDecoration(
        hintText: "Apellidos",
        fillColor: Colors.grey,
        filled: true,
      ),
    ),
    );
}

Widget correo(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100, vertical:5),
      child: TextField(
      decoration: InputDecoration(
        hintText: "Correo",
        fillColor: Colors.grey,
        filled: true,
      ),
    ),
    );
}

Widget edad(){
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 100, vertical:5),
      child: TextField(
      decoration: InputDecoration(
        hintText: "Edad",
        fillColor: Colors.grey,
        filled: true,
      ),
    ),
    );
}

Widget registrar(){
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
              child: const Text("Registrar"),
            );
}