class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String descripcion;
  final String emoji;

  const Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.emoji,
  });
}

final List<Producto> productos = [
  Producto(
    id: 'p1',
    nombre: 'Audífonos Bluetooth',
    precio: 25.00,
    descripcion: 'Sonido HD inalámbrico · 20h batería',
    emoji: '🎧',
  ),
  Producto(
    id: 'p2',
    nombre: 'Teclado Mecánico',
    precio: 45.00,
    descripcion: 'RGB retroiluminado · Switches azules',
    emoji: '⌨️',
  ),
  Producto(
    id: 'p3',
    nombre: 'Mouse Gamer',
    precio: 30.00,
    descripcion: '16000 DPI · 6 botones programables',
    emoji: '🖱️',
  ),
  Producto(
    id: 'p4',
    nombre: 'Webcam HD',
    precio: 38.00,
    descripcion: '1080p Full HD · Micrófono integrado',
    emoji: '📷',
  ),
  Producto(
    id: 'p5',
    nombre: 'Hub USB-C',
    precio: 20.00,
    descripcion: '7 puertos · HDMI 4K · carga rápida',
    emoji: '🔌',
  ),
  Producto(
    id: 'p6',
    nombre: 'Mousepad XL',
    precio: 15.00,
    descripcion: 'Superficie de tela · Base antideslizante',
    emoji: '🖥️',
  ),
];
