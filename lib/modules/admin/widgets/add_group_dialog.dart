import 'package:flutter/material.dart';


class AddGroupDialog extends StatefulWidget {


   final Function(Map<String,dynamic>)onSave;

  const AddGroupDialog({
    Key? key,
    required this.onSave,
    }) : super(key:key);

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}



class _AddGroupDialogState extends State<AddGroupDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController beltTypeController = TextEditingController();
  final TextEditingController scheduleController = TextEditingController();
  // 🔹 Simulamos el valor que luego vendrá de Firebase
  // Por ahora lo dejamos fijo en 0 o lo puedes dejar vacío

  // Controladores para capturar texto del formulario
  int? availableAlumns; 

  @override
  Widget build(BuildContext context) {
      return  AlertDialog(
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
              // Nombre de la sucursal
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Grupo de cintas',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)), // Color del borde normal
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),// Color cuando está enfocado
                                    
                ),
              ),
              const SizedBox(height: 12),

              // Listado de Cintas
              TextField(
                controller: beltTypeController,
                decoration: const InputDecoration(
                  labelText: 'Listado de cintas',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)), // Color del borde normal
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),// Color cuando está enfocado
                                    
                ),
              ),
              const SizedBox(height: 12),

              // Horario
              TextField(
                controller: scheduleController,
                decoration: const InputDecoration(
                  labelText: 'Horario',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)), // Color del borde normal
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),// Color cuando está enfocado
                                    
                ),
              ),
              const SizedBox(height: 12),

              // Participantes
              TextField(
                readOnly: true,
                //controller: participantsController,
                //keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Participantes',
                  border: const OutlineInputBorder(),
                  hintText: availableAlumns != null
                      ? '$availableAlumns'
                      : 'Por defecto tendra 0 Alumnos)',
                ),
              ),
              const SizedBox(height: 12),

            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar sin hacer nada
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )
              

            ),
            onPressed: () {
              // Capturamos los valores ingresados
              String name = nameController.text.trim();
              String schedule = scheduleController.text.trim();
              String beltType = beltTypeController.text.trim();


              // 🔹 Validamos solo los campos necesarios
              if (name.isEmpty || schedule.isEmpty ||beltType.isEmpty ) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor llena el nombre, cintas y el horario '),
                  ),
                );
                return;
              }

              // 🔹 Aquí simulamos el valor automático de clases desde Firebase
              // (cuando integres Firebase, lo reemplazas con el valor real)
              // int classes = await FirebaseService.getAvailableClasses(branchName);
              int alumns = availableAlumns ?? 0;


            // 🔹 Retornamos los datos al padre mediante el callback
              widget.onSave({
              "name": name,
              "beltType": beltType,
              "schedule": schedule,
              "alumns": alumns,
            });

              // 🔹 Mostrar en consola para verificar
              print("Sucursal agregada: $name ($schedule clases)");

              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    }
}

