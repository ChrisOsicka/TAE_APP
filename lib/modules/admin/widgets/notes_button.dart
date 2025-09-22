import 'package:flutter/material.dart';

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
      onPressed: () {},
      child: Icon(Icons.edit),
    );
  }
}
