import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../screens/productos_screen.dart';
import 'historial_screen.dart';

class ResultadoScreen extends StatelessWidget {
  final String estado;
  final Producto producto;
  final double total;
  final String titular;
  final String ultimos4;

  const ResultadoScreen({
    super.key,
    required this.estado,
    required this.producto,
    required this.total,
    required this.titular,
    required this.ultimos4,
  });

  bool get esAprobado => estado == 'APROBADO';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Ícono animado
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: child,
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: esAprobado
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    border: Border.all(
                      color: esAprobado
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      esAprobado ? '✅' : '❌',
                      style: const TextStyle(fontSize: 56),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                esAprobado ? '¡Pago Aprobado!' : 'Pago Rechazado',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: esAprobado
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                esAprobado
                    ? 'Tu transacción fue procesada exitosamente.'
                    : 'No pudimos procesar tu pago. Intenta nuevamente.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),

              // Detalles de la transacción
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Detalle de la transacción',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FilaDetalle('Producto', '${producto.emoji} ${producto.nombre}'),
                      const Divider(height: 16),
                      _FilaDetalle('Titular', titular),
                      const Divider(height: 16),
                      _FilaDetalle('Tarjeta', '**** **** **** $ultimos4'),
                      const Divider(height: 16),
                      _FilaDetalle(
                        'Total',
                        '\$${total.toStringAsFixed(2)}',
                        valorDestacado: true,
                      ),
                      const Divider(height: 16),
                      _FilaDetalle(
                        'Estado',
                        estado,
                        color: esAprobado ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Aviso guardado
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cloud_done_outlined, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Transacción registrada en Firebase Firestore',
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Botones
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistorialScreen()),
                  ),
                  icon: const Icon(Icons.history),
                  label: const Text('Ver historial de pagos'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductosScreen()),
                    (route) => false,
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Volver a la tienda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilaDetalle extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final bool valorDestacado;
  final Color? color;

  const _FilaDetalle(
    this.etiqueta,
    this.valor, {
    this.valorDestacado = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          etiqueta,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: valorDestacado ? 16 : 13,
              fontWeight:
                  valorDestacado ? FontWeight.bold : FontWeight.w500,
              color: color ?? (valorDestacado ? const Color(0xFF6C63FF) : Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
