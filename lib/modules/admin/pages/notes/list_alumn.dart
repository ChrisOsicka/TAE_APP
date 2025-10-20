// main_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'notes_students.dart';
import 'alumn.dart';

class AlumnosPorGrupoScreen extends StatelessWidget {
  const AlumnosPorGrupoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alumnos por Grupo")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('alumnos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");

          final alumnos = snapshot.data!.docs
              .map((doc) => Alumno.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          // Agrupar por grupo
          final grupos = <String, List<Alumno>>{};
          for (var alumno in alumnos) {
            grupos.putIfAbsent(alumno.grupo, () => []).add(alumno);
          }

          return ListView.builder(
            itemCount: grupos.length,
            itemBuilder: (context, index) {
              final grupo = grupos.keys.elementAt(index);
              final listaAlumnos = grupos[grupo]!;
              return ExpansionTile(
                title: Text(grupo),
                children: [
                  ...listaAlumnos.map((alumno) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: alumno.avatarUrl != null
                          ? NetworkImage(alumno.avatarUrl!)
                          : null,
                      child: alumno.avatarUrl == null ? const Icon(Icons.person) : null,
                    ),
                    title: Text(alumno.nombre),
                    onTap: () {
                      /*
                      Navigator.push(
                        
                        context,
                        
                        MaterialPageRoute(
                          builder: (_) => NotasAlumnoScreen(alumno: alumno),
                        ),
                        
                      );
                      */
                    },
                  )).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}