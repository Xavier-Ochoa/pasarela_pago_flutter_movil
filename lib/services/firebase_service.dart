import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pago_simulado.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _coleccion = 'pagos_simulados';

  /// Simula el resultado del pago (aprobado/rechazado aleatoriamente)
  static String simularPago() {
    final aprobado = Random().nextBool();
    return aprobado ? 'APROBADO' : 'RECHAZADO';
  }

  /// Guarda un pago simulado en Firestore
  /// ⚠️ SEGURIDAD: Solo guarda los últimos 4 dígitos, NUNCA el número completo ni el CVV
  static Future<void> guardarPago({
    required String producto,
    required double total,
    required String titular,
    required String tarjeta,   // solo se usarán los últimos 4 dígitos
    required String estado,
  }) async {
    final pago = PagoSimulado(
      producto: producto,
      total: total,
      titular: titular,
      // Seguridad: guardar SOLO los últimos 4 dígitos
      ultimos4: tarjeta.replaceAll(' ', '').substring(
        tarjeta.replaceAll(' ', '').length - 4,
      ),
      estado: estado,
    );

    await _db.collection(_coleccion).add(pago.toFirestore());
  }

  /// Obtiene el historial de pagos ordenado por fecha descendente
  static Stream<List<PagoSimulado>> streamHistorial() {
    return _db
        .collection(_coleccion)
        .orderBy('fecha', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PagoSimulado.fromFirestore(doc))
              .toList(),
        );
  }

  /// Obtiene los pagos una sola vez (sin stream)
  static Future<List<PagoSimulado>> obtenerHistorial() async {
    final snapshot = await _db
        .collection(_coleccion)
        .orderBy('fecha', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => PagoSimulado.fromFirestore(doc))
        .toList();
  }
}
