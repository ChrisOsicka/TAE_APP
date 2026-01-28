import 'package:flutter/material.dart';

class AddGroupDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddGroupDialog({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController beltTypeController = TextEditingController();
  final TextEditingController scheduleController = TextEditingController();

  int? availableAlumns;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Agregar un nuevo grupo',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nombre del grupo
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Grupo de cintas',
                labelStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
            ),
            const SizedBox(height: 12),

            // Listado de Cintas
            TextField(
              controller: beltTypeController,
              decoration: const InputDecoration(
                labelText: 'Listado de cintas',
                labelStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
            ),
            const SizedBox(height: 12),

            // Horario
            TextField(
              controller: scheduleController,
              decoration: const InputDecoration(
                labelText: 'Horario',
                labelStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
            ),
            const SizedBox(height: 12),

            // Participantes
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Participantes',
                border: const OutlineInputBorder(),
                hintText: availableAlumns != null
                    ? '$availableAlumns'
                    : 'Por defecto tendrá 0 alumnos',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            final name = nameController.text.trim();
            final beltType = beltTypeController.text.trim();
            final schedule = scheduleController.text.trim();

            // Validación de campos
            if (name.isEmpty || beltType.isEmpty || schedule.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Por favor llena el nombre, cintas y el horario'),
                ),
              );
              return;
            }

            final alumns = availableAlumns ?? 0;

            // 🔹 En lugar de usar solo el callback, devolvemos los datos con Navigator.pop
            final newGroupData = {
              "name": name,
              "beltType": beltType,
              "schedule": schedule,
              "alumns": alumns,
            };

            widget.onSave(newGroupData);
            Navigator.of(context).pop(newGroupData); //  retorna al showDialog

            print("Sucursal agregada: $name ($schedule clases)");
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
