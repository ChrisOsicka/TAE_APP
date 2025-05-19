import 'package:flutter/material.dart';
import 'Group Selection.dart';
import 'wallet_screen.dart';
import 'profile_screen.dart';

// Branches Se traduce a sucursales

/*
FLUJO DE TRABAJO:
1. La app inicia y ejecuta main()
2. MaterialApp crea una instancia de MainBranches como pantalla inicial
3. MainBranches inicializa su estado con _selectedIndex = 0
4. El método build() construye:
 -> Un Scaffold con:
   - body: Muestra BranchesScreen() (porque _selectedIndex = 0)
   - bottomNavigationBar: Muestra la barra con 3 ítems
   - Cuando el usuario toca un ítem:
      Se ejecuta _onItemTapped con el nuevo índice
      setState() actualiza _selectedIndex
      Flutter reconstruye la interfaz mostrando la nueva pantalla
 */

// NOTA : todo en Flutter es un widget.
// Incluso pantallas enteras como BranchesScreen() son widgets.


// main(): Es el punto de entrada de toda aplicación Dart/Flutter.
//runApp(): Función que inicializa la aplicación Flutter y recibe el widget raíz.
//MaterialApp: Widget que proporciona las bases del diseño Material Design y configuración globa
void main() {
  runApp(
    // debugShowCheckedModeBanner -> Quita la etiqueta de "DEBUG" que aparece en la esquina superior
    // home : BranchesScreen() -> Significa que la pantalla principal al iniciar la app sera la clase  BranchesScreen()
    MaterialApp(debugShowCheckedModeBanner: false, home: MainBranches()),
  );
}

// StatelessWidget -> Es un widget que no cambia con el tiempo
// PERO si necesitamos que algo cambie
// - Un contador que aumenta cuando presionas un botón.
// - Una imagen que cambia cuando el usuario hace clic.
// - Mostrar diferentes datos después de presionar un botón.
// Se debe de usar un => StatefulWidget <=
class MainBranches extends StatefulWidget {
  @override
  _MainBranchesState createState() => _MainBranchesState();
}

class _MainBranchesState extends State<MainBranches> {

  // Propósito: Guarda el índice de la pantalla actualmente seleccionada
  int _selectedIndex = 0;

  // Lista de pantallas que cambiarán
  // Aquí defines las pantallas que se mostrarán para cada tab
  final List<Widget> _screens = [
    //HomeScreen(),
    BranchesScreen(), // temporal, cambia según lo que queramos hacer para "recargar" la pagina
    WalletScreen(),
    ProfileScreen(),
  ];

