import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tae_app/modules/admin/pages/activities_section.dart';
import 'package:tae_app/modules/admin/widgets/custom_navigation_bar_admin.dart';
import 'package:tae_app/modules/admin/widgets/notes_button.dart';
import 'package:tae_app/modules/admin/widgets/search_bar.dart';
import 'wallet_screen.dart';
import 'profile_screen.dart';
import 'package:tae_app/modules/admin/widgets/add_group_dialog.dart';

class BranchGroupsScreen extends StatefulWidget {
  final String branchName;
  
  const BranchGroupsScreen({Key? key, required this.branchName}) : super(key: key);

  @override
  State<BranchGroupsScreen> createState() => _BranchGroupsScreenState();
}

class _BranchGroupsScreenState extends State<BranchGroupsScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  late Stream<QuerySnapshot> _groupsStream;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Inicializamos el Stream para escuchar la colección 'grupos'
    _groupsStream = _db
        .collection('grupos')
        .where('id_sucursal', isEqualTo: widget.branchName)
        .snapshots();
  }

  // =================================================================
  // === AGREGAR GRUPO ===
  // =================================================================
  void _openAddGroupDialog(BuildContext context) async {
    final newGroupData = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddGroupDialog(onSave: (_) {}),
    );

    if (newGroupData == null) return;

    try {
      final groupToSave = {
        'nombre_grupo': newGroupData['name'],
        'tipo_cinta': newGroupData['beltType'],
        'horario': newGroupData['schedule'],
        'id_sucursal': widget.branchName,
        'total_alumnos': 0,
        'fecha_creacion': FieldValue.serverTimestamp(),
      };

      await _db.collection('grupos').add(groupToSave);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Grupo ${newGroupData['name']} creado con éxito.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print("Error al guardar grupo en Firebase: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al crear grupo. Revisa conexión y permisos.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // =================================================================
  // === VISTA DE GRUPOS (DINÁMICA) ===
  // =================================================================
  Widget _buildGroupsContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BarSearch(
                hintText: 'Buscar grupo, cinta o horario',
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Botón Agregar Grupo
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openAddGroupDialog(context),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Agregar Grupo  ',
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

              // === StreamBuilder: Escucha cambios en 'grupos' ===

              // === StreamBuilder mejorado con filtro local ===
              StreamBuilder<QuerySnapshot>(
              stream: _groupsStream,
              builder: (context, snapshot) {
                try {
                  if (snapshot.hasError) {
                    return const Text('¡Oh no! Tuvimos un error al cargar los grupos.');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    // 1. Extraer todos los grupos desde Firebase
                    final allGroups = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>? ?? {};
                      return {
                        'name': data['nombre_grupo'] ?? 'Sin Nombre',
                        'beltType': data['tipo_cinta'] ?? 'N/A',
                        'schedule': data['horario'] ?? 'Sin horario',
                        'alumns': '${data['total_alumnos'] ?? 0} participantes',
                      };
                    }).toList();

                    // 2. Filtrar localmente según _searchQuery
                    List<Map<String, dynamic>> filteredGroups = allGroups;
                    if (_searchQuery.isNotEmpty) {
                      final query = _searchQuery.toLowerCase();
                      filteredGroups = allGroups.where((group) {
                        final name = (group['name'] as String).toLowerCase();
                        final belt = (group['beltType'] as String).toLowerCase();
                        final schedule = (group['schedule'] as String).toLowerCase();
                        return name.contains(query) || belt.contains(query) || schedule.contains(query);
                      }).toList();
                    }

                    // 3. Mostrar resultados
                    if (filteredGroups.isEmpty) {
                      return const Center(child: Text('No se encontraron grupos.'));
                    }

                    return Column(
                      children: filteredGroups.map((group) => _buildGroupCard(group)).toList(),
                    );
                  }

                  return Center(
                    child: Text('Aún no hay grupos para ${widget.branchName}. ¡Agrega uno!'),
                  );
                } catch (e, stack) {
                  print("⚠️ Error en StreamBuilder: $e\n$stack");
                  return const Text('Error al renderizar grupos.');
                }
              },
            ),
            
            ],
          ),
        ),
      ),
    );
  }

  // =================================================================
  // === TARJETA DE GRUPO ===
  // =================================================================
  Widget _buildGroupCard(Map<String, dynamic> group) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxCardWidth =
            constraints.maxWidth > 800 ? 600 : constraints.maxWidth * 0.95;

        return Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivitiesSection(
                    groupName: group['name'],
                  ),
                ),
              );
            },
            child: Container(
              width: maxCardWidth,
              margin: const EdgeInsets.only(bottom: 26),
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          group['name'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tipo de cinta(s): ${group["beltType"]}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'Horario: ${group["schedule"]}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          'Alumnos: ${group["alumns"]}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.group_outlined,
                    size: 50,
                    color: Color.fromARGB(255, 57, 56, 56),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =================================================================
  // === OBTENER PANTALLA ACTUAL ===
  // =================================================================
  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildGroupsContent();
      case 1:
        return WalletScreen();
      case 2:
        return ProfileScreen(
          fullName: 'Josepe',
          email: 'Josepe13186',
          phone: '34234234',
          role: 'Administrador',
          imageUrl: '',
        );
      default:
        return _buildGroupsContent();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Grupos en ${widget.branchName}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _getCurrentScreen(),
      floatingActionButton: const NotesButton(),
      bottomNavigationBar: CustomNavigationBarAdmin(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}