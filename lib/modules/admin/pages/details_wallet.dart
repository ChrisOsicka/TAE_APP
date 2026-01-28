// details_wallet.dart
import 'package:flutter/material.dart';

class DetailsWalletScreen extends StatelessWidget {
  const DetailsWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // ← ¡Esto controla la flecha de volver!
        title: const Text(
          'Detalles Financieros',
          style: TextStyle(
            color: Colors.white,
          ) ,
        ),
        backgroundColor: Color.fromARGB(255, 41, 53, 119),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            const Text(
              'Bienvenido Administrador: Jorge Gomez Bolaños',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Se presentan las estadísticas del estado financiero de esta sucursal.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Gráficos simulados (puedes reemplazar con Chart libraries como fl_chart)
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.lightBlue[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('\$75,000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Reporte del mes pasado (15-02-2025)', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Colors.blueGrey[800],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('\$60,000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 8),
                          const Text('Reporte del mes actual (15-03-2025)', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Lista de pagos
            const Text('Pago de colegiatura', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: const [
                  ListTile(
                    title: Text('Israel'),
                    trailing: Text('\$0.00'),
                  ),
                  ListTile(
                    title: Text('Maribel'),
                    trailing: Text('\$1,500.00'),
                  ),
                  ListTile(
                    title: Text('Karen'),
                    trailing: Text('\$1,500.98'),
                  ),
                  ListTile(
                    title: Text('Israel'),
                    trailing: Text('\$0.00'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Ganancias:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$60,000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}