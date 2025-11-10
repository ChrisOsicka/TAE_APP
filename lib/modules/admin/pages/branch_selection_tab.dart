import 'package:flutter/material.dart';
import 'package:tae_app/modules/admin/widgets/adaptive_branch_list.dart';
import 'package:tae_app/modules/admin/widgets/add_dialog.dart';
import 'package:tae_app/modules/admin/widgets/custom_navigation_bar_admin.dart';
import 'package:tae_app/modules/admin/widgets/notes_button.dart';
import 'package:tae_app/modules/admin/widgets/search_bar.dart';
import 'group_selection.dart';
import 'wallet_screen.dart';
import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Branches Se traduce a sucursales

/*
FLUJO DE TRABAJO:
1. La app inicia y ejecuta main()
2. MaterialApp crea una instancia de MainBranches como pantalla inicial
3. MainBranches inicializa su estado con _selectedIndex = 0
4. El método build() construye:
 -> Un Scaffold con:
   - body: Muestra BranchesScreen() (porque _selectedIndex = 0)
   - bottomNavigationBar: Muestra la barra con 3 ítems
   - Cuando el usuario toca un ítem:
      Se ejecuta _onItemTapped con el nuevo índice
      setState() actualiza _selectedIndex
      Flutter reconstruye la interfaz mostrando la nueva pantalla
 */

// NOTA : todo en Flutter es un widget.
// Incluso pantallas enteras como BranchesScreen() son widgets.


// main(): Es el punto de entrada de toda aplicación Dart/Flutter.
//runApp(): Función que inicializa la aplicación Flutter y recibe el widget raíz.
//MaterialApp: Widget que proporciona las bases del diseño Material Design y configuración globa
void main() {
  runApp(
    // debugShowCheckedModeBanner -> Quita la etiqueta de "DEBUG" que aparece en la esquina superior
    // home : BranchesScreen() -> Significa que la pantalla principal al iniciar la app sera la clase  BranchesScreen()
    MaterialApp(debugShowCheckedModeBanner: false, home: MainBranches()),
  );
}

// StatelessWidget -> Es un widget que no cambia con el tiempo
// PERO si necesitamos que algo cambie
// - Un contador que aumenta cuando presionas un botón.
// - Una imagen que cambia cuando el usuario hace clic.
// - Mostrar diferentes datos después de presionar un botón.
// Se debe de usar un => StatefulWidget <=
class MainBranches extends StatefulWidget {
  @override
  _MainBranchesState createState() => _MainBranchesState();
}

class _MainBranchesState extends State<MainBranches> {

  // Propósito: Guarda el índice de la pantalla actualmente seleccionada
  int _selectedIndex = 0;

  // Lista de pantallas que cambiarán
  // Aquí defines las pantallas que se mostrarán para cada tab
  final List<Widget> _screens = [
    //HomeScreen(),
    BranchesScreen(), // temporal, cambia según lo que queramos hacer para "recargar" la pagina
    WalletScreen(),
    ProfileScreen(fullName: 'Josepe', email: 'Josepe13186', phone: '34234234', role: 'Administrador', imageUrl: '',),
  ];

  // Método que se llama al tocar un ícono
  // Actualiza el estado con el nuevo índice seleccionado
  void _onItemTapped(int index) {
    // setState(): Notifica a Flutter que debe reconstruir la interfaz
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold — La base visual de la pantalla
      return Scaffold(
      // Muestra la pantalla correspondiente al índice seleccionado
      // body: Muestra la pantalla actual según _selectedIndex
      body: _screens[_selectedIndex],
       // Bottom navigation bar
      // Es la barra que aparece en la parte inferior de la pantalla.
      //Permite que el usuario navegue entre diferentes secciones de la app (por ejemplo: inicio, cartera, perfil).
      bottomNavigationBar: CustomNavigationBarAdmin(
        //(qué pantalla está activa).
        currentIndex: _selectedIndex, 
        // (qué hacer cuando el usuario cambia de pestaña).
        onTap: _onItemTapped,
        ),
    );
  }
}

class BranchesScreen extends StatefulWidget {


  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  /*
  // Lista de mapas List<Map<String, dynamic> ->
  final List<Map<String, dynamic>> branches = [
    {"name": "Centro Sur", "classes": 4, "participants": 70},
    {"name": "Tlacote", "classes": 5, "participants": 150},
    {"name": "Juriquilla", "classes": 3, "participants": 65},
  ];
  */

  // Variable para el stream de sucursales
  Stream<QuerySnapshot>? _branchesStream;

