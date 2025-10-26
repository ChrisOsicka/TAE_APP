import 'package:flutter/material.dart';
import 'package:tae_app/modules/admin/pages/branch_selection_tab.dart';
import 'package:tae_app/modules/admin/pages/profile_screen.dart';
import 'package:tae_app/modules/admin/pages/students_section.dart';
import 'package:tae_app/modules/admin/pages/wallet_screen.dart';
import 'package:tae_app/modules/admin/widgets/activities_card.dart';
import 'package:tae_app/modules/admin/widgets/adaptive_branch_list.dart';
import 'package:tae_app/modules/admin/widgets/custom_navigation_bar_admin.dart';
import 'package:tae_app/modules/admin/widgets/notes_button.dart';
import 'package:tae_app/modules/admin/widgets/search_bar.dart';

class ActivitiesSection extends StatefulWidget {
  // Esto se ocupa para saber que grupo fue seleccionado antes de llegar a la parte de actividades
  final String? groupName; // Parámetro opcional

  const ActivitiesSection({super.key, this.groupName});

  @override
  State<ActivitiesSection> createState() => _ActivitiesSectionState();
}

class _ActivitiesSectionState extends State<ActivitiesSection> {
  // Propósito: Guarda el índice de la pantalla actualmente seleccionada
  int _selectedIndex = 0;

  // Lista de pantallas que cambiarán
  // Aquí defines las pantallas que se mostrarán para cada tab
  List<Widget> get _screens => [
    //HomeScreen(),
    ActivitiesSectionScreen(
      groupName: widget.groupName,
    ), //  Lo pasamos a la pantalla interna), // temporal, cambia según lo que queramos hacer para "recargar" la pagina
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

  // ESTE NO SE MUEVE, ESTE YA AYUDA Y FUNCIONA COMO DEBE DE SER
  @override
  Widget build(BuildContext context) {
    // Scaffold — La base visual de la pantalla
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName ?? 'Actividades',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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

class ActivitiesSectionScreen extends StatefulWidget {
  final String? groupName;


  

  ActivitiesSectionScreen({super.key, this.groupName});

  @override
  State<ActivitiesSectionScreen> createState() =>
      _ActivitiesSectionScreenState();
}

class _ActivitiesSectionScreenState extends State<ActivitiesSectionScreen> {


  Future<void> _showAddActivityDialog(String beltName) async {
  final activityNameController = TextEditingController();
  List<String> exercises = [];

  await showDialog(
    context: context,
    // StatefulBuilder => Te da un setState local, solo para el contenido que está dentro de él.
    builder: (ctx) => StatefulBuilder( // ← ¡Envuelve el AlertDialog en StatefulBuilder! - // ← Paso 1: Envuelve para tener setState local
      builder: (ctx, setState) => AlertDialog(
        // CAMBIA EL COLOR DEL FONDO DE NUESTRA VENTANA EMERGENTE
          backgroundColor: Colors.grey[50], // ← Fondo claro

        title: Text('Agregar actividad a $beltName'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo para nombre de la actividad
              TextField(
                controller: activityNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la actividad',
                  labelStyle: TextStyle(color: Colors.blueGrey), // Color de la etiqueta
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.shade400)), // Color del borde normal
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),// Color cuando está enfocado
                ),
                
              ),
              const SizedBox(height: 16),

              // Lista de ejercicios actuales (se actualiza en tiempo real)
              if (exercises.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ejercicios:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...exercises.map((exercise) => ListTile(
                      title: Text(exercise),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() { // ← Usa el setState de StatefulBuilder
                            exercises.remove(exercise);
                          });
                        },
                      ),
                    )).toList(),
                    const SizedBox(height: 16),
                  ],
                ),

