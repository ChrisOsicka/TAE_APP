// Modelos de datos
class Alumno {
  final String id;
  final String nombre;
  final String grupo;
  final String? avatarUrl;

  Alumno({
    required this.id,
    required this.nombre,
    required this.grupo,
    this.avatarUrl,
  });

  factory Alumno.fromFirestore(Map<String, dynamic> data, String id) {
    return Alumno(
      id: id,
      nombre: data['nombre'] ?? '',
      grupo: data['grupo'] ?? '',
      avatarUrl: data['avatarUrl'],
    );
  }
}