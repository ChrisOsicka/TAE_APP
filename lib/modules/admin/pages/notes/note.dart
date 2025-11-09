// Modelos de datos
class Nota {
  final String id;
  final String alumnoId;
  //final DateTime fecha;
  final String texto;
  final bool activa;

  Nota({
    required this.id,
    required this.alumnoId,
    //required this.fecha,
    required this.texto,
    this.activa = true,
  });

  factory Nota.fromFirestore(Map<String, dynamic> data, String id) {
    return Nota(
      id: id,
      alumnoId: data['alumnoId'],
      //fecha: (data['fecha'] as Timestamp).toDate(),
      texto: data['texto'],
      activa: data['activa'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'alumnoId': alumnoId,
      //'fecha': Timestamp.fromDate(fecha),
      'texto': texto,
      'activa': activa,
    };
  }
}