              // Botón para agregar ejercicio --> ES EL MODAL DENTRO DEL MODAL
              ElevatedButton.icon(
                onPressed: () async {
                  final exerciseController = TextEditingController();
                  await showDialog(
                    
                    context: ctx,
                    builder: (innerCtx) => AlertDialog(
                      // CAMBIA EL COLOR DEL FONDO DE NUESTRA VENTANA EMERGENTE
                    backgroundColor: Colors.grey[50], // ← Fondo claro
                      
                      title: const Text('Nuevo ejercicio'),
                      content: TextField(
                        
                        controller: exerciseController,
                        decoration: const InputDecoration(
                          hintText: 'Ej: Patada frontal',
                         labelText: 'Tipo de ejercicio',
                         labelStyle: TextStyle(color: Colors.blueGrey), // Color de la etiqueta
                         //border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.shade400)), // Color del borde normal
                         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),// Color cuando está enfocado            
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(innerCtx),
                           style: TextButton.styleFrom(
                           foregroundColor: const Color.fromARGB(255, 58, 57, 57), // COLOR DEL TEXTO
                           ),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (exerciseController.text.trim().isNotEmpty) {
                              setState(() { // ← ¡Actualiza la lista dentro del modal!
                                exercises.add(exerciseController.text.trim());
                              });
                            }
                            Navigator.pop(innerCtx);
                          },
                          // Color del Botón de agregar --> NUEVA ACTIVIDAD
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                             shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Agregar'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(160, 76, 175, 79), // COLOR DEL FONDO
                  foregroundColor: Colors.white, // COLOR DE LA LETRA 
                  
                ),
                icon: const Icon(Icons.add),
                label: const Text('Agregar ejercicio'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            // Estilo del botón Cancelar
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700], // COLOR DEL TEXTO
            ),
          
            child: const Text('Cancelar',),
          ),
          ElevatedButton(
            onPressed: () {
              if (activityNameController.text.trim().isNotEmpty && exercises.isNotEmpty) {
                _addActivityToBelt(
                  beltName,
                  activityNameController.text.trim(),
                  exercises,
                );
              }
              Navigator.pop(ctx);
            },
            // Estilos de los botón Guardar
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    ),
  );
}




  //  Recibe el nombre
  final List<Map<String, dynamic>> branches = [
    {"name": "Centro Sur", "classes": 4, "participants": 70},
    {"name": "Tlacote", "classes": 5, "participants": 150},
    {"name": "Juriquilla", "classes": 3, "participants": 65},
  ];

  // ✅ Mapa: cada cinta tiene su propia lista de actividades
  /*Map<Clave, Valor>
│
├── Clave: String → "Cintas Blancas", "Cintas Naranjas"... (el título de la sección)
│
└── Valor: List<Map<String, dynamic>> → Lista de actividades, donde cada actividad es un Map:
     │
     └── Map<String, dynamic> → {'name': 'Patadas', 'exercises': ['Front kick', ...]} */
     
  Map<String, List<Map<String, dynamic>>> _beltActivities = {
    'Cintas Blancas': [
      {
        'name': 'Patadas',
        'exercises': ['Front kick', 'Side kick'],
      },
      {
        'name': 'Estiramientos',
        'exercises': ['Piernas', 'Espalda'],
      },
    ],
    'Cintas Naranjas': [
      {
        'name': 'Bloqueos',
        'exercises': ['High block', 'Low block'],
      },
      {
        'name': 'Equilibrio',
        'exercises': ['Postura 1', 'Postura 2'],
      },
    ],
    'Cintas Verdes': [
      {
        'name': 'Combos',
        'exercises': ['Combo 1', 'Combo 2', 'Combo 3'],
      },
    ],
    'Cintas Azules': [
      {
        'name': 'Defensa personal',
        'exercises': ['Agarre 1', 'Agarre 2'],
      },
    ],
  };

  // ✅ Aquí va la lista de grupos (actividades)
  /*
  List<Map<String, dynamic>> _groups = [
    {
      'name': 'Patadas',
      'exercises': ['Front kick', 'Roundhouse'],
    },
    {
      'name': 'Bloqueos',
      'exercises': ['High block', 'Low block'],
    },
  ];
  */

  // ✅ Método para agregar una NUEVA CINTA (no solo una actividad)
  /*
      setState() → Le dice a Flutter: “¡Reconstruye la pantalla, los datos cambiaron!”
      _beltActivities[beltName] = [] → Crea una nueva entrada en el mapa. 
      Si ya existía, la sobreescribe (por eso conviene validar antes).
   */
  void _addBeltSection(String beltName) {
    setState(() {
      _beltActivities[beltName] = []; // Empieza con 0 actividades
    });
  }

  // ✅ Método para agregar actividad ==> ESTO SE DEBE DE CAMBIAR CUANDO
  /*
  void _addActivity() {
    setState(() {
      _groups.add({
        'name': 'Nueva Actividad',
        'exercises': ['Ejercicio 1', 'Ejercicio 2'],
      });
    });
  }
  */

