/*
Este importa el paquete material.dart, 
que es parte del framework de Flutter y 
te da acceso a componentes de diseño Material 
(como botones, cajas de texto, AppBar, etc.).
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tae_app/modules/authentication/pages/licenses.dart';
import '../../admin/pages/home_page_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
No guarda datos, solo dice:
“Yo necesito un estado. Por favor, 
Flutter, créame uno usando esta clase:
 _LoginPageState”.
*/
class RegisterAdmin extends StatefulWidget {
  const RegisterAdmin({super.key});
  @override
  State<RegisterAdmin> createState() => _RegisterAdmin();
}

class _RegisterAdmin extends State<RegisterAdmin> {
  // Sirve para poder hacer las validaciones
  // Cuando creas un formulario con Form(...), 
  // necesitas una forma de acceder a su estado 
  // (para validar, guardar, etc). Esto se hace así:
  final _formKey = GlobalKey<FormState>();
  // Entonces puedes llamar a métodos como: _formKey.currentState!.validate()
  // Llama a todos los validator definidos en tus TextFormField.
  // -> Retorna true si todo está válido, o false si algún campo no cumple
  // En este caso lo usaremos para validar la contraseña.
  
  bool _obscureText = true; // estado inicial: contraseña oculta

    // 1. Controladores para capturar los datos del formulario
  final _nombreController = TextEditingController();
  final _apController = TextEditingController(); // Apellido Paterno
  final _amController = TextEditingController(); // Apellido Materno
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Es buena práctica liberar los recursos cuando el widget se destruye
    _nombreController.dispose();
    _apController.dispose();
    _amController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // === FUNCIÓN CLAVE: LÓGICA DE REGISTRO EN FIREBASE =======
  // =========================================================
  Future<void> _registerAdmin() async {
    // 1. Validar el formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // 2. CREAR LA CUENTA EN FIREBASE AUTH (Email y Contraseña)
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Obtener el UID único generado por Firebase Auth
      final uid = userCredential.user!.uid;

      // 3. GUARDAR LOS DATOS DEL ADMINISTRADOR EN CLOUD FIRESTORE
      // Usamos el UID como ID del Documento para vincular Auth y DB
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'id_usuario': uid,
        'nombre': _nombreController.text.trim(),
        'ap': _apController.text.trim(),
        'am': _amController.text.trim(),
        'correo': _emailController.text.trim(),
        'telefono': _telefonoController.text.trim(),
        'tipo': 'admin', // Establece el rol de administrador
        'fecha_registro': Timestamp.now(), // Marca la hora de registro
        
        // Incluye el perfil anidado (aunque no se use en esta vista, es parte del modelo)
        'perfil': { 
            'categoria': 'instructor_admin', // O el perfil inicial que desees
            // Nota: No se guarda la contraseña de perfil aquí para el admin, ya que el campo 'password' de tu modelo relacional
            // es manejado por Firebase Auth. Solo se mantiene si fuera estrictamente necesario para la lógica de la app.
        }
      });

      // 4. ÉXITO: Mostrar mensaje y navegar a la página de inicio
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Administrador registrado con éxito!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePageAdmin()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // 5. MANEJO DE ERRORES DE AUTENTICACIÓN
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'El correo ya está registrado.';
      } else if (e.code == 'weak-password') {
        message = 'La contraseña es demasiado débil. Usa más caracteres.';
      } else {
        message = 'Error de registro: ${e.message}';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }

    } on FirebaseException catch (e) { // <<=== AÑADIR ESTE BLOQUE
      // 6. MANEJO DE ERRORES DE FIRESTORE/GENERALES DE FIREBASE
      // Esto capturará los errores de permisos (Reglas de Firestore) u otros errores de DB.
      // Y, al ser específico, ayuda a que el motor de Flutter Web lo maneje mejor.
      String message = 'Error en la base de datos: ${e.message}';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
      
    } catch (e) {
      // 6. MANEJO DE OTROS ERRORES (ej: Firestore)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error inesperado: $e')),
        );
      }
    } 
  }

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
                            'Registro Admin.',
                            style: TextStyle(
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Todos los campos son obligatorios \npara registrarte correctamente.',
                            style: TextStyle(
                              fontSize: 24,
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
                                controller: _nombreController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ingrese Nombre(s)',
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]'),
                                  ), // solo letras y espacios
                                ],
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
                                controller: _apController,
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
                                controller: _amController,
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
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'example@gmail.com',
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        //Número
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
                            'Número de telefono',
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
                              child: TextFormField(
                                controller: _telefonoController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '+52',
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Contraseña
                        SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFffffff),
                                      border: Border.all(
                                        color: Color.fromARGB(98, 52, 78, 65),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: TextFormField(
                                      controller: _passwordController,
                                      // ocultar cuando se escribe la contraseña
                                      obscureText:
                                          _obscureText, // este valor cambia
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Campo requerido';
                                        }
                                        final regex = RegExp(
                                          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$',
                                        );
                                        if (!regex.hasMatch(value)) {
                                          return 'Debe tener al menos 8 caracteres,\nuna mayúscula, una minúscula,\nun número y un símbolo => [ (  ,  )  ,  !  ,  _  ]';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                //Confirmar registro
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        _registerAdmin();
                                        if (_formKey.currentState!.validate()) {
                                         Navigator.push(
                                            context, 
                                            MaterialPageRoute(
                                            builder: (context) => LicenciaScreen(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Color(0xff000000),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
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
                        ),
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
