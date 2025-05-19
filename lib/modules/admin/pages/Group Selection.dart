import 'package:flutter/material.dart';
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
    {"name": "Grupo Avanzado", "beltType": "Negra", "schedule": "Lunes y Miércoles 18:00-20:00"},
    {"name": "Grupo Intermedio", "beltType": "Azul", "schedule": "Martes y Jueves 17:00-19:00"},
    {"name": "Grupo Principiantes", "beltType": "Blanca", "schedule": "Sábados 10:00-12:00"},
    {"name": "Grupo Infantil", "beltType": "Amarilla", "schedule": "Viernes 16:00-18:00"},
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
            TextField(
              decoration: InputDecoration(

                hintText: 'Buscar grupo',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.purple[50],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
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
            onTap: () {},
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
                          'Tipo de cinta: ${group["beltType"]}',
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
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => print("Editar grupos"),
              child: const Icon(Icons.edit),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Cartera'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}