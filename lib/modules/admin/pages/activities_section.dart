import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tae_app/modules/admin/pages/profile_screen.dart';
import 'package:tae_app/modules/admin/pages/students_section.dart';
import 'package:tae_app/modules/admin/pages/wallet_screen.dart';
import 'package:tae_app/modules/admin/widgets/activities_card.dart';
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
      // ✅ DISEÑO RESTAURADO: Se agrega el FloatingActionButton
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
  String _searchQuery = ''; 

  // ----------------------------------------------------
  // LÓGICA DE AGREGAR/GUARDAR (Persistente) - MANTENIDA
  // ----------------------------------------------------
  void _addActivityToBelt(String beltName, String activityName, List<String> exercises) async {
    final String? groupId = widget.groupName;
    if (groupId == null || groupId.isEmpty) return;

    try {
      final activityData = {
        'nombre_actividad': activityName,
        'ejercicios': exercises,
        'cinta_seccion': beltName,
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

  void _addBeltSection(String newBeltName) async {
    final String? groupId = widget.groupName;
    if (groupId == null || groupId.isEmpty) return;

    try {
      final sectionData = {
        'nombre_cinta': newBeltName,
        'fecha_creacion': FieldValue.serverTimestamp(),
      };

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
  // BORRAR/EDITAR ACTIVIDAD - MANTENIDA
  // ----------------------------------------------------
  void _deleteActivity(String activityId) async {
    final String? groupId = widget.groupName;
    if (groupId == null || groupId.isEmpty) return;

    try {
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

  void _updateActivityName(String activityId, String newName) async {
    final String? groupId = widget.groupName;
    if (groupId == null || groupId.isEmpty) return;

    try {
      await _db
          .collection('grupos').doc(groupId)
          .collection('actividades').doc(activityId)
          .update({'nombre_actividad': newName});

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
  // Lógica de Filtrado - MANTENIDA
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

  // ----------------------------------------------------
  // DIÁLOGO PARA AGREGAR ACTIVIDAD - DISEÑO RESTAURADO
  // ----------------------------------------------------
  Future<void> _showAddActivityDialog(String beltName) async {
    final activityNameController = TextEditingController();
    List<String> exercises = [];

      await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        // ✅ DISEÑO RESTAURADO
        backgroundColor: Colors.grey[50], 
        title: Text('Agregar actividad a $beltName'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo: Nombre de la Actividad
              TextField(
                controller: activityNameController, 
                decoration: InputDecoration(
                  labelText: 'Nombre de la actividad',
                  // ✅ DISEÑO RESTAURADO
                  labelStyle: const TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.shade400)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
                )
              ),
              const SizedBox(height: 16),

              // Lista de ejercicios actuales
              ...exercises.map((exercise) => ListTile(
                title: Text(exercise),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() { exercises.remove(exercise); });
                  },
                ),
              )).toList(),

              // Botón para agregar ejercicio (abre un modal secundario)
              ElevatedButton.icon(
                // ✅ DISEÑO RESTAURADO
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(160, 76, 175, 79), 
                  foregroundColor: Colors.white, 
                ),
                onPressed: () async {
                  final exerciseController = TextEditingController();
                  final result = await showDialog( // Modal secundario
                    context: ctx,
                    builder: (innerCtx) => AlertDialog(
                      // ✅ DISEÑO RESTAURADO
                      backgroundColor: Colors.grey[50], 
                      title: const Text('Nuevo ejercicio'),
                      content: TextField(
                        controller: exerciseController, 
                        decoration: InputDecoration(
                           hintText: 'Ej: Patada frontal',
                           labelText: 'Tipo de ejercicio',
                           labelStyle: const TextStyle(color: Colors.blueGrey),
                           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(innerCtx), 
                          // ✅ DISEÑO RESTAURADO
                          style: TextButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 58, 57, 57),
                          ),
                          child: const Text('Cancelar')
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final name = exerciseController.text.trim();
                            Navigator.pop(innerCtx, name);
                          },
                          // ✅ DISEÑO RESTAURADO
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
                  
                  if (result != null && result.isNotEmpty) {
                    setState(() { exercises.add(result); });
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar ejercicio'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            // ✅ DISEÑO RESTAURADO
            style: TextButton.styleFrom(
             foregroundColor: Colors.grey[700],
            ),
            child: const Text('Cancelar')
          ),
          ElevatedButton(
            onPressed: () {
              if (activityNameController.text.trim().isNotEmpty && exercises.isNotEmpty) {
                // LLAMADA A LA FUNCIÓN DE GUARDADO PERSISTENTE EN FIREBASE - MANTENIDA
                _addActivityToBelt(beltName, activityNameController.text.trim(), exercises);
              }
              Navigator.pop(ctx);
            },
            // ✅ DISEÑO RESTAURADO
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

  // ---------------------------------------------------------
  // MÉTODOS DE BUILD Y VISUALIZACIÓN DINÁMICA - UI RESTAURADA
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final String? groupId = widget.groupName;
    if (groupId == null || groupId.isEmpty) {
        return const Center(child: Text("Error: El grupo no fue seleccionado correctamente."));
    }

    // El cuerpo del Scaffold tiene un fondo blanco (del código viejo)
    return Container(
      color: Colors.white,
      child: SafeArea(
        // 1. Escuchamos las SECCIONES DE CINTA que actúan como marcadores
        child: StreamBuilder<QuerySnapshot>(
          stream: _db.collection('grupos').doc(groupId).collection('secciones_cinta').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // 2. Obtenemos la lista de nombres de cintas
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
                          // Botón: Ver alumnos
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentsSectionScreen(groupName: widget.groupName ?? 'Alumnos')));
                            },
                            // ✅ DISEÑO RESTAURADO: Usando Container con borde
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
                                  borderRadius: BorderRadius.circular(20),
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
                                    ),
                                  ],
                                ),
                              ),
                          ),

                          // Botón: Agregar Sección
                          InkWell(
                            onTap: () async {
                               final controller = TextEditingController();
                               await showDialog(
                                 context: context,
                                 builder: (ctx) => AlertDialog(
                                   // ✅ DISEÑO RESTAURADO
                                   backgroundColor: Colors.white,
                                   title: const Text("Nueva sección de cinta"),
                                   content: TextField(
                                     controller: controller, 
                                     decoration: InputDecoration(
                                       hintText: "Ej: Cintas Moradas",
                                       // ✅ DISEÑO RESTAURADO
                                       labelStyle: const TextStyle(color: Colors.blueGrey),
                                       border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.shade400)),
                                       focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),
                                     )
                                   ),
                                   actions: [
                                     TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      // ✅ DISEÑO RESTAURADO
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: const Color.fromARGB(179, 41, 40, 40),
                                      ),
                                      child: const Text("Cancelar")
                                    ),
                                     TextButton(
                                       onPressed: () {
                                         if (controller.text.trim().isNotEmpty) {
                                           _addBeltSection(controller.text.trim()); // GUARDAR EN FIREBASE - MANTENIDA
                                         }
                                         Navigator.pop(ctx);
                                       },
                                       // ✅ DISEÑO RESTAURADO
                                       style: ElevatedButton.styleFrom(
                                         backgroundColor: Colors.blueAccent,
                                         foregroundColor: Colors.white,
                                         shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                         ),
                                       ),
                                       child: const Text("Crear"),
                                     ),
                                   ],
                                 ),
                               );
                            },
                            // ✅ DISEÑO RESTAURADO: InkWell para el botón de Agregar Sección
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
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
                                      color: Color.fromARGB(255, 0, 0, 0),
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

                    // 4. Listar las Tarjetas de Actividades (Stream Anidado) - MANTENIDO
                    ...beltNames.map((beltName) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: _db.collection('grupos').doc(groupId).collection('actividades')
                            .where('cinta_seccion', isEqualTo: beltName)
                            .snapshots(),
                        
                        builder: (context, activitySnapshot) {
                          if (activitySnapshot.connectionState == ConnectionState.waiting) {
                            return const LinearProgressIndicator();
                          }
                          
                          final List<Map<String, dynamic>> activitiesList =
                              activitySnapshot.data?.docs.map((doc) => {
                                'id': doc.id,
                                'name': doc['nombre_actividad'] ?? 'Actividad sin nombre',
                                'exercises': doc['ejercicios'] ?? [],
                              }).toList() ?? [];

                          return ActivitiesCard(
                            group: activitiesList,
                            groupTitle: beltName,
                            groupId: groupId,
                            onAddActivity: () => _showAddActivityDialog(beltName),
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
                    
                    if (beltNames.isEmpty)
                      const Center(child: Text('¡Empieza agregando la primera sección de cinta!')),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}