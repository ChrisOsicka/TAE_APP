import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importación de Firebase
import 'package:tae_app/modules/admin/pages/activities_section.dart';
import 'package:tae_app/modules/admin/widgets/add_group_dialog.dart';
import 'package:tae_app/modules/admin/widgets/custom_navigation_bar_admin.dart';
import 'package:tae_app/modules/admin/widgets/notes_button.dart';
import 'package:tae_app/modules/admin/widgets/search_bar.dart';
import 'wallet_screen.dart';
import 'profile_screen.dart';

class BranchGroupsScreen extends StatefulWidget {
  final String branchName;
  
  const BranchGroupsScreen({Key? key, required this.branchName}) : super(key: key);

  @override
  State<BranchGroupsScreen> createState() => _BranchGroupsScreenState();
}

class _BranchGroupsScreenState extends State<BranchGroupsScreen> {
  // Referencia a Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  int _selectedIndex = 0;
  
  // Stream que escucha los grupos de esta sucursal en Firebase
  Stream<QuerySnapshot>? _groupsStream;

  // Lista de pantallas/pestañas
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    
    // 1. Inicializamos el Stream para escuchar la colección 'grupos'
    _groupsStream = _db
        .collection('grupos')
        // Filtramos solo por la sucursal actual (branchName)
        .where('id_sucursal', isEqualTo: widget.branchName) 
        .snapshots(); 
        
    _screens = [
      _buildGroupsContent(), // Pantalla de grupos (ahora dinámica)
      WalletScreen(), 
      ProfileScreen(fullName: 'Josepe', email: 'Josepe13186', phone: '34234234', role: 'Administrador', imageUrl: '',), 
    ];
  }
  
  // =================================================================
  // === LÓGICA DE FIREBASE: AGREGAR GRUPO ===
  // =================================================================
  void _openAddGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddGroupDialog(
        onSave: (newGroupData) async { // Hacemos la función async
          
          Navigator.of(context).pop(); // Cerramos el diálogo primero

          try {
            // Creamos el objeto exactamente como debe ir a Firestore, 
            // incluyendo los campos 'tipo_cinta', 'horario' y 'id_sucursal'.
            final groupToSave = {
              'nombre_grupo': newGroupData['name'],
              'tipo_cinta': newGroupData['beltType'], 
              'horario': newGroupData['schedule'],   
              'id_sucursal': widget.branchName, // Vinculado a la sucursal actual
              'total_alumnos': 0, // Inicia en 0
              'fecha_creacion': FieldValue.serverTimestamp(), 
            };

            // Guardar en Firestore. El StreamBuilder se encargará de refrescar la UI.
            await _db.collection('grupos').add(groupToSave);
            
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Grupo ${newGroupData['name']} creado con éxito.')),
            );

          } catch (e) {
            print("Error al guardar grupo en Firebase: $e");
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al crear grupo. Revisa conexión y permisos.')),
            );
          }
        },
      ),
    );
  }

  // =================================================================
  // === VISTA DE GRUPOS (DINÁMICA) ===
  // =================================================================
  Widget _buildGroupsContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BarSearch(),
            const SizedBox(height: 10),

            // Botón Agregar Grupo (deja esto igual)
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
                        Text('Agregar Grupo  '),
                        SizedBox(width: 5),
                        Icon(Icons.add_circle_outline),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // === StreamBuilder: Escucha cambios en 'grupos' y actualiza la UI ===
            StreamBuilder<QuerySnapshot>(
              stream: _groupsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('¡Oh no! Tuvimos un error al cargar los grupos.');
                }
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // Si la conexión está activa y hay datos:
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  
                  return Column(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      
                      // Mapeamos los datos de Firestore a un formato que _buildGroupCard entienda
                      final groupData = {
                        'name': data['nombre_grupo'] ?? 'Sin Nombre',
                        'beltType': data['tipo_cinta'] ?? 'N/A',
                        'schedule': data['horario'] ?? 'Sin horario',
                        // El campo 'alumns' se genera aquí para la Card
                        'alumns': (data['total_alumnos']?.toString() ?? 'x') + ' participantes', 
                      };
                      
                      return _buildGroupCard(groupData);
                    }).toList(),
                  );
                }
                
                // Si no hay grupos en Firebase (y ya quitamos los estáticos)
                return Center(
                  child: Text('Aún no hay grupos para ${widget.branchName}. ¡Agrega uno en Firebase o en el botón "Agregar Grupo"!'),
                );
              },
            ),
            // =========================================================

          ],
        ),
      ),
    );
  }

  // El resto de tus métodos (que usan la lista 'group'):

  Widget _buildGroupCard(Map<String, dynamic> group) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxCardWidth = constraints.maxWidth > 800 ? 600 : constraints.maxWidth * 0.95;
        
        return Center(
          child: InkWell(
            onTap: () { // 👇 Aquí navegas a la nueva pantalla
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivitiesSection(
                  groupName: group['name'], // 👈 Pasas el nombre aquí
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
                  Expanded(
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  // El resto de tus métodos de navegación permanecen iguales...
  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildGroupsContent(); 
      case 1:
        return WalletScreen();
      case 2:
        return ProfileScreen(fullName: 'Josepe', email: 'Josepe13186', phone: '34234234', role: 'Administrador', imageUrl: '',);
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
        title: Text('Grupos en ${widget.branchName}',style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black, 
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _getCurrentScreen(),
      
      floatingActionButton: const NotesButton(), // Asegúrate de que NotesButton sea const si no usa variables de estado
      
      bottomNavigationBar: CustomNavigationBarAdmin(
        currentIndex: _selectedIndex, 
        onTap: _onItemTapped,
      ),
    );
  }
}