import 'package:flutter/material.dart';
import 'package:tae_app/modules/admin/pages/notes/notes_students.dart';

  // Botón flotante
      /*
      Un botón flotante (Floating Action Button o FAB) es 
      un botón circular y elevado que aparece sobre 
      la interfaz, normalmente en la esquina inferior derecha.
       */
class NotesButton extends StatelessWidget {
  const NotesButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // Aun no tiene funcionalidad por que el OnPressed esta vacio
      onPressed: () {
         Navigator.push(
          context, 
          MaterialPageRoute(
          builder: (context) => NotasAlumnoScreen(),
          ),
        );
      },
      child: Icon(Icons.edit),
      

    );
  }
}
