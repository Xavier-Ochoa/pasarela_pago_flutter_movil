import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pago_simulado.dart';
import '../services/firebase_service.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Historial de Pagos'),
      ),
      body: StreamBuilder<List<PagoSimulado>>(
        stream: FirebaseService.streamHistorial(),
        builder: (context, snapshot) {
          // Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando historial...'),
                ],
              ),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar el historial',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }

          final pagos = snapshot.data ?? [];

          // Sin datos
          if (pagos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📭', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  Text(
                    'Sin transacciones aún',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Los pagos simulados aparecerán aquí.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // Estadísticas
          final aprobados = pagos.where((p) => p.esAprobado).length;
          final rechazados = pagos.length - aprobados;
          final totalMonto = pagos
              .where((p) => p.esAprobado)
              .fold(0.0, (sum, p) => sum + p.total);

          return Column(
            children: [
              // Resumen estadístico
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF9C97FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _StatCard('Total', '${pagos.length}', Icons.receipt_long),
                    _Divider(),
                    _StatCard('Aprobados', '$aprobados', Icons.check_circle_outline,
                        color: Colors.greenAccent),
                    _Divider(),
                    _StatCard('Rechazados', '$rechazados', Icons.cancel_outlined,
                        color: Colors.redAccent.shade100),
                    _Divider(),
                    _StatCard('Monto', '\$${totalMonto.toStringAsFixed(0)}',
                        Icons.attach_money),
                  ],
                ),
              ),

              // Lista
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: pagos.length,
                  itemBuilder: (context, index) {
                    final pago = pagos[index];
                    return _TarjetaPago(pago: pago);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color? color;

  const _StatCard(this.titulo, this.valor, this.icono, {this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icono, color: color ?? Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(
              color: color ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            titulo,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      color: Colors.white24,
    );
  }
}

class _TarjetaPago extends StatelessWidget {
  final PagoSimulado pago;

  const _TarjetaPago({required this.pago});

  @override
  Widget build(BuildContext context) {
    final fecha = pago.fecha;
    final fechaStr = fecha != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(fecha)
        : 'Fecha no disponible';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Indicador de estado
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: pago.esAprobado
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  pago.esAprobado ? '✅' : '❌',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Datos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pago.producto,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${pago.titular} · **** ${pago.ultimos4}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fechaStr,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            // Monto y estado
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${pago.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: pago.esAprobado
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pago.estado,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: pago.esAprobado
                          ? Colors.green.shade800
                          : Colors.red.shade800,
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