  @override
  void initState() {
    super.initState();
    // 1. Inicializar el stream para TODAS las sucursales
    _branchesStream = _db
        .collection('sucursales')
        .orderBy('name', descending: false) // Opcional: ordenar por nombre
        .snapshots();

        
  }

// Esta funcion es para mandar llamar el modal desde la clase AddDialog
void _openAddBranchDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AddDialog(
      onSave: (newBranchData) async {
        Navigator.of(dialogContext).pop(); // Cierra el diálogo correctamente

        final String branchName = newBranchData['name'];

        try {
          // Crear la nueva sucursal
          final branchToSave = {
            'name': newBranchData['name'],
            'classes': newBranchData['classes'],
            'participants': newBranchData['participants'],
            'fecha_creacion': FieldValue.serverTimestamp(),
          };

          // Guardar en Firebase
          await _db.collection('sucursales').add(branchToSave);

          if (!context.mounted) return;

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sucursal "$branchName" creada exitosamente'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Esperar a que el frame termine antes de navegar
          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => BranchGroupsScreen(branchName: branchName),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            }
          });
        } catch (e) {
          print("Error al guardar sucursal: $e");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al crear la sucursal.'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    ),
  );
}


  // @override significa que estás reescribiendo un método que ya existe en la clase padre (StatelessWidget).
  @override
  Widget build(BuildContext context) {
    // Scaffold — La base visual de la pantalla
    return Scaffold(
      backgroundColor: Colors.white,
      // body: lo que va dentro del cuerpo principal de la pantalla.
      // SafeArea: evita que los elementos queden debajo del notch, barra de estado o botones del sistema.
      /*
        NOTA: El notch es la parte recortada de la pantalla en algunos 
        celulares modernos (como iPhones o algunos Android) 
        donde está la cámara frontal o sensores.
      */
      body: SafeArea(
        // Padding — Espacio alrededor del contenido
        // Padding es un widget que agrega espacio alrededor de su hijo (en este caso, una Column).
        child: Padding(
          // Aquí aplicamos 16 de margen horizontal (izquierda y derecha) y 10 vertical (arriba y abajo).
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

          // Column — Apilar widgets verticalmente, apila widgets de arriba hacia abaj
          child: Column(
            // Alinea el contenido al inicio horizontal (izquierda).
            crossAxisAlignment: CrossAxisAlignment.start,
            // children (en plural) es una lista de
            // widgets hijos que van uno debajo del otro en una Column.
            // NOTA: No confundir con child (en singular), que solo permite un único widget hijo.
            children: [
              // Search bar
              // TextField — Barra de búsqueda
              // TextField: caja de texto donde el usuario puede escribir.
              BarSearch(),
              // Crea un espacio vertical de 10 píxeles entre la caja de búsqueda y el siguiente elemento.
              const SizedBox(height: 10),

              // Agregar Sucursal
              // Alinea su hijo al lado derecho (Alignment.centerRight).
              Align(
                alignment: Alignment.centerRight,
                // Necesario para que InkWell funcione con efecto visual de toque.
                // Aquí es transparente, solo se usa como "base de toque".
                child: Material(
                  color: Colors.transparent, // Para que no tenga fondo
                  // Hace que un widget sea "tocable" (con efecto de onda).
                  // onTap: función que se ejecuta al tocarlo. En este caso, imprime en consola.
                  child: InkWell(
                    onTap: () => _openAddBranchDialog(context),

                    // Padding dentro del botón
                    // Da espacio alrededor del texto e ícono.
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // Pone el texto y el ícono uno al lado del otro.
                      // mainAxisSize: MainAxisSize.min: ajusta el tamaño de la fila a su contenido (no ocupa toda la pantalla).
                      child: Row(
                        // Hace que la Row ocupe solo el espacio necesario para su contenido (no todo el ancho).
                        mainAxisSize: MainAxisSize.min,

                        // Los widgets dentro de la fila:
                        // Text(...): el texto "Agregar Sucursal".
                        //SizedBox(width: 5): espacio entre el texto y el ícono.
                        //Icon(...): ícono de círculo con símbolo de agregar.
                        children: const [
                          Text(
                            'Agregar Sucursal  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.add_circle_outline),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            // === StreamBuilder: Escucha Sucursales en Firebase ===
            
            Expanded( // Usamos Expanded para que la lista ocupe el resto del espacio
              child: StreamBuilder<QuerySnapshot>(
                stream: _branchesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar las sucursales.'));
                  }
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    // Mapeamos los documentos a una lista de Map<String, dynamic>
                    final branchesFromFirebase = snapshot.data!.docs.map((doc) {
                      final data = doc.data()! as Map<String, dynamic>;
                      // Los datos se pasan directamente a tu widget AdaptiveBranchList
                      return {
                        // Asegúrate de que los tipos coincidan (classes y participants deben ser números)
                        'name': data['name'] as String? ?? 'Sin Nombre',
                        'classes': (data['classes'] as num?)?.toInt() ?? 0,
                        'participants': (data['participants'] as num?)?.toInt() ?? 0,
                      };
                    }).toList();
                    
                    // Usamos tu widget AdaptiveBranchList con la data de Firebase
                    return AdaptiveBranchList(
                      branches: branchesFromFirebase, 
                      icon: Icons.location_on_outlined,
                      // Necesitas pasar el ID para navegar al siguiente nivel (Grupos)
                      onTap: (branchName) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BranchGroupsScreen(branchName: branchName.toString()),
                              ),
                          );
                      },
                    );
                  }
                  
                  return const Center(child: Text('No hay sucursales registradas.'));
                },
              ),
            ),
            
            // =================================================

          ],
        ),
      ),
    ),
      floatingActionButton: NotesButton(),
      
    );
  }
}


