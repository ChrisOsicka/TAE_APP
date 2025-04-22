/*
Este importa el paquete material.dart, 
que es parte del framework de Flutter y 
te da acceso a componentes de diseño Material 
(como botones, cajas de texto, AppBar, etc.).
*/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page_admin.dart';

/*
No guarda datos, solo dice:
“Yo necesito un estado. Por favor, 
Flutter, créame uno usando esta clase:
 _LoginPageState”.
*/
class RegisterTeacherStudent extends StatefulWidget {
  const RegisterTeacherStudent({super.key});
  @override
  State<RegisterTeacherStudent> createState() => _RegisterTeacherStudent();
}

class _RegisterTeacherStudent extends State<RegisterTeacherStudent> {
  bool _obscureText = true; // estado inicial: contraseña oculta

  @override
  Widget build(BuildContext context) {
    /* Es un widget de estructura base de una página, que te da:
    Un fondo blanco por defecto
    Opciones para agregar AppBar, body, drawer, etc.
    */
    //return Scaffold(
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Fondo blanco
        title: Text('Volver', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFffffff)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ), // Aumenta este valor para bajar más el texto
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                      ), // Puedes ajustar el espacio aquí
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registro.',
                            style: TextStyle(
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Ingresa los datos de tu academia',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  const SizedBox(height: 10),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffd3d3d3), // Borde gris
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Nombre(s)
                        Container(
                          /*
                    Alínea mi texto a la izquierda 
                    dentro del espacio disponible"
                    "Y empuja ese texto un poco 
                    hacia adentro con un padding"
                    */
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            'Nombre',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 20,
                              color: const Color(0xFF344e41),
                            ),
                          ),
                        ),
                        /*
                    envuelve el TextField, y le 
                    agrega espacio por la izquierda 
                    (left: 20.0).
                    */
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              border: Border.all(
                                color: Color.fromARGB(98, 52, 78, 65),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ingrese Nombre(s)',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        //Apellido paterno
                        Container(
                          /*
                    Alínea mi texto a la izquierda 
                    dentro del espacio disponible"
                    "Y empuja ese texto un poco 
                    hacia adentro con un padding"
                    */
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            'Apellido Paterno',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 20,
                              color: const Color(0xFF344e41),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              border: Border.all(
                                color: Color.fromARGB(98, 52, 78, 65),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: TextField(
                                // ocultar cuando se escribe la contraseña
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ingrese su primer apellido',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        //Apellido materno
                        Container(
                          /*
                    Alínea mi texto a la izquierda 
                    dentro del espacio disponible"
                    "Y empuja ese texto un poco 
                    hacia adentro con un padding"
                    */
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            'Apellido Materno',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 20,
                              color: const Color(0xFF344e41),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              border: Border.all(
                                color: Color.fromARGB(98, 52, 78, 65),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: TextField(
                                // ocultar cuando se escribe la contraseña
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ingrese su segundo apellido',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        //Correo
                        Container(
                          /*
                    Alínea mi texto a la izquierda 
                    dentro del espacio disponible"
                    "Y empuja ese texto un poco 
                    hacia adentro con un padding"
                    */
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            'Email',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 20,
                              color: const Color(0xFF344e41),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              border: Border.all(
                                color: Color.fromARGB(98, 52, 78, 65),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: TextField(
                                // ocultar cuando se escribe la contraseña
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'example@gmai.com',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Contraseña
                        Container(
                          /*
                    Alínea mi texto a la izquierda 
                    dentro del espacio disponible"
                    "Y empuja ese texto un poco 
                    hacia adentro con un padding"
                    */
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            'Contraseña',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 20,
                              color: const Color(0xFF344e41),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFffffff),
                              border: Border.all(
                                color: Color.fromARGB(98, 52, 78, 65),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: TextField(
                              // ocultar cuando se escribe la contraseña
                              obscureText: _obscureText, // este valor cambia
                              decoration: InputDecoration(
                                hintText: 'mínimo 8 caracteres',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        //Confirmar registro
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xff000000),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // Es un widget que te permite detectar interacciones del usuario:
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const HomePageAdmin(),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    'Confirmar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
