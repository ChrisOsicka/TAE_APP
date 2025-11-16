import 'package:flutter/material.dart';
import 'package:tae_app/modules/admin/pages/activity_detail_screen.dart';

class ActivitiesCard extends StatelessWidget {
  final List<Map<String, dynamic>> group;

  final String groupTitle;
  final VoidCallback? onAddActivity; // ← Callback opcional

    // 👇 Nuevos callbacks
  final Function(String activityId, String newName)? onNameChanged;
  final Function(String activityId)? onDelete;

  // 👇 Nuevo callback para editar el NOMBRE DE LA CINTA
  final ValueChanged<String>? onBeltNameChanged;
    

  //const ActivitiesCard({super.key});
  const ActivitiesCard({
    Key? key,
    required this.group,
    required this.groupTitle,
    this.onAddActivity,
     this.onNameChanged,
    this.onDelete,
    this.onBeltNameChanged, // ← Aquí

  }) : super(key: key);

  // Callback para cuando se edite
  void _handleEdit() {
    print("Editar $groupTitle");
    // Aquí puedes abrir un diálogo, navegar, etc.
  }

  void _showEditBeltNameDialog(
  BuildContext context,
  String currentName,
  ValueChanged<String>? onConfirm,
) {
  final nameController = TextEditingController(text: currentName);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar nombre de la cinta'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          hintText: 'Nuevo nombre',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          
          onPressed: () {
            final newName = nameController.text.trim();
            if (newName.isNotEmpty && newName != currentName) {
              onConfirm?.call(newName);
            } else if (newName == currentName) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('El nombre ya está actualizado')),
              );
            }
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 14, 162, 221),
                foregroundColor: const Color.fromARGB(255, 241, 239, 239), // color del texto
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado con menú desplegable y botón de agregar
        Row(
          children: [
            // ✅ Widget reutilizable con menú
            GroupHeaderWithMenu(
              title: groupTitle, // ← Personalizado
              onEdit: () {
                  _showEditBeltNameDialog(context, groupTitle, onBeltNameChanged);
                },            
                ),
            const SizedBox(width: 25),
            InkWell(
              // Agregar una actividad
              onTap: onAddActivity, // ← Llama al callback si existe


              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.add_circle_outline, size: 30),
              ),
            ),
          ],
        ),

        // Espacio vertical
        const SizedBox(height: 16),

        // Carrusel horizontal de tarjetas
        SizedBox(
          height: 200, // Altura fija para que se vea bien
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: group.length,
            itemBuilder: (context, index) {
              final activity = group[index];
              final String activityId = activity['id'] as String;
              return ActivityCard(
                group: activity,
                onNameChanged: (newName){
                 this.onNameChanged?.call(activityId, newName);
                },
                onDelete: () {
                  // 👈 Aquí usas el index que conoces
                  onDelete?.call(activityId);
                },
                        
                            

                );
            },
          ),
        ),
      ],
    );
  }

  // Ese sirve para el menu desplegale al dar tab en el nombre o 3 puntos.
  PopupMenuButton<String> PopupMenuEditar() {
    return PopupMenuButton<String>(
      onSelected: (String? value) async {
        if (value == 'editar') {
          print("Editar nombre");

          // Aquí puedes abrir un diálogo, navegar a edición, etc.
        }
      },
      color: Colors.white, // ← Fondo blanco para TODO el menú desplegable
      //  forma redondeada y sombra
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!), // Borde sutil
      ),
      elevation: 4, // Sombra



      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'editar',
            // 👇 Esto evita el fondo morado AL SELECCIONAR el ítem
            child: Container(
              color: Colors.transparent, // ← ¡Evita el morado de selección!
              //padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // ← Espaciado bonito
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue, size: 18),
                  const SizedBox(width: 12),
                  Text(
                    'Editar nombre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}

class GroupHeaderWithMenu extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit; // ← Callback opcional para cuando se edite

  const GroupHeaderWithMenu({Key? key, required this.title, this.onEdit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'editar') {
          onEdit?.call(); // ← Llama al callback si existe
        }
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.more_vert, size: 20),
            const SizedBox(width: 8),
            Text(
              title, // ← ¡Texto dinámico!
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'editar',
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue, size: 18),
                  const SizedBox(width: 12),
                  Text(
                    'Editar nombre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}

// Tarjeta individual
class ActivityCard extends StatelessWidget {
  final Map<String, dynamic> group;

  // 👇 Nuevos callbacks para editar/eliminar actividades
  final ValueChanged<String>? onNameChanged; // ✅ Solo el nuevo nombre
  final VoidCallback? onDelete;              // ✅ Sin parámetros

  

  const ActivityCard({
    Key? key,
    required this.group,
    this.onNameChanged,
    this.onDelete,
    }) : super(key: key);
  
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220, // ← Ancho fijo para cada tarjeta
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              group['name'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Lista de ejercicios
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // ← Evita conflicto de scrolls
                itemCount: group['exercises']?.length ?? 0,
                itemBuilder: (context, index) {
                  return Text(
                    '${group['exercises'][index]}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  );
                },
              ),
            ),

            SizedBox(height: 12),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 // ✅ Botón de edición mejorado
                IconButton(
                  icon: const Icon(Icons.edit_note_sharp, size: 20),
                  onPressed: () => _showEditDialog(context),
                ),
                
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityDetailScreen(
                          activityName: group['name'],
                          exercises: List<String>.from(group['exercises']),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),

      
    );
  }

  // 🗂️ Diálogo principal: Editar nombre o Eliminar
  void _showEditNameDialog(BuildContext context) {
  final nameController = TextEditingController(text: group['name']); // ✅ group, no activity
  final String activityId = group['id'] as String; // 🚨 Obtén el ID aquí
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar nombre'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          hintText: 'Nuevo nombre',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          
          onPressed: () {
            final newName = nameController.text.trim();
            if (newName.isNotEmpty) {
              onNameChanged?.call(newName);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),

          style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 14, 162, 221),
                foregroundColor: const Color.fromARGB(255, 241, 239, 239), // color del texto
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
        ),
      ],
    ),
  );
}

 
      // 🗑️ Diálogo de confirmación para eliminar
      
      void _showDeleteConfirmation(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Eliminar actividad?'),
          content: Text('Se eliminará la actividad "${group['name']}".\nEsta acción no se puede deshacer.'), // ✅ group
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              
              onPressed: () {
                onDelete?.call();
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      );
    }

    // 🗂️ Diálogo principal: muestra las opciones "Editar nombre" y "Eliminar"
    void _showEditDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Opciones de actividad'),
          content: const Text('¿Qué deseas hacer con esta actividad?'),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 11, 142, 230),
                foregroundColor: const Color.fromARGB(255, 54, 54, 54), // color del texto
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              
              onPressed: () {
                Navigator.of(context).pop();
                _showEditNameDialog(context); // ← Abre edición de nombre
              },
              


              
              child: const Text('Editar nombre', 
              style: TextStyle(color: Color.fromARGB(255, 238, 238, 238)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 177, 2, 2),
                foregroundColor: const Color.fromARGB(255, 54, 54, 54), // color del texto
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteConfirmation(context); // ← Abre confirmación de eliminación
              },
              child: const Text('Eliminar', style: TextStyle(color: Color.fromARGB(255, 253, 253, 253))),
            ),
          ],
        ),
      );
    }
}