  // Método que se llama al tocar un ícono
  // Actualiza el estado con el nuevo índice seleccionado
  void _onItemTapped(int index) {
    // setState(): Notifica a Flutter que debe reconstruir la interfaz
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold — La base visual de la pantalla
      return Scaffold(
      // Muestra la pantalla correspondiente al índice seleccionado
      // body: Muestra la pantalla actual según _selectedIndex
      body: _screens[_selectedIndex],
       // Bottom navigation bar
      // Es la barra que aparece en la parte inferior de la pantalla.
      //Permite que el usuario navegue entre diferentes secciones de la app (por ejemplo: inicio, cartera, perfil).
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: Índice actualmente seleccionado (sincronizado con _selectedIndex)
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Cartera'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class BranchesScreen extends StatelessWidget {
  // Lista de mapas List<Map<String, dynamic> ->
    // - List: es una lista, como un conjunto ordenado de elementos.
    // - Map<String, dynamic>: es un mapa o diccionario. Tiene:
    //    - claves (keys): "name", "classes", "participants"
    //    - valores (values): "Sucursal A", 4, 70
  // final en Dart: Cuando declaras una variable como final, no puedes reasignarla, o sea:
  // Puedes modificar el contenido de la lista, pero no puedes asignar una nueva lista a esa variable.
  // final List<Map<String, dynamic>> branches = [...];
  // No puedes cambiar todo branches por otra lista nueva.
  // Sí puedes agregar, quitar o cambiar elementos dentro de la lista.

  final List<Map<String, dynamic>> branches = [
    {"name": "Centro Sur", "classes": 4, "participants": 70},
    {"name": "Tlacote", "classes": 5, "participants": 150},
    {"name": "Juriquilla", "classes": 3, "participants": 65},
  ];

  // @override significa que estás reescribiendo un método que ya existe en la clase padre (StatelessWidget).
  // build(BuildContext context) es el método que crea lo que se va a mostrar en pantalla
  // Todo lo que retorne el build es lo que verá el usuario cuando abra esa pantalla .
  @override
  Widget build(BuildContext context) {
    // Scaffold — La base visual de la pantalla
    return Scaffold(
      backgroundColor: Colors.white,
      // body: lo que va dentro del cuerpo principal de la pantalla.
      // SafeArea: evita que los elementos queden debajo del notch, barra de estado o botones del sistema.
      /*
        NOTA: El notch es la parte recortada de la pantalla en algunos 
        celulares modernos (como iPhones o algunos Android) 
        donde está la cámara frontal o sensores.
      */
      body: SafeArea(
        // Padding — Espacio alrededor del contenido
        // Padding es un widget que agrega espacio alrededor de su hijo (en este caso, una Column).
        child: Padding(
          // Aquí aplicamos 16 de margen horizontal (izquierda y derecha) y 10 vertical (arriba y abajo).
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

          // Column — Apilar widgets verticalmente, apila widgets de arriba hacia abaj
          child: Column(
            // Alinea el contenido al inicio horizontal (izquierda).
            crossAxisAlignment: CrossAxisAlignment.start,
            // children (en plural) es una lista de
            // widgets hijos que van uno debajo del otro en una Column.
            // NOTA: No confundir con child (en singular), que solo permite un único widget hijo.
            children: [
              // Search bar
              // TextField — Barra de búsqueda
              // TextField: caja de texto donde el usuario puede escribir.
              TextField(
                // InputDecoration: decora la caja de texto.
                decoration: InputDecoration(
                  // hintText: texto gris que aparece cuando no has escrito nada.
                  hintText: 'Buscar sucursal',
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
              ),
              // Crea un espacio vertical de 10 píxeles entre la caja de búsqueda y el siguiente elemento.
              const SizedBox(height: 10),

              // Agregar Sucursal
              // Alinea su hijo al lado derecho (Alignment.centerRight).
              Align(
                alignment: Alignment.centerRight,
                // Necesario para que InkWell funcione con efecto visual de toque.
                // Aquí es transparente, solo se usa como "base de toque".
                child: Material(
                  color: Colors.transparent, // Para que no tenga fondo
                  // Hace que un widget sea "tocable" (con efecto de onda).
                  // onTap: función que se ejecuta al tocarlo. En este caso, imprime en consola.
                  child: InkWell(
                    onTap: () {
                      // Acción al hacer clic
                      print("Agregar Sucursal clickeado");
                    },
                    // Padding dentro del botón
                    // Da espacio alrededor del texto e ícono.
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // Pone el texto y el ícono uno al lado del otro.
                      // mainAxisSize: MainAxisSize.min: ajusta el tamaño de la fila a su contenido (no ocupa toda la pantalla).
                      child: Row(
                        // Hace que la Row ocupe solo el espacio necesario para su contenido (no todo el ancho).
                        mainAxisSize: MainAxisSize.min,

                        // Los widgets dentro de la fila:
                        // Text(...): el texto "Agregar Sucursal".
                        //SizedBox(width: 5): espacio entre el texto y el ícono.
                        //Icon(...): ícono de círculo con símbolo de agregar.
                        children: const [
                          Text(
                            'Agregar Sucursal  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.add_circle_outline),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Lista de sucursales
              // Mostrar una lista de tarjetas con detalles de cada sucursal

              // EXPANDED -> Hace que su hijo ocupe todo el espacio disponible restante.
              // Se usa dentro de una Column para decir:
              //"esta parte puede crecer lo que quiera dentro del espacio disponible".
              // Sin Expanded, la lista podría no mostrarse correctamente o desbordarse.
              Expanded(
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

                    return ListView.builder(
                      //  Sin esto, los primeros elementos podrían quedar pegados al borde superior.
                      padding: const EdgeInsets.only(top: 10),
                      // Indica cuántos elementos tendrá la lista.
                      // Entonces branches.length es 3, así que se construirán 3 tarjetas.
                      // itemCount: branches.length: va a crear una tarjeta por cada sucursal.
                      itemCount: branches.length,

                      // Esto es una función anónima (lambda) que:
                      //  context: el contexto de la app.
                      // => Para que Flutter sepa dónde dibujar cosas,
                      //cambiar pantallas, mostrar alertas, buscar estilos, etc
                      //  index: el índice actual (0, 1, 2, ...).
                      itemBuilder: (context, index) {
                        // Aquí accedes al elemento de la lista de sucursales en esa posición.
                        // Ejemplo: si index = 0, entonces branch = {"name": "Centro Sur", ...}
                        final branch = branches[index];

                        // Center -> centra horizontalmente la tarjeta.
                        return Center(
                          // InkWell le da un efecto visual al tocar (ripple effect) y ejecuta el onTap.
                          child: InkWell(
                            onTap: () {
                              // Navega a la nueva pantalla
                              // Abre la pantalla BranchDetailsScreen (otro widget que tú creaste).
                              // Le pasa el nombre de la sucursal como parámetro (branchName).
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BranchGroupsScreen(
                                        branchName: branch['name'],
                                      ),
                                ),
                              );
                            },

                            // Aquí es donde se diseña visualmente cada tarjeta:
                            child: Container(
                              // width: maxCardWidth y height: 170
                              // Tamaño de cada tarjeta.
                              // El ancho lo ajusta el LayoutBuilder.
                              width: maxCardWidth,
                              height:
                                  170, // Aquí se define el alto deseado de la tarjeta
                              // Espacio entre cada tarjeta
                              margin: const EdgeInsets.only(bottom: 26),

                              // Espacio dentro de la tarjeta, para que el texto
                              // y contenido no estén pegados a los bordes.
                              padding: const EdgeInsets.all(26),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),

                              // Organiza horizontalmente a sus hijos.
                              // En este caso tiene dos hijos:
                              // Una Column (con los textos)
                              // Un Icon
                              child: Row(
                                children: [
                                  // Text info
                                  // Hace que la columna ocupe todo el espacio horizontal posible dentro del Row.
                                  // Esto evita que el ícono empuje los textos fuera de la pantalla
                                  Expanded(
                                    // Organiza los textos verticalmente.
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start: alinea los textos a la izquierda.
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      // mainAxisAlignment: MainAxisAlignment.center: centra todo verticalmente dentro del espacio disponible.
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center, // Centra el texto verticalmente
                                      children: [
                                        // Muestran los datos de cada sucursal:
                                        /* 
                                        - El nombre
                                        - La cantidad de clases
                                        - El número de participantes
                                        - Los valores vienen del mapa branch, que es un Map<String, dynamic> dentro de la lista branches.
                                        */
                                        Text(
                                          branch['name'],
                                          style: const TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${branch["classes"]} clases',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          '${branch["participants"]} participantes',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Icono
                                  // Muestra un ícono de ubicación a la derecha del Row.
                                  // No está dentro del Expanded, así que solo ocupa el espacio necesario.
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 50,
                                    color: Color.fromARGB(255, 57, 56, 56),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Botón flotante
      /*
      Un botón flotante (Floating Action Button o FAB) es 
      un botón circular y elevado que aparece sobre 
      la interfaz, normalmente en la esquina inferior derecha.
       */
      floatingActionButton: FloatingActionButton(
        // Aun no tiene funcionalidad por que el OnPressed esta vacio
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
    );
  }
}
