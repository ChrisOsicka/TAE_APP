import 'package:flutter/material.dart';

class BarSearch extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onSearch; // Callback cuando el texto cambi

  const BarSearch({
    super.key,
    this.hintText = 'Buscar',
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearch, // ← Aquí se conecta la lógica externa

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
        fillColor: const Color.fromARGB(255, 208, 227, 235),
    
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
