// archivo: forgot_password_page.dart
import 'package:flutter/material.dart';
// Redireccion al registro de alumno maestro.
import 'register_teacher_student.dart';
// Redireccion al registro de admin maestro.
import 'register_admin.dart';

class TypeRegister extends StatelessWidget {
  const TypeRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      appBar: AppBar(
        backgroundColor: Colors.black, // Fondo blanco
        title: Text('Volver', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          width: 400, // Ajusta el ancho que desees
          margin: EdgeInsets.all(40), // Margen alrededor del contenedor
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xffd3d3d3), width: 1.5),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(
                      255,
                      178,
                      178,
                      178,
                    ).withValues(), // Color de la sombra
                blurRadius: 2, // Difuminado
                offset: Offset(0, 4), // Dirección de la sombra
              ),
            ],
          ),
          padding: EdgeInsets.all(20), // Espacio interno
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Hace que el alto se ajuste al contenido

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registro',
                style: TextStyle(fontSize: 37, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Administra tu academia o ingresa a una clase',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 50), // Espacio antes de los botones
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const RegisterAdmin(),
                          ),
                        );
                      },
                      child: Text(
                        'Administrador',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffadacac),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const RegisterTeacherStudent(),
                          ),
                        );
                      },
                      child: Text(
                        'Alumno / Instructor',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
