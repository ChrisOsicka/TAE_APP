import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tae_app/modules/admin/widgets/notes_button.dart';
import 'package:tae_app/modules/admin/widgets/search_bar.dart';

class StudentsSectionScreen extends StatefulWidget {
  final String? groupName;

  const StudentsSectionScreen({Key? key, this.groupName}) : super(key: key);

  @override
  State<StudentsSectionScreen> createState() => _StudentsSectionScreenState();
}

class _StudentsSectionScreenState extends State<StudentsSectionScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Alumnos seleccionados globalmente
  Set<Map<String, dynamic>> _selectedStudentsGlobal = {};
  String _searchQuery = '';

  // ============================================================
  // === ELIMINAR ALUMNOS SELECCIONADOS DE FIREBASE =============
  // ============================================================
  Future<void> _deleteSelectedStudents() async {
    final String? groupId = widget.groupName;
    if (groupId == null || groupId.isEmpty) return;

    try {
      final batch = _db.batch();

      for (final student in _selectedStudentsGlobal) {
        final studentId = student['id'] as String;
        final docRef = _db
            .collection('grupos')
            .doc(groupId)
            .collection('alumnos')
            .doc(studentId);
        batch.delete(docRef);
      }

      await batch.commit();

      if (mounted) {
        setState(() {
          _selectedStudentsGlobal.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Alumnos eliminados correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error al eliminar alumnos: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ============================================================
  // === MOSTRAR DIÁLOGO DE CONFIRMACIÓN ========================
  // ============================================================
  void _showDeleteConfirmationDialog() {
    if (_selectedStudentsGlobal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay alumnos seleccionados')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        title: const Text('Confirmar eliminación'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.black,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: _selectedStudentsGlobal.map((student) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: student['image'] != null && student['image'].toString().isNotEmpty
                      ? NetworkImage(student['image'])
                      : const AssetImage('assets/image/Logo.png') as ImageProvider,
                  backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                ),
                title: Text(
                  student['name'] ?? 'Sin nombre',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  student['belt'] ?? 'Sin cinta',
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(213, 247, 222, 1),
              foregroundColor: const Color.fromARGB(255, 66, 66, 66),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSelectedStudents();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 214, 1, 1),
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? groupId = widget.groupName;
    
    if (groupId == null || groupId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Error: El grupo no fue seleccionado correctamente.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Atrás'),
        titleTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de búsqueda
              BarSearch(
                hintText: 'Buscar alumno por nombre',
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Botón eliminar
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _showDeleteConfirmationDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 184, 10, 10),
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Borrar Alumnos Seleccionados',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromARGB(255, 184, 10, 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Lista de alumnos desde Firebase
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db
                      .collection('grupos')
                      .doc(groupId)
                      .collection('alumnos')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No hay alumnos registrados en este grupo.'),
                      );
                    }

                    // Agrupar alumnos por cinta
                    final Map<String, List<Map<String, dynamic>>> beltStudents = {};

                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final student = {
                        'id': doc.id,
                        'name': data['nombre'] ?? 'Sin nombre',
                        'image': data['imagen'] ?? '',
                        'belt': data['cinta'] ?? 'Sin cinta',
                      };

                      final beltName = student['belt'] as String;
                      beltStudents.putIfAbsent(beltName, () => []);
                      beltStudents[beltName]!.add(student);
                    }

                    // Filtrar por búsqueda
                    final filteredBeltStudents = _filtrarAlumnos(beltStudents, _searchQuery);

                    if (filteredBeltStudents.isEmpty) {
                      return const Center(
                        child: Text('No se encontraron alumnos.'),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: filteredBeltStudents.entries.map((entry) {
                          return BeltGroup(
                            beltName: entry.key,
                            students: entry.value,
                            selectedStudents: _selectedStudentsGlobal,
                            onSeeMore: () {
                              print("Ver más de ${entry.key}");
                            },
                            onSelectionChanged: (selectedFromGroup) {
                              setState(() {
                                _selectedStudentsGlobal
                                  ..removeWhere((s) => entry.value.any((e) => e['id'] == s['id']))
                                  ..addAll(selectedFromGroup);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const NotesButton(),
    );
  }

  // Filtrar alumnos por nombre
  Map<String, List<Map<String, dynamic>>> _filtrarAlumnos(
    Map<String, List<Map<String, dynamic>>> todos,
    String query,
  ) {
    if (query.isEmpty) return todos;

    final queryLower = query.toLowerCase();
    final resultado = <String, List<Map<String, dynamic>>>{};

    for (final entry in todos.entries) {
      final cinta = entry.key;
      final alumnos = entry.value;

      final coincidencias = alumnos.where((alumno) {
        return (alumno['name'] as String).toLowerCase().contains(queryLower);
      }).toList();

      if (coincidencias.isNotEmpty) {
        resultado[cinta] = coincidencias;
      }
    }

    return resultado;
  }
}

// ============================================================
// === TARJETA DE ESTUDIANTE ==================================
// ============================================================
class StudentCard extends StatelessWidget {
  final String name;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const StudentCard({
    Key? key,
    required this.name,
    required this.image,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: image.isNotEmpty
                    ? NetworkImage(image)
                    : const AssetImage('assets/image/Logo.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: isSelected,
                onChanged: (value) => onTap(),
                activeColor: Colors.blue,
                side: BorderSide(
                  width: 2,
                  color: Colors.grey[400]!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// === GRUPO DE CINTA =========================================
// ============================================================
class BeltGroup extends StatelessWidget {
  final String beltName;
  final List<Map<String, dynamic>> students;
  final Set<Map<String, dynamic>> selectedStudents;
  final VoidCallback onSeeMore;
  final ValueChanged<Set<Map<String, dynamic>>> onSelectionChanged;

  const BeltGroup({
    Key? key,
    required this.beltName,
    required this.students,
    required this.selectedStudents,
    required this.onSeeMore,
    required this.onSelectionChanged,
  }) : super(key: key);

  void _toggleSelection(Map<String, dynamic> student) {
    final newSelection = Set<Map<String, dynamic>>.from(
      selectedStudents.where((s) => students.any((st) => st['id'] == s['id'])),
    );

    final isCurrentlySelected = newSelection.any((s) => s['id'] == student['id']);

    if (isCurrentlySelected) {
      newSelection.removeWhere((s) => s['id'] == student['id']);
    } else {
      newSelection.add(student);
    }

    onSelectionChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              beltName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward, size: 26),
              onPressed: onSeeMore,
            ),
          ],
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final isSelected = selectedStudents.any((s) => s['id'] == student['id']);

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: StudentCard(
                  name: student['name'],
                  image: student['image'],
                  isSelected: isSelected,
                  onTap: () => _toggleSelection(student),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}