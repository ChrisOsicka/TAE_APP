import 'package:flutter/material.dart';

class AddDialog extends StatefulWidget {
  final Function(Map<String,dynamic>)onSave;

  const AddDialog({
    Key? key,
    required this.onSave,
    }) : super(key:key);



  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {

  final TextEditingController nameController = TextEditingController();
  // final TextEditingController participantsController = TextEditingController();
  // 🔹 Simulamos el valor que luego vendrá de Firebase
  // Por ahora lo dejamos fijo en 0 o lo puedes dejar vacío

   // Controladores para capturar texto del formulario
  int? availableClasses; 
  int? availableParticipants; 

  @override
  Widget build(BuildContext context) {
      return  AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Agregar Sucursal',
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
                  labelText: 'Nombre de la Sucursal',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)), // Color del borde normal
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),// Color cuando está enfocado
                                    
                ),
              ),
              const SizedBox(height: 12),

              // Clases disponibles (automático / sin edición)
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Clases Disponibles',
                  border: const OutlineInputBorder(),
                  hintText: availableClasses != null
                      ? '$availableClasses'
                      : 'Por defecto tendra 0 clases disponibles',
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
                  hintText: availableParticipants != null
                      ? '$availableParticipants'
                      : 'Por defecto tendra 0 actividades disponibles)',
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
              //int? participants = int.tryParse(availableParticipants.text.trim());

              // 🔹 Validamos solo los campos necesarios
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor llena el nombre'),
                  ),
                );
                return;
              }

              // 🔹 Aquí simulamos el valor automático de clases desde Firebase
              // (cuando integres Firebase, lo reemplazas con el valor real)
              // int classes = await FirebaseService.getAvailableClasses(branchName);
              int classes = availableClasses ?? 0;

              int participants = availableParticipants ?? 0;


            // 🔹 Retornamos los datos al padre mediante el callback
              widget.onSave({
              "name": name,
              "classes": classes,
              "participants": participants,
            });

              // 🔹 Mostrar en consola para verificar
              print("Sucursal agregada: $name ($classes clases)");

              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    }
}

