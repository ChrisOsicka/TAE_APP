import 'package:flutter/material.dart';


import 'package:tae_app/modules/admin/widgets/notes_button.dart';
import 'package:tae_app/modules/admin/widgets/search_bar.dart';

// En tu _StudentsScreenState
// La ventana tiene tres niveles de widgets que interactúan entre sí:
/*
StudentsSectionScreen (pantalla principal)
 └── BeltGroup (grupo de alumnos por cinta)
      └── StudentCard (tarjeta de alumno individual)
*/
class StudentsSectionScreen extends StatefulWidget {
  final String? groupName;

  const StudentsSectionScreen({Key? key, this.groupName}) : super(key: key);

  @override
  State<StudentsSectionScreen> createState() => _StudentsSectionScreenState();
}

class _StudentsSectionScreenState extends State<StudentsSectionScreen> {
  int _selectedIndex = 0;

  // (4) guardamos todos los seleccionados globalmente - Aquí se guardan 
  // todos los alumnos seleccionados de todos los grupos.
  Set<Map<String, dynamic>> _selectedStudentsGlobal = {};


  Map<String, List<Map<String, dynamic>>> _beltStudents = {
    'Cintas Blancas': [
      {'id':1,'name': 'Julio', 'image': 'assets/image/Logo.png', 'belt': 'Cinta Blanca'},
      {'id':2,'name': 'Wendy', 'image': 'assets/image/Logo.png', 'belt': 'Cinta Blanca'},
      {'id':3, 'name': 'Luis', 'image': 'assets/image/Logo.png', 'belt': 'Cinta Blanca'},
      {'id':4,'name': 'Luis', 'image': 'assets/image/Logo.png', 'belt': 'Cinta Blanca'},
      {'id':4,'name': 'Luis', 'image': 'assets/image/Logo.png','belt': 'Cinta Blanca'},
      {'id':4,'name': 'Luis', 'image': 'assets/image/Logo.png','belt': 'Cinta Blanca'},
      {'id':4,'name': 'Luis', 'image': 'assets/image/Logo.png','belt': 'Cinta Blanca'},
      {'id':4,'name': 'Luis', 'image': 'assets/image/Logo.png','belt': 'Cinta Blanca'},
      {'id':4,'name': 'Luis', 'image': 'assets/image/Logo.png','belt': 'Cinta Blanca'},
      {'id':4,'name': 'Luis', 'image': 'assets/image/Logo.png','belt': 'Cinta Blanca'},
      {'id':4,'name': 'Luis', 'image': 'assets/image/Logo.png','belt': 'Cinta Blanca'},
    ],
    'Cintas Naranjas': [
      {'id':5,'name': 'Paulo', 'image': 'assets/image/Logo.png','belt': 'Cinta Naranja'},
      {'id':6,'name': 'Camila', 'image': 'assets/image/Logo.png','belt': 'Cinta Naranja'},
      {'id':7,'name': 'Karen', 'image': 'assets/image/Logo.png','belt': 'Cinta Naranja'},
    ],
    'Cintas Azules': [
      {'id':8,'name': 'Roberto', 'image': 'assets/image/Logo.png','belt': 'Cinta Azul'},
      {'id':9,'name': 'Francisco', 'image': 'assets/image/Logo.png', 'belt': 'Cinta Azul'},
      {'id':10,'name': 'Eduardo', 'image': 'assets/image/Logo.png','belt': 'Cinta Azul'},
    ],
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Atrás'),
        titleTextStyle:TextStyle(
          fontSize: 25,
          color: Colors.white,
        ),
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

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      // Tu lógica del modal aquí
                      //showDialog(...);
                      /*
                      - Si no hay alumnos seleccionados, muestra un mensaje rápido (SnackBar).
                      - Si sí hay alumnos, abre un AlertDialog (el modal).
                      - El modal lista los alumnos seleccionados con su foto y nombre.
                      - Los botones Cancelar y Aceptar cierran el modal, pero más 
                        adelante el botón Aceptar servirá para llamar al backend.
                       */
                                if (_selectedStudentsGlobal.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No hay alumnos seleccionados')),
                                  );
                                  return;
                                }
                                showDialog(
                                  
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor:Color.fromARGB(255, 250, 250, 250),
                                    title: const Text('Confirmar eliminación'),titleTextStyle: TextStyle( fontWeight: FontWeight.bold,fontSize: 25),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: _selectedStudentsGlobal.map((student) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: AssetImage(student['image']),
                                              backgroundColor:Color.fromARGB(255, 250, 250, 250),
                                            ),
                                            title: Text(student['name'],  style: const TextStyle(fontWeight: FontWeight.bold),),
                                            subtitle: Text(
                                              student['belt'],
                                                style: const TextStyle(color: Colors.grey),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(213, 247, 222, 1),
                                          foregroundColor: const Color.fromARGB(255, 66, 66, 66),
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          ),
                                      ),
                                        child: const Text('Cancelar',style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          //  Aquí más adelante llamaremos al backend
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Eliminación confirmada')),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 214, 1, 1) ,
                                          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),

