import 'package:flutter/material.dart';

// A esta clase no es recomendable meterle como tal las pantallas por
// la cual la barra de navegacion tendra que redireccionar, esto es por el simple hecho 
// de que esta debe de ser para un uso generico y no específico
class CustomNavigationBarAdmin extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBarAdmin({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Cartera'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}


