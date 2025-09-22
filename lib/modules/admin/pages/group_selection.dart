import 'package:flutter/material.dart';
import 'package:tae_app/modules/admin/pages/activities_section.dart';
import 'package:tae_app/modules/admin/widgets/adaptive_branch_list.dart';
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
  int _selectedIndex = 0;
  
  // Datos de ejemplo para grupos
  final List<Map<String, dynamic>> groups = [
    {"name": "Otras Cintas", "beltType": "Blanca, Amarilla...", "schedule": "Lunes y Miércoles 6:00-8:00 Pm","alumns": "x participantes"},
    {"name": "Cintas negras", "beltType": "Negra", "schedule": "Martes y Jueves 7:00-8:00 Pm","alumns": "x participantes"},
    {"name": "Infantiles", "beltType": "Blanca, Amarilla...", "schedule": "Sábados 10:00-12:00 Am","alumns": "x participantes"},
    {"name": "Otros Grupos", "beltType": "-", "schedule": "Viernes 4:00-6:00 Pm","alumns": "x participantes"},
  ];

  // Lista de pantallas/pestañas
  late final List<Widget> _screens;
  /*
  _selectedIndex controla la pestaña activa.
  _screens contiene todas las pantallas posibles.
  initState() inicializa la lista de pantallas.
*/
  @override
  void initState() {
    super.initState();
    _screens = [
      _buildGroupsContent(), // Tu pantalla de grupos actual
      WalletScreen(),        // Pantalla de cartera
      ProfileScreen(),       // Pantalla de perfil
    ];
  }

  Widget _buildGroupsContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Barra de búsqueda
            BarSearch(),



            const SizedBox(height: 10),

            // Botón Agregar Grupo
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => print("Agregar Grupo"),
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

            // Lista de grupos
            ...groups.map((group) => _buildGroupCard(group)).toList(),

          ],
        ),
      ),
    );
  }

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
              height: 170,
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //  Acceso Correcto a Parámetros
      /*
       Al convertir GroupsScreen en un método 
       (_buildGroupsContent()), hereda automáticamente
       el contexto y puede acceder a 
       widget.branchName. 
       */
      appBar: AppBar(
        title: Text('Grupos en ${widget.branchName}',style: TextStyle(color: Colors.white)),
         backgroundColor: Colors.black, // Fondo blanco
        //title: Text('Volver', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _screens[_selectedIndex],
      
      // Botón para crear una nota.
      floatingActionButton: NotesButton(),

     bottomNavigationBar: CustomNavigationBarAdmin(
        //(qué pantalla está activa).
        currentIndex: _selectedIndex, 
        // (qué hacer cuando el usuario cambia de pestaña).
        onTap: _onItemTapped,
        ),
    );
  }
}