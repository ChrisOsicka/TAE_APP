import 'package:flutter/material.dart';

class BarSearch extends StatelessWidget {
  const BarSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      // InputDecoration: decora la caja de texto.
      decoration: InputDecoration(
        // hintText: texto gris que aparece cuando no has escrito nada.
        hintText: 'Buscar',
        // prefixIcon: ícono que aparece al principio (lupa de búsqueda).
        prefixIcon: Icon(Icons.search),
        // filled, fillColor: fondo púrpura claro.
        // filled: true le dice a Flutter que el fondo del campo de texto debe estar relleno.
        // Si no colocamos filled: true, el fillColor no se aplica.
        filled: true,
        fillColor: Colors.purple[50],
    
        // Controla el espacio interno del TextField (lo que hay entre el borde y el texto que escribes).
        contentPadding: const EdgeInsets.symmetric(
          // vertical: 0: no agrega espacio arriba ni abajo.
          vertical: 0,
          // horizontal: 20: agrega 20 píxeles
          // de espacio a la izquierda y derecha dentro del campo.
          horizontal: 20,
          // Esto hace que el texto no quede pegado al borde interno.
        ),
        // border: redondeado con OutlineInputBorder y sin bordes visibles.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
