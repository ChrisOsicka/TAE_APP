import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Widgets personalizados
import 'package:tae_app/modules/admin/widgets/adaptive_branch_list.dart';
import 'package:tae_app/modules/admin/widgets/add_dialog.dart';
import 'package:tae_app/modules/admin/widgets/custom_navigation_bar_admin.dart';
import 'package:tae_app/modules/admin/widgets/notes_button.dart';
import 'package:tae_app/modules/admin/widgets/search_bar.dart';

// Pantallas
import 'group_selection.dart';
import 'wallet_screen.dart';
import 'profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TaeApp());
}

class TaeApp extends StatelessWidget {
  const TaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainBranches(),
    );
  }
}

class MainBranches extends StatefulWidget {
  const MainBranches({super.key});

  @override
  State<MainBranches> createState() => _MainBranchesState();
}

class _MainBranchesState extends State<MainBranches> {
  int _selectedIndex = 0;

  // Lista de pantallas para la navegación inferior
  final List<Widget> _screens = [
    BranchesScreen(),
    WalletScreen(),
    ProfileScreen(
      fullName: 'Josepe',
      email: 'Josepe13186',
      phone: '34234234',
      role: 'Administrador',
      imageUrl: '',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomNavigationBarAdmin(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final Stream<QuerySnapshot> _branchesStream;

    String _searchQuery = ''; // ← Nueva variable


  @override
  void initState() {
    super.initState();
    _branchesStream = _db.collection('sucursales').orderBy('name').snapshots();
  }



  void _openAddBranchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddDialog(
        onSave: (newBranchData) async {
          final String branchName = newBranchData['name'];
          
          try {
            // Guardamos en Firebase
            await _db.collection('sucursales').add({
              'name': branchName,
              'classes': newBranchData['classes'] ?? 0,
              'participants': newBranchData['participants'] ?? 0,
              'fecha_creacion': FieldValue.serverTimestamp(),
            });

            print("✅ Sucursal guardada: $branchName");

            // Cerramos el diálogo DESPUÉS de guardar
            if (!context.mounted) return;
            Navigator.of(context).pop();

            // Mostramos SnackBar DESPUÉS de cerrar el diálogo
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sucursal "$branchName" creada exitosamente'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // Esperamos un momento
            await Future.delayed(const Duration(milliseconds: 400));

            // Navegamos a la pantalla de grupos
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BranchGroupsScreen(
                  branchName: branchName,
                ),
              ),
            );
            
          } catch (e) {
            print("❌ Error al guardar sucursal: $e");
            
            // Cerramos el diálogo primero
            if (context.mounted) {
              Navigator.of(context).pop();
            }
            
            // Mostramos error DESPUÉS de cerrar
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al crear la sucursal: ${e.toString()}'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          }
        },
      ),
    );
  }


  
  // Función para filtrar por nombre
  List<Map<String, dynamic>> _filtrarSucursales(
    List<Map<String, dynamic>> sucursales,
    String query,
  ) {
    if (query.isEmpty) return sucursales;
    return sucursales.where((sucursal) {
      final nombre = (sucursal['name'] as String?)?.toLowerCase() ?? '';
      return nombre.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Barra de búsqueda
              // ✅ BarSearch con funcionalidad
              BarSearch(
                hintText: 'Buscar sucursal',
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
              const SizedBox(height: 10),

              // 🔹 Botón "Agregar Sucursal"
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openAddBranchDialog(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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

              // 🔹 StreamBuilder para listar sucursales
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _branchesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print("Error en StreamBuilder: ${snapshot.error}");
                      return const Center(
                          child: Text('Error al cargar las sucursales.'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('No hay sucursales registradas.'));
                    }

                    final branchesFromFirebase =
                        snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return {
                        'name': data['name'] ?? 'Sin nombre',
                        'classes': (data['classes'] as num?)?.toInt() ?? 0,
                        'participants':
                            (data['participants'] as num?)?.toInt() ?? 0,
                      };
                    }).toList();

                     // ✅ Filtrar según la búsqueda
                      final branchesFiltradas = _filtrarSucursales(
                        branchesFromFirebase,
                        _searchQuery,
                      );

                       if (branchesFiltradas.isEmpty) {
                        return const Center(child: Text('No hay resultados.'));
                      }


                    return AdaptiveBranchList(
                      // branches: branchesFromFirebase, //  ERROR: no es branchesFiltradas
                      branches: branchesFiltradas,

                      icon: Icons.location_on_outlined,
                      onTap: (branchName) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BranchGroupsScreen(
                              branchName: branchName.toString(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: NotesButton(),
    );
  }
}