/*
¿Qué hace?
Busca la cinta por beltName.
Si existe (?.), le agrega un nuevo Map con name y exercises.
setState() actualiza la UI.
 */
  void _addActivityToBelt(String beltName, String activityName, List<String> exercises) {
  setState(() {
    _beltActivities[beltName]?.add({
      'name': activityName,
      'exercises': exercises,
    });
  });
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
          child: SingleChildScrollView(
            // ← Agregamos esto para scroll vertical

            // Column — Apilar widgets verticalmente, apila widgets de arriba hacia abaj
            child: Column(
              // Alinea el contenido al inicio horizontal (izquierda).
              crossAxisAlignment: CrossAxisAlignment.start,
              // children (en plural) es una lista de
              // widgets hijos que van uno debajo del otro en una Column.
              // NOTA: No confundir con child (en singular), que solo permite un único widget hijo.
              children: [

                // Llamamos a la barra de busqueda que ya se separa en un widget a parte.
                BarSearch(),

                // Crea un espacio vertical de 10 píxeles entre la caja de búsqueda y el siguiente elemento.
                const SizedBox(height: 20),

                // ==> ESTE YA NO SE MUEVE, ES LA PARTE DE ARRIBA DE LA PAGINA, VER ALUMNOS Y AGREGAR SECCIÓN.
                // Agregar Sección
                // Alinea su hijo al lado derecho (Alignment.centerRight).
                Center(
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.end, // los pone a la derecha
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween, // Separa los 2 grupos a los extremos

                    children: [
                      // Primer botón: Ver alumnos
                      InkWell(
                        onTap: () {
                          print("Ver alumnos clickeado");
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => StudentsSectionScreen(
                                groupName: widget.groupName ?? 'Alumnos',
                              ),
                              ),
                            );
                        },
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // efecto ripple redondeado
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 176, 180, 184),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // borde circular
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Ver alumnos',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.remove_red_eye,
                                size: 18,
                              ), // ícono distinto
                            ],
                          ),
                        ),
                      ),

                      //const SizedBox(width: 10), // separación entre los 2

                      // Segundo botón: Agregar sección
                      InkWell(
                        onTap: () async {
                          //_addActivity,
                          //print("Agregar Sección clickeado");
                          final controller = TextEditingController();
                          
                          await showDialog(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  // Color de fondo para el modal de agregar sección
                                  backgroundColor: Colors.white,
                                  title: Text("Nueva sección de cinta"),
                                  content: TextField(                                    
                                    controller: controller,

                                    decoration: InputDecoration(
                                      hintText: "Ej: Cintas Moradas",
                                      labelStyle: TextStyle(color: Colors.blueGrey),
                                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.shade400)), // Color del borde normal
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),// Color cuando está enfocado
                                    ),
                                  ),
                                  actions: [
                                    // CANCELAR -- AGREGAR SECCIÓN
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        // backgroundColor: Colors.amberAccent,
                                        foregroundColor: const Color.fromARGB(179, 41, 40, 40),
                                      ),
                                      onPressed: () => Navigator.pop(ctx),
                                      child: Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (controller.text.trim().isNotEmpty) {
                                          _addBeltSection(
                                            controller.text.trim(),
                                          );
                                        }
                                        Navigator.pop(ctx);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text("Crear"),
                                    ),
                                  ],
                                ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            //color: const Color.fromARGB(133, 219, 221, 221), // fondo de color
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Agregar Sección',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color.fromARGB(
                                    255,
                                    0,
                                    0,
                                    0,
                                  ), // contraste con fondo verde
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.add_circle_outline,
                                color: Color.fromARGB(255, 0, 0, 0),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ES DONDE SE ARMAN LAS TARJETAS, ES UNA FUNCIÓN A PARTE EN ESTE MISMO ARCHIVO
                // Por esto:
                ..._beltActivities.entries
                    .map(
                      (entry) => ActivitiesCard(
                       groups: entry.value,
                       groupTitle: entry.key,
                       onAddActivity: () => _showAddActivityDialog(entry.key), // ← Llama a una función nueva
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ),

      // Botón flotante
      /*
      Un botón flotante (Floating Action Button o FAB) es 
      un botón circular y elevado que aparece sobre 
      la interfaz, normalmente en la esquina inferior derecha.
       */
      floatingActionButton: NotesButton(),
    );
  }
}
