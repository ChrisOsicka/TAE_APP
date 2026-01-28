// wallet.dart
import 'package:flutter/material.dart';
import 'package:tae_app/modules/admin/pages/cash_payment_requests.dart';
import 'package:tae_app/modules/admin/pages/student_status_screen.dart';
import 'details_wallet.dart'; // Importamos la segunda pantalla

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // ← ¡Esto controla la flecha de volver!
        title: const Text(
          'Cartera',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 53, 119),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo y descripción
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

            // Botón de navegación (en lugar de solo flecha)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetailsWalletScreen()),
                );
              },
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
              label: const Text('Ver detalles completos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.attach_money, color: Colors.green),
                      title: const Text('Ver solicitudes de pago en efectivo'),
                      trailing: const Icon(Icons.coffee, color: Colors.brown),
                      onTap: () {
                        // Acción específica
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  CashPaymentRequestsScreen()),
                        );
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Función no implementada')),
                        // );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.blue),
                      title: const Text('Ver estado de alumnos'),
                      trailing: const Icon(Icons.info, color: Colors.blueGrey),
                      onTap: () {
                        // Acción específica
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StudentStatusScreen()),
                        );
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Función no implementada')),
                        // );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}