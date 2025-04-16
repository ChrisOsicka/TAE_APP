// archivo: forgot_password_page.dart
import 'package:flutter/material.dart';

class TypeRegister extends StatelessWidget {
  const TypeRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: 
      Stack(
  children: [
    Positioned(
      left: 30,
      top: 90,
      child: SizedBox(
        width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Para que la Column no ocupe todo el espacio
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
        children: [
          Text(
            'Registro',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10), // Espacio entre título y subtítulo
          Text(
            'Administra tu academia o ingresa a una clase',
            style: TextStyle(
              fontSize: 20,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),
          Column(
          children: [
            Transform.translate(
              offset: Offset(110, 100),  // Desplazamiento en píxeles (x,y)
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Cero para hacerlo completamente cuadrado
                    ),
                  backgroundColor: const Color.fromARGB(255, 10, 10, 10), // Color de fondo (en versiones recientes usa backgroundColor)
                    foregroundColor: Colors.white, // Color del texto (en versiones recientes usa foregroundColor)
                        padding: EdgeInsets.all(15),
                        ),
                        onPressed: () {},
                        child: Text('Administrador'),
                        )
            ),
            SizedBox(height: 20),
            Transform.translate(
              offset: Offset(110, 100),  // Desplazamiento en píxeles (x,y)
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Cero para hacerlo completamente cuadrado
                    ),
                  backgroundColor: const Color.fromARGB(255, 173, 172, 172), // Color de fondo (en versiones recientes usa backgroundColor)
                    foregroundColor: const Color.fromARGB(255, 12, 12, 12), // Color del texto (en versiones recientes usa foregroundColor)
                        padding: EdgeInsets.all(15),
                        ),
                onPressed: () {},
                  child: Text('Alumno/Instructor'),
      ),
    ),
  ],
)
        ],
      ),
      ),
    ),
  ], 
)
      );
  }
}
