import 'package:flutter/material.dart';
import 'package:tae_app/modules/admin/pages/branch_selection_tab.dart';

import '../../../welcome_tae_app.dart';

void main() {
  runApp(LicenciaApp());
}

class LicenciaApp extends StatelessWidget {
  const LicenciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LicenciaScreen(),
      routes: {
        '/next':
            (context) =>
                NextScreen(), //DIGAMOS QUE AQUI ES UNA RUTA PARA LA SIGUIENTE PANTALLA, AQUI ES LA RUTA A DONDE QUEREMOS IR, LO VI COMO UN METODO.
      },
    );
  }
}

class LicenciaScreen extends StatefulWidget {
  const LicenciaScreen({super.key});

  @override
  _LicenciaScreenState createState() => _LicenciaScreenState();
}

class _LicenciaScreenState extends State<LicenciaScreen> {
  int selectedIndex = 0; //CONTADOR

  final List<Map<String, dynamic>> plans = [
    {
      'title': 'MASTER',
      'price': 1799,
      'duration': '6ms',
      'features': [
        '3 sucursales',
        'Crea grupos',
        'Asigna contenido',
        'Realiza notas',
        'Administra tus finanzas',
      ],
    },
    {
      'title': 'TILIN',
      'price': 1200,
      'duration': '3ms',
      'features': [
        '1 sucursal',
        'Sin grupos',
        'Contenido limitado',
        'Notas básicas',
        'Solo estadísticas básicas',
      ],
    },
    // AQUI VAN LOS PLANES, CADA FRAGMENTO DE LLAVES ES UN PLAN.
  ];

  void nextPlan() {
    //PARA VER SI IR ADELANTE O ATRAS CON EL CONTADOR
    setState(() {
      selectedIndex = (selectedIndex + 1) % plans.length;
    });
  }

  void prevPlan() {
    setState(() {
      selectedIndex = (selectedIndex - 1 + plans.length) % plans.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final plan = plans[selectedIndex];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Licencia de uso',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Adquiere una licencia acorde a tus necesidades',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: prevPlan,
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(
                    child: Column(
                      // Cambiado de Container a Column para redibujar correctamente
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                plan['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '\$${plan['price']} /${plan['duration']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...plan['features'].map<Widget>(
                                (f) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.circle, size: 8),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(f)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MainBranches()),
                                    );
                                },
                                child: Text(
                                  'Proceder',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: nextPlan,
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              OutlinedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 211, 204, 204),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  //AQUI VA A LA ANTERIOR PANTALLA
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );

                 
                },
                child: Text(
                  'En otro momento',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  //AQUI SE ENCUENTRA LA SIGUIENTE PANTALLA, OSEA LA QUE SIGUE DESPUES DE LAS LICENCIAS, ESTA MADRE PUES SE PUEDE BORRAR
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Siguiente Pantalla')),
      body: Center(child: Text('Aquí continúa el proceso...')),
    );
  }
}
