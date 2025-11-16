import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tae_app/modules/admin/pages/profile_screen.dart';
import 'package:tae_app/modules/admin/pages/students_section.dart';
import 'package:tae_app/modules/admin/pages/wallet_screen.dart';
import 'package:tae_app/modules/admin/widgets/activities_card.dart'; // Asumimos que este widget existe
import 'package:tae_app/modules/admin/widgets/custom_navigation_bar_admin.dart';
import 'package:tae_app/modules/admin/widgets/notes_button.dart';
import 'package:tae_app/modules/admin/widgets/search_bar.dart';

// =========================================================
// === ACTIVITIES SECTION (Contenedor Principal de Tabs) ===
// =========================================================
class ActivitiesSection extends StatefulWidget {
  final String? groupName; 

  const ActivitiesSection({super.key, this.groupName});

  @override
  State<ActivitiesSection> createState() => _ActivitiesSectionState();
}

class _ActivitiesSectionState extends State<ActivitiesSection> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    ActivitiesSectionScreen(
      groupName: widget.groupName,
    ),
    const WalletScreen(), 
    ProfileScreen(
      fullName: 'Josepe', 
      email: 'Josepe13186', 
      phone: '34234234', 
      role: 'Administrador', 
      imageUrl: '',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName ?? 'Actividades',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomNavigationBarAdmin(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: const NotesButton(),
    );
  }
}

// ====================================================================
// === ACTIVITIES SECTION SCREEN (Lógica de Datos y UI) =============
// ====================================================================

class ActivitiesSectionScreen extends StatefulWidget {
  final String? groupName;

  const ActivitiesSectionScreen({super.key, this.groupName});

  @override
  State<ActivitiesSectionScreen> createState() => _ActivitiesSectionScreenState();
}

class _ActivitiesSectionScreenState extends State<ActivitiesSectionScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String _searchQuery = ''; // Estado para la barra de búsqueda

  // ----------------------------------------------------
  // LÓGICA DE AGREGAR/GUARDAR (Persistente)
  // ----------------------------------------------------
  
  // 1. Guardar la actividad y sus ejercicios en Firestore
  void _addActivityToBelt(String beltName, String activityName, List<String> exercises) async {
    final String? groupId = widget.groupName; 
    if (groupId == null || groupId.isEmpty) return;

    try {
      final activityData = {
        'nombre_actividad': activityName,
        'ejercicios': exercises, 
        'cinta_seccion': beltName, // El nombre de la sección de cinta (Clave de agrupación)
        'fecha_creacion': FieldValue.serverTimestamp(),
      };

      await _db
          .collection('grupos').doc(groupId)
          .collection('actividades').add(activityData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Actividad "$activityName" guardada con éxito.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al guardar actividad. Revise permisos.')),
        );
      }
    }
  }

  // 2. Guardar la Sección/Cinta Marcadora en Firestore
  void _addBeltSection(String newBeltName) async {
    final String? groupId = widget.groupName;
    if (groupId == null || groupId.isEmpty) return;

    try {
      final sectionData = {
        'nombre_cinta': newBeltName,
        'fecha_creacion': FieldValue.serverTimestamp(),
      };

      // 🚨 Guardar el marcador: /grupos/{groupId}/secciones_cinta/{newBeltName}
      await _db
          .collection('grupos').doc(groupId)
          .collection('secciones_cinta').doc(newBeltName).set(sectionData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sección "$newBeltName" creada.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al crear sección en Firebase.')),
        );
      }
    }
  }

   // ----------------------------------------------------
  // BORRAR ACTIVIDAD
  // ----------------------------------------------------
  void _deleteActivity(String activityId) async {
  final String? groupId = widget.groupName;
  if (groupId == null || groupId.isEmpty) return;

  try {
    // 1. Eliminar el documento de la subcolección /actividades
    await _db
        .collection('grupos').doc(groupId)
        .collection('actividades').doc(activityId).delete();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Actividad eliminada con éxito.')),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la actividad.')),
      );
    }
  }
}

