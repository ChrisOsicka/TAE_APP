/*
Este importa el paquete material.dart, 
que es parte del framework de Flutter y 
te da acceso a componentes de diseño Material 
(como botones, cajas de texto, AppBar, etc.).
*/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../admin/pages/home_page_admin.dart';
import 'forgot_password_page.dart';
import 'type_register.dart';

/*
No guarda datos, solo dice:
“Yo necesito un estado. Por favor, 
Flutter, créame uno usando esta clase:
 _LoginPageState”.
*/
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  // es el método que construye la UI (la interfaz de usuario)
  // cada vez que algo cambia.
  Widget build(BuildContext context) {
    /* Es un widget de estructura base de una página, que te da:
    Un fondo blanco por defecto
    Opciones para agregar AppBar, body, drawer, etc.
    */
    //return Scaffold(
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFffffff)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, top: 20),
                      child: Image.asset(
                        'assets/image/TAE - APP LOGIN.png',
                        width: 460,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //Icon
                  /* 
                  Icon(
                    Icons.apple_rounded,
                    size: 100,
                    color: Color(0xFF344e41),
                  ),
                  */

                  //hello
                  /*
                  Text(
                    'TAE APP',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 45,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  */
                  const SizedBox(height: 20),

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
                        //Email textfield
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
                                  hintText: 'correo@gmail.com',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        //password textfield
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
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: TextField(
                                // ocultar cuando se escribe la contraseña
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'mínimo 8 caracteres',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        //sign in buttom
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
                                          (context) =>
                                              const HomePageAdmin(),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    'Inicar Sesión',
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

                        //password?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MouseRegion(
                              cursor:
                                  SystemMouseCursors.click, //  cambia el cursor
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "¿Olvidaste tu contraseña?",
                                  style: TextStyle(
                                    // Subrayamos el texto
                                    decoration: TextDecoration.underline,

                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  //not member
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿No tienes una cuenta?",
                        style: TextStyle(
                          // Colocar el texto subrayado
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Agregamos un boton.
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const TypeRegister(),
                                    ),
                                  );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xff000000,
                          ), // Color de fondo
                          foregroundColor: Colors.white, // Color del texto
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Bordes redondeados
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Regístrate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
