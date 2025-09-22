import 'package:flutter/material.dart';
import 'package:tae_app/modules/admin/pages/profile_screen.dart';
import 'package:tae_app/modules/admin/pages/wallet_screen.dart';
import 'package:tae_app/modules/admin/widgets/custom_navigation_bar_admin.dart';
import 'package:tae_app/modules/admin/widgets/notes_button.dart';
import 'package:tae_app/modules/admin/widgets/search_bar.dart';

// En tu _StudentsScreenState
class StudentsSectionScreen extends StatefulWidget {
  final String? groupName;

  const StudentsSectionScreen({Key? key, this.groupName}) : super(key: key);

  @override
  State<StudentsSectionScreen> createState() => _StudentsSectionScreenState();
}

class _StudentsSectionScreenState extends State<StudentsSectionScreen> {


    int _selectedIndex = 0;

  Map<String, List<Map<String, dynamic>>> _beltStudents = {
    'Cintas Blancas': [
      {'name': 'Julio', 'image': 'assets/image/Logo.png'},
      {'name': 'Wendy', 'image': 'assets/image/Logo.png'},
      {'name': 'Luis', 'image': 'assets/image/Logo.png'},
      {'name': 'Luis', 'image': 'assets/image/Logo.png'},
      {'name': 'Luis', 'image': 'assets/image/Logo.png'},
      {'name': 'Luis', 'image': 'assets/image/Logo.png'},
      {'name': 'Luis', 'image': 'assets/image/Logo.png'},
      {'name': 'Luis', 'image': 'assets/image/Logo.png'},
      {'name': 'Luis', 'image': 'assets/image/Logo.png'},
      {'name': 'Luis', 'image': 'assets/image/Logo.png'},
      {'name': 'Luis', 'image': 'assets/image/Logo.png'},
      
    ],
    'Cintas Naranjas': [
      {'name': 'Paulo', 'image': 'assets/image/Logo.png'},
      {'name': 'Camila', 'image': 'assets/image/Logo.png'},
      {'name': 'Karen', 'image': 'assets/image/Logo.png'},
    ],
    'Cintas Azules': [
      {'name': 'Roberto', 'image': 'assets/image/Logo.png'},
      {'name': 'Francisco', 'image': 'assets/image/Logo.png'},
      {'name': 'Eduardo', 'image': 'assets/image/Logo.png'},
    ],
  };

    // Lista de pantallas/pestañas
  late final List<Widget> _screens;

    @override
      void initState() {
    super.initState();
    _screens = [
      //StudentsSectionScreen(), // Tu pantalla de grupos actual
      WalletScreen(),        // Pantalla de cartera
      ProfileScreen(),       // Pantalla de perfil
    ];
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
        title: Text(widget.groupName ?? 'Alumnos'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra de búsqueda (si la tienes)
                BarSearch(),

                const SizedBox(height: 20),

                // Lista de grupos por cinta
                ..._beltStudents.entries.map((entry) => BeltGroup(
                  beltName: entry.key,
                  students: entry.value,
                  onSeeMore: () {
                    print("Ver más de ${entry.key}");
                  },
                )).toList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBarAdmin(
        //(qué pantalla está activa).
        currentIndex: _selectedIndex, 
        // (qué hacer cuando el usuario cambia de pestaña).
        onTap: _onItemTapped,
        ),
      floatingActionButton: NotesButton(),
    );
  }
}



class StudentCard extends StatelessWidget {
  final String name;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const StudentCard({
    Key? key,
    required this.name,
    required this.image,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 130, // ← Altura fija para evitar overflow
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Foto circular
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          const SizedBox(height: 8),
          // Nombre
          Text(
            name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2), // Espacio entre nombre y checkbox
          // Checkbox
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) => onTap(),
                activeColor: Colors.blue,
                side: BorderSide(width: 2, color: Colors.grey[400]!), // Borde más claro
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class BeltGroup extends StatelessWidget {
  
  final String beltName;
  final List<Map<String, dynamic>> students;
  final VoidCallback onSeeMore; // Opcional: abrir otra pantalla

  const BeltGroup({
    Key? key,
    required this.beltName,
    required this.students,
    required this.onSeeMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la cinta + flecha
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              beltName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (onSeeMore != null)
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 26),
                onPressed: onSeeMore,
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Grid de alumnos
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
                shrinkWrap: true, // ← ¡Este es el truco!

            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Padding(
                padding: EdgeInsets.only(right: 12),
                child: StudentCard(
                  name: student['name'],
                  image: student['image'],
                  isSelected: false, // ← Por ahora fijo, puedes hacerlo dinámico
                  onTap: () {
                    // Aquí puedes manejar la selección
                    print("Seleccionado: ${student['name']}");
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}