// ----------------------------------------------------
  // EDITAR ACTIVIDAD
  // ----------------------------------------------------

void _updateActivityName(String activityId, String newName) async {
  final String? groupId = widget.groupName;
  if (groupId == null || groupId.isEmpty) return;

  try {
    // 1. Ejecutar la actualización en el documento específico
    await _db
        .collection('grupos').doc(groupId)
        .collection('actividades').doc(activityId)
        .update({'nombre_actividad': newName}); // Actualizamos solo el campo 'nombre_actividad'

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Nombre de actividad actualizado en Firebase.')),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar nombre.')),
      );
    }
  }
}
  // ----------------------------------------------------
  // Lógica de Filtrado (Adaptada para datos de Firebase)
  // ----------------------------------------------------
  List<MapEntry<String, List<Map<String, dynamic>>>> _filtrarActividades(
      Map<String, List<Map<String, dynamic>>> actividades, String query) {
    if (query.isEmpty) {
      return actividades.entries.toList();
    }
    final queryLower = query.toLowerCase();
    return actividades.entries.where((entry) {
      final cintaMatch = entry.key.toLowerCase().contains(queryLower);
      final actividadesMatch = entry.value.any((actividad) =>
          actividad['name'].toString().toLowerCase().contains(queryLower) ||
          (actividad['exercises'] is List && (actividad['exercises'] as List).any((e) => e.toString().toLowerCase().contains(queryLower))));
      return cintaMatch || actividadesMatch;
    }).toList();
  }

  // Diálogo para agregar actividad (se mantiene como la definiste)
  Future<void> _showAddActivityDialog(String beltName) async {
    final activityNameController = TextEditingController();
    List<String> exercises = []; 

      await showDialog(
    context: context,
    // Usamos StatefulBuilder para actualizar la lista de ejercicios dentro del modal
    builder: (ctx) => StatefulBuilder( 
      builder: (ctx, setState) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Agregar actividad a $beltName'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo: Nombre de la Actividad
              TextField(controller: activityNameController, decoration: const InputDecoration(labelText: 'Nombre de la actividad')),
              const SizedBox(height: 16),
              
              // Lista de ejercicios actuales
              ...exercises.map((exercise) => ListTile(
                title: Text(exercise),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() { exercises.remove(exercise); }); // Usa el setState local
                  },
                ),
              )).toList(),

              // Botón para agregar ejercicio (abre un modal secundario)
              ElevatedButton.icon(
                onPressed: () async {
                  final exerciseController = TextEditingController();
                  final result = await showDialog( // Modal secundario
                    context: ctx,
                    builder: (innerCtx) => AlertDialog(
                      title: const Text('Nuevo ejercicio'),
                      content: TextField(controller: exerciseController, decoration: const InputDecoration(hintText: 'Ej: Patada frontal')),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(innerCtx), child: const Text('Cancelar')),
                        TextButton(
                          onPressed: () {
                            final name = exerciseController.text.trim();
                            Navigator.pop(innerCtx, name); // Devuelve el nombre
                          },
                          child: const Text('Agregar'),
                        ),
                      ],
                    ),
                  );
                  
                  if (result != null && result.isNotEmpty) {
                    setState(() { exercises.add(result); }); // Actualiza la lista en el modal principal
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar ejercicio'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (activityNameController.text.trim().isNotEmpty && exercises.isNotEmpty) {
                // 🚨 LLAMADA A LA FUNCIÓN DE GUARDADO PERSISTENTE EN FIREBASE
                _addActivityToBelt(beltName, activityNameController.text.trim(), exercises);
              }
              Navigator.pop(ctx); // Cierra el modal principal
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    ),
  );
  }

  // ---------------------------------------------------------
  // MÉTODOS DE BUILD Y VISUALIZACIÓN DINÁMICA
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final String? groupId = widget.groupName;
    if (groupId == null || groupId.isEmpty) {
        return const Center(child: Text("Error: El grupo no fue seleccionado correctamente."));
    }

    // 1. Escuchamos las SECCIONES DE CINTA que actúan como marcadores
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('grupos').doc(groupId).collection('secciones_cinta').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // 2. Si la conexión es exitosa, obtenemos la lista de nombres de cintas
        final List<String> beltNames = snapshot.data?.docs.map((doc) => doc.id).toList() ?? [];

        // 3. El resto del contenido (Search Bar, Botones, y la lista de actividades)
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra de Búsqueda
                BarSearch(
                    hintText: 'Buscar actividad o cinta',
                    onSearch: (query) {
                      setState(() { _searchQuery = query; });
                    },
                ),
                const SizedBox(height: 20),

                // Botones "Ver alumnos" y "Agregar Sección"
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón: Ver alumnos (código completo)
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StudentsSectionScreen(groupName: widget.groupName ?? 'Alumnos')));
                        },
                        child: const Text('Ver alumnos'), 
                      ),

                      // Botón: Agregar Sección (CONEXIÓN CON FIREBASE)
                      InkWell(
                        onTap: () async {
                           final controller = TextEditingController();
                           await showDialog(
                             context: context,
                             builder: (ctx) => AlertDialog(
                               title: const Text("Nueva sección de cinta"),
                               content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Ej: Cintas Moradas")),
                               actions: [
                                 TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
                                 TextButton(
                                   onPressed: () {
                                     if (controller.text.trim().isNotEmpty) {
                                       _addBeltSection(controller.text.trim()); // GUARDAR EN FIREBASE
                                     }
                                     Navigator.pop(ctx);
                                   },
                                   child: const Text("Crear"),
                                 ),
                               ],
                             ),
                           );
                        },
                        child: const Text('Agregar Sección'), 
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 4. Listar las Tarjetas de Actividades (Por cada Cinta Marcadora)
                ...beltNames.map((beltName) {
                  // === STREAM ANIDADO: BUSCAR LAS ACTIVIDADES PARA ESTA CINTA ===
                  return StreamBuilder<QuerySnapshot>(
                    stream: _db.collection('grupos').doc(groupId).collection('actividades')
                        .where('cinta_seccion', isEqualTo: beltName) // Filtro crucial
                        .snapshots(),
                    
                    builder: (context, activitySnapshot) {
                      if (activitySnapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator(); 
                      }
                      
                      // 5. Mapear las actividades encontradas
                      final List<Map<String, dynamic>> activitiesList = 
                          activitySnapshot.data?.docs.map((doc) => {
                            'id': doc.id,
                            'name': doc['nombre_actividad'] ?? 'Actividad sin nombre',
                            'exercises': doc['ejercicios'] ?? [],
                          }).toList() ?? [];

                      // Si la cinta existe (marcador), siempre devolvemos la ActivitiesCard
                      return ActivitiesCard(
                        group: activitiesList, // Lista de actividades filtradas (puede ser vacía)
                        groupTitle: beltName, // Título: "Cintas Blancas"
                        onAddActivity: () => _showAddActivityDialog(beltName), 
                        // Los callbacks de edición/eliminación deben actualizar Firebase
                        // 🚨 CONEXIÓN FALTANTE PARA EDITAR:
                        onNameChanged: (activityId, newName) {
                        _updateActivityName(activityId, newName);
                        },
                        onDelete: (activityId) {
                          _deleteActivity(activityId);
                      },
                      );
                    },
                  );
                }).toList(),
                
                // Si no hay secciones de cintas creadas
                if (beltNames.isEmpty)
                  const Center(child: Text('¡Empieza agregando la primera sección de cinta!')),
              ],
            ),
          ),
        );
      },
    );
  }
}