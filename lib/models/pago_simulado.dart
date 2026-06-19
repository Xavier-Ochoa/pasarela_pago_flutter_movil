import 'package:cloud_firestore/cloud_firestore.dart';

class PagoSimulado {
  final String? id;
  final String producto;
  final double total;
  final String titular;
  final String ultimos4;
  final String estado;
  final DateTime? fecha;

  const PagoSimulado({
    this.id,
    required this.producto,
    required this.total,
    required this.titular,
    required this.ultimos4,
    required this.estado,
    this.fecha,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'producto': producto,
      'total': total,
      'titular': titular,
      'ultimos4': ultimos4,
      'estado': estado,
      'fecha': FieldValue.serverTimestamp(),
    };
  }

  factory PagoSimulado.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PagoSimulado(
      id: doc.id,
      producto: data['producto'] ?? '',
      total: (data['total'] as num).toDouble(),
      titular: data['titular'] ?? '',
      ultimos4: data['ultimos4'] ?? '',
      estado: data['estado'] ?? '',
      fecha: (data['fecha'] as Timestamp?)?.toDate(),
    );
  }

  bool get esAprobado => estado == 'APROBADO';
}