                                        child: const Text('Aceptar'),
                                      ),
                                    ],
                                  ),
                                );
                    },
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
                          Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 184, 10, 10),
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Borrar Alumnos Seleccionados',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color.fromARGB(255, 184, 10, 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Lista de grupos por cinta
                ..._beltStudents.entries
                    .map(
                      (entry) => BeltGroup(
                        beltName: entry.key,
                        students: entry.value,
                        onSeeMore: () {
                          print("Ver más de ${entry.key}");
                        },
                        //(5) creamos cada BeltGroup:
                        /*  Esto actualiza la lista global:
                        - Primero elimina del conjunto global los 
                          alumnos que pertenecen a ese grupo.
                        - Luego agrega los alumnos que sí están 
                          seleccionados en ese grupo.


                        Así, _selectedStudentsGlobal siempre refleja todos 
                        los alumnos seleccionados sin duplicados.
                        */
                         onSelectionChanged: (selectedFromGroup) {
                          setState(() {
                            // Actualizamos el conjunto global con los seleccionados de cada grupo
                            _selectedStudentsGlobal
                              ..removeWhere((s) => entry.value.contains(s))
                              ..addAll(selectedFromGroup);
                          });
                         },
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
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
            height: 50,
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
                side: BorderSide(
                  width: 2,
                  color: Colors.grey[400]!,
                ), // Borde más claro
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BeltGroup extends StatefulWidget {

  final String beltName;
  final List<Map<String, dynamic>> students;
  final VoidCallback onSeeMore; // Opcional: abrir otra pantalla
  
  // En BeltGroup, agregamos un callback que notifique al padre los seleccionados
  /*(1)
    - Esto es un callback (una función que se pasa desde el widget padre).
    - Se usa para avisar al padre cada vez que cambian los seleccionados en este gru
  */
  final ValueChanged<Set<Map<String, dynamic>>> onSelectionChanged; //  nuevo callback

  const BeltGroup({
    Key? key,
    required this.beltName,
    required this.students,
    required this.onSeeMore,
    
    required this.onSelectionChanged, // Tambien aqui lo agregamos

  }) : super(key: key);

  @override
  State<BeltGroup> createState() => _BeltGroupState();
}




class _BeltGroupState extends State<BeltGroup> {

  /* (2)
  Esta variable mantiene los alumnos seleccionados dentro de 
  este grupo (solo “Cintas Blancas”, por ejemplo).
  */
  final Set<Map<String, dynamic>> _selectedStudents = {};

  /*(3)
  Cuando haces clic en el Checkbox, este método:
    1. Cambia el estado local del alumno (lo selecciona o deselecciona).
    2. Llama al callback onSelectionChanged para avisarle al widget padre 
       los seleccionados actuales de ese grupo.
   */
  void _toggleSelection(Map<String, dynamic> student) {
    setState(() {
      if (_selectedStudents.contains(student)) {
        _selectedStudents.remove(student);
      } else {
        _selectedStudents.add(student);
      }
    });

    // 🔔 Notificar al padre quiénes están seleccionados en este grupo
    widget.onSelectionChanged(_selectedStudents);
  }


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
              widget.beltName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (widget.onSeeMore != null)
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 26),
                onPressed: widget.onSeeMore,
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Grid de alumnos
        SizedBox(
                   height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.students.length,
            itemBuilder: (context, index) {
              final student = widget.students[index];
              final String name = student['name'];
              final isSelected = _selectedStudents.contains(student);

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: StudentCard(
                  name: student['name'],
                  image: student['image'],
                  isSelected: isSelected,
                  onTap: () =>  _toggleSelection(student),
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
