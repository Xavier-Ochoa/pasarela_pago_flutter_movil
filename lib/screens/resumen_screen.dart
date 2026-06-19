import 'package:flutter/material.dart';
import '../models/producto.dart';
import 'pago_screen.dart';

class ResumenScreen extends StatelessWidget {
  final Producto producto;

  const ResumenScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    const double impuesto = 0.12;
    final double subtotal = producto.precio;
    final double ivaMonto = subtotal * impuesto;
    final double total = subtotal + ivaMonto;

    return Scaffold(
      appBar: AppBar(title: const Text('📋 Resumen del Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta del producto
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          producto.emoji,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producto.nombre,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            producto.descripcion,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Desglose de precios
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _FilaCosto('Subtotal', subtotal),
                    const Divider(height: 20),
                    _FilaCosto('IVA (12%)', ivaMonto),
                    const Divider(height: 20),
                    _FilaCosto('Total a pagar', total, esTotal: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Aviso de seguridad
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Este es un pago simulado. No se procesarán cargos reales a ninguna tarjeta.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PagoScreen(
                      producto: producto,
                      total: total,
                    ),
                  ),
                ),
                icon: const Icon(Icons.lock_outline),
                label: const Text('Proceder al Pago'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('← Cambiar producto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaCosto extends StatelessWidget {
  final String etiqueta;
  final double monto;
  final bool esTotal;

  const _FilaCosto(this.etiqueta, this.monto, {this.esTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: esTotal ? 16 : 14,
            fontWeight: esTotal ? FontWeight.bold : FontWeight.normal,
            color: esTotal ? Colors.black : Colors.grey.shade700,
          ),
        ),
        Text(
          '\$${monto.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: esTotal ? 20 : 14,
            fontWeight: esTotal ? FontWeight.w800 : FontWeight.w500,
            color: esTotal ? const Color(0xFF6C63FF) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
