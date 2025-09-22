import 'package:flutter/material.dart';
import 'package:tae_app/modules/admin/widgets/branch_list_view.dart';
// (1) CLASE PRINCIPAL DEL FLUJO DE TRABAJO PARA LOS ICONOS - El padre que recibe los datos y el ícono:
  /*
  > Es el componente más externo, que se encarga de la adaptación responsiva.
  > Usa un LayoutBuilder para calcular el ancho máximo de las tarjetas (maxCardWidth) dependiendo del tamaño de la pantalla.
  > Si la pantalla es muy grande (> 800 px), limita el ancho a 600 px.
  > Si es más pequeña, usa el 95% del ancho disponible.
  > Luego construye un BranchListView, pasándole:s
      La lista de sucursales (branches)
      El ancho máximo de las tarjetas (maxCardWidth)
      El ícono (icon)

  📌 En resumen: “Mide la pantalla y manda los datos correctos al siguiente widget”.
  Piensa en él como el cerebro de la responsividad.
  */
class AdaptiveBranchList extends StatelessWidget {
  const AdaptiveBranchList({
    super.key,
    required this.branches,
        
        required this.icon, // <--- Nuevo parámetro para el ícono

  });

  final List<Map<String, dynamic>> branches;
      final IconData icon; // 👈 propiedad de la clase


  @override
  Widget build(BuildContext context) {
    return Expanded(
      // LayoutBuilder -> Te permite saber cuánto espacio tienes disponible (ancho y alto).
      child: LayoutBuilder(
        builder: (context, constraints) {
          // constraints.maxWidth te dice el ancho máximo disponible.
    
          // Lógica para ancho máximo (maxCardWidth)
          double
          maxCardWidth =
              // Si la pantalla es muy ancha (> 800 px), limita las tarjetas a 600 px de ancho.
              // Si no, hace que cada tarjeta use el 95% del ancho disponible.
              constraints.maxWidth > 800
                  ? 600
                  : constraints.maxWidth * 0.95;
          // Esto se usa para ajustar el tamaño de las tarjetas
          //de forma responsiva, por ejemplo en tablets o pantallas grandes.
    
          // ListView.builder -> ListView es un scroll vertical (como una lista).
          // builder -> construye dinámicamente los widgets que necesita mostrar (mejor rendimiento)
          /*
            ListView.builder es una forma eficiente 
            de construir listas grandes de widgets en Flutter sin renderizar todo al mismo tiempo.
              - Solo construye los elementos visibles en pantalla.
              - A medida que haces scroll, Flutter construye los nuevos widgets que necesitas ver.
             */
    
          // Aqui ya separamos el armado de tarjetas y el estilo de estas.
          return BranchListView(
            branches: branches, 
            maxCardWidth: maxCardWidth, icon: icon,  // - 👈 se lo pasa al hijo
            );
        },
      ),
    );
  }
}

