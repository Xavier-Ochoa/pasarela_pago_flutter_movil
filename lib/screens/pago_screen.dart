import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/producto.dart';
import '../services/firebase_service.dart';
import 'resultado_screen.dart';

class PagoScreen extends StatefulWidget {
  final Producto producto;
  final double total;

  const PagoScreen({super.key, required this.producto, required this.total});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titularCtrl = TextEditingController();
  final _tarjetaCtrl = TextEditingController();
  final _expiracionCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _procesando = false;
  bool _mostrarCvv = false;

  @override
  void dispose() {
    _titularCtrl.dispose();
    _tarjetaCtrl.dispose();
    _expiracionCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  String _formatearTarjeta(String value) {
    final digits = value.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  Future<void> _procesarPago() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _procesando = true);

    try {
      // Simular delay de procesamiento
      await Future.delayed(const Duration(seconds: 2));

      // Simular resultado
      final estado = FirebaseService.simularPago();

      // Guardar en Firestore (solo últimos 4 dígitos, sin CVV)
      await FirebaseService.guardarPago(
        producto: widget.producto.nombre,
        total: widget.total,
        titular: _titularCtrl.text.trim(),
        tarjeta: _tarjetaCtrl.text.replaceAll(' ', ''),
        estado: estado,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultadoScreen(
            estado: estado,
            producto: widget.producto,
            total: widget.total,
            titular: _titularCtrl.text.trim(),
            ultimos4: _tarjetaCtrl.text
                .replaceAll(' ', '')
                .substring(_tarjetaCtrl.text.replaceAll(' ', '').length - 4),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al procesar el pago: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💳 Datos de Pago')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen mini
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF9C97FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(widget.producto.emoji,
                        style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.producto.nombre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Total: \$${widget.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${widget.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Aviso de seguridad
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.amber.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '⚠️ Simulación: No ingreses datos reales de tarjeta.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Información de pago',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Nombre del titular
              TextFormField(
                controller: _titularCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del titular *',
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Ej: Juan Pérez',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre del titular es obligatorio';
                  }
                  if (value.trim().length < 3) {
                    return 'Ingresa el nombre completo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Número de tarjeta
              TextFormField(
                controller: _tarjetaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta *',
                  prefixIcon: Icon(Icons.credit_card),
                  hintText: '0000 0000 0000 0000',
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                maxLength: 19, // 16 dígitos + 3 espacios
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text.replaceAll(' ', '');
                    if (text.length > 16) {
                      return oldValue;
                    }
                    final formatted = _formatearTarjeta(text);
                    return TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El número de tarjeta es obligatorio';
                  }
                  final digits = value.replaceAll(' ', '');
                  if (digits.length < 16) {
                    return 'Debe tener 16 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Expiración y CVV en fila
              Row(
                children: [
                  // Fecha de expiración
                  Expanded(
                    child: TextFormField(
                      controller: _expiracionCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Expiración *',
                        prefixIcon: Icon(Icons.date_range_outlined),
                        hintText: 'MM/AA',
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          var text = newValue.text.replaceAll('/', '');
                          if (text.length > 4) text = text.substring(0, 4);
                          if (text.length >= 2) {
                            text = '${text.substring(0, 2)}/${text.substring(2)}';
                          }
                          return TextEditingValue(
                            text: text,
                            selection: TextSelection.collapsed(
                              offset: text.length,
                            ),
                          );
                        }),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatoria';
                        }
                        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                          return 'Formato MM/AA';
                        }
                        final parts = value.split('/');
                        final mes = int.tryParse(parts[0]) ?? 0;
                        if (mes < 1 || mes > 12) {
                          return 'Mes inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // CVV
                  Expanded(
                    child: TextFormField(
                      controller: _cvvCtrl,
                      decoration: InputDecoration(
                        labelText: 'CVV *',
                        prefixIcon: const Icon(Icons.lock_outline),
                        counterText: '',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _mostrarCvv
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _mostrarCvv = !_mostrarCvv),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      obscureText: !_mostrarCvv,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatorio';
                        }
                        if (value.length != 3) {
                          return '3 dígitos';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nota de privacidad
              Text(
                '🔒 Tus datos están protegidos. Solo guardamos los últimos 4 dígitos de tu tarjeta. El CVV nunca se almacena.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 28),

              // Botón pagar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _procesando ? null : _procesarPago,
                  child: _procesando
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Procesando pago...'),
                          ],
                        )
                      : const Text('💳 Pagar ahora'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
