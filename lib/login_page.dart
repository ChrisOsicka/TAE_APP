import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importación clave de Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Importación para Firestore
import 'package:tae_app/firebase_options.dart';
/*
Este importa el paquete material.dart, 
que es parte del framework de Flutter y 
te da acceso a componentes de diseño Material 
(como botones, cajas de texto, AppBar, etc.).
*/
import '../modules/admin/pages/branch_selection_tab.dart';
import '../modules/authentication/pages/forgot_password_page.dart';
import '../modules/authentication/pages/type_register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necesario antes de usar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const WelcomeTaeApp());
}

// 2. Crea un nuevo widget que envuelva a tu LoginPage con MaterialApp.
class WelcomeTaeApp extends StatelessWidget {
  const WelcomeTaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // (Opcional) Puedes añadir un título a la aplicación
      title: 'TAE App', 
      // La propiedad 'home' define el widget inicial (tu LoginPage)
      home: LoginPage(), 
      // Si quieres que el banner "DEBUG" desaparezca:
      debugShowCheckedModeBanner: false,
    );
  }
}


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
// === 1. CONTROLADORES Y ESTADO ===
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Si decides usar Form
  bool _isLoading = false; // Para el botón de carga
  bool _obscureText = true; // Para ocultar/mostrar contraseña

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // === 2. LÓGICA DE INICIO DE SESIÓN Y REDIRECCIÓN ===
  Future<void> _signIn() async {
    // Si hubiese validaciones, irían aquí (con _formKey.currentState!.validate())

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu email y contraseña.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    

    try {
      // A. AUTENTICACIÓN: Iniciar sesión con Firebase Auth
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // B. FIRESTORE: Leer el rol del usuario para la redirección
      final userDoc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

      if (userDoc.exists) {
        final userType = userDoc.data()?['tipo'] ?? 'alumno'; 
        
        // C. NAVEGACIÓN: Redirigir según el rol
        if (mounted) {
  Widget nextPage;
  
  // 1. LÓGICA DE DECISIÓN: Asignar la página correcta
  if (userType == 'admin') {
    // Si es administrador, va a la pantalla principal de pestañas (MainBranches)
    nextPage = MainBranches(); 
  } else {
    // Si no es admin (es alumno u otro rol), va a la página del alumno
    // Asumiendo que esta clase existe:
    // next_page = const HomePageAlumno(); 

    // 🚨 Como no tenemos la página del alumno, usaremos MainBranches temporalmente
    // O si quieres que falle si no es admin, puedes lanzar un error o ir al login.
    nextPage = MainBranches(); // Reemplázalo con HomePageAlumno() cuando esté lista.
  }
  
  // 2. EJECUTAR NAVEGACIÓN REEMPLAZADA con la variable nextPage
  // Usamos pushReplacement para que el Login se elimine de la pila de navegación.
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => nextPage), // << ¡USAR nextPage AQUÍ!
  );
}
      } else {
        // Si el usuario existe en Auth pero no en Firestore
        await FirebaseAuth.instance.signOut(); // Cierra la sesión
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Usuario sin perfil asignado.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      // Errores de credenciales inválidas o usuario no encontrado
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Email o contraseña incorrectos.';
      } else if (e.code == 'invalid-email') {
        message = 'Formato de email incorrecto.';
      } else {
        message = 'Error de autenticación: ${e.message}';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error inesperado: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Detener el spinner
        });
      }
    }
  }


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
                                controller: _emailController, // << CONEXIÓN
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
                                controller: _passwordController,
                                // ocultar cuando se escribe la contraseña
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'mínimo 8 caracteres',
                                  // 2. Añadir el ícono de ojo
                                  suffixIcon: IconButton(
                                  icon: Icon(
                                    // Cambia el ícono según el estado de la contraseña
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  // 3. Al presionar, invierte el estado de _obscureText
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
                        ),
                        const SizedBox(height: 30),

                        //sign in buttom
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Material(
                            // Widget Material para mejor feedback visual
                            color: Colors.black, // Color de fondo del botón
                            borderRadius: BorderRadius.circular(20),
                            // está diseñado específicamente para áreas clickables Proporciona el efecto de onda (ripple) por defecto
                            child: InkWell(
                              // Reemplaza GestureDetector+Container por InkWell
                              borderRadius: BorderRadius.circular(20),
                              // === MODIFICACIÓN CLAVE: Llama a la función de Firebase ===
                              onTap: _signIn, 
                              // =========================================================
                              child: Container(
                                padding: EdgeInsets.all(20),
                                // width: double.infinity hace que el botón ocupe todo el ancho del Padding
                                width:
                                    double
                                        .infinity, // Ocupa todo el ancho disponible
                                child: Center(
                                  child: Text(
                                    'Iniciar Sesión',
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
                              builder: (context) => const TypeRegister(),
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
