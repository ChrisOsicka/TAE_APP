import 'package:flutter/material.dart';

class AdminProfileScreen extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String imageUrl;

  const AdminProfileScreen({
    Key? key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Administrador'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Foto del administrador
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 20),

            // Nombre completo
            Text(
              fullName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Rol
            Text(
              role,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Información adicional
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(phone),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Botón de cerrar sesión
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Aquí va la lógica de cierre de sesión
                  Navigator.pop(context); // ejemplo simple
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
