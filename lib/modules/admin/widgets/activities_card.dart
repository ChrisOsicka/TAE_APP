import 'package:flutter/material.dart';

class ActivitiesCard extends StatelessWidget {
  final List<Map<String, dynamic>> groups;

  final String groupTitle;

  final VoidCallback? onAddActivity; // ← Callback opcional

  //const ActivitiesCard({super.key});
  const ActivitiesCard({
    Key? key,
    required this.groups,
    required this.groupTitle,
    this.onAddActivity,
  }) : super(key: key);

  // Callback para cuando se edite
  void _handleEdit() {
    print("Editar $groupTitle");
    // Aquí puedes abrir un diálogo, navegar, etc.
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
              onEdit: _handleEdit, // ← Opcional: define qué hacer al editar
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
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return ActivityCard(group: groups[index]);
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

  const ActivityCard({Key? key, required this.group}) : super(key: key);

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
                IconButton(
                  icon: Icon(Icons.edit_note_sharp, size: 20),
                  onPressed: () {
                    // Acción de configuración
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed :() {
                    // Acción de configuración
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
