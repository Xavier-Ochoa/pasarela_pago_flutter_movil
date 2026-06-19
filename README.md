# Flutter Pasarela de Pago

Aplicacion movil desarrollada en Flutter que simula el flujo de una pasarela de pago, con registro de transacciones en Firebase Firestore.

## Descripcion

Este proyecto es una simulacion educativa de un proceso de pago en linea. El usuario selecciona un producto, revisa el resumen de su compra, ingresa datos de una tarjeta (ficticios) y obtiene un resultado de aprobacion o rechazo. Cada transaccion queda registrada en una base de datos en tiempo real y puede consultarse en un historial.

La aplicacion no procesa pagos reales ni se conecta a ninguna entidad bancaria.

## Flujo de la aplicacion

| Paso | Pantalla   | Descripcion                                    |
|------|------------|-------------------------------------------------|
| 1    | Productos  | Seleccion de un producto del catalogo           |
| 2    | Resumen    | Desglose del precio con impuesto incluido       |
| 3    | Pago       | Formulario de datos de tarjeta con validaciones |
| 4    | Resultado  | Estado de la transaccion: aprobado o rechazado  |
| 5    | Historial  | Listado de transacciones registradas en Firebase |

## Requisitos previos

- Flutter SDK instalado (version compatible con Dart >=3.0.0)
- Una cuenta de Firebase
- Firebase CLI y FlutterFire CLI

## Configuracion del proyecto

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd flutter_pasarela_pago
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar Firebase

Instalar las herramientas necesarias:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

Iniciar sesion y configurar el proyecto:

```bash
firebase login
flutterfire configure
```

Este comando genera automaticamente los archivos `lib/firebase_options.dart` y `android/app/google-services.json` con las credenciales del proyecto de Firebase.

### 4. Configurar Firestore

1. Ingresar a [Firebase Console](https://console.firebase.google.com)
2. Seleccionar el proyecto y abrir Firestore Database
3. Crear la base de datos en modo de prueba
4. La coleccion `pagos_simulados` se crea automaticamente al registrar el primer pago

Reglas de Firestore sugeridas para entornos de desarrollo:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

Estas reglas permiten acceso sin restricciones y deben usarse unicamente con fines de desarrollo o pruebas, nunca en produccion.

### 5. Ejecutar la aplicacion

```bash
flutter run
```

## Estructura del proyecto

```
lib/
├── main.dart                    Punto de entrada e inicializacion de Firebase
├── firebase_options.dart        Configuracion de Firebase generada por FlutterFire
├── models/
│   ├── producto.dart            Modelo de producto y catalogo
│   └── pago_simulado.dart       Modelo de pago y su conversion a Firestore
├── services/
│   └── firebase_service.dart    Logica de guardado y consulta de pagos
└── screens/
    ├── productos_screen.dart    Catalogo de productos
    ├── resumen_screen.dart      Resumen de la compra
    ├── pago_screen.dart         Formulario de pago con validaciones
    ├── resultado_screen.dart    Resultado de la transaccion
    └── historial_screen.dart    Historial de transacciones en tiempo real
```

## Validaciones del formulario de pago

- Nombre del titular obligatorio, con un minimo de tres caracteres
- Numero de tarjeta obligatorio, de dieciseis digitos, con formato automatico en grupos de cuatro
- Fecha de expiracion obligatoria, en formato MM/AA, con validacion de mes
- Codigo CVV obligatorio, de exactamente tres digitos
- El numero completo de la tarjeta y el CVV no se almacenan en ningun momento
- Solo se registran el producto, el monto total, el nombre del titular, los ultimos cuatro digitos de la tarjeta, el estado de la transaccion y la fecha

## Datos almacenados en Firestore

Coleccion: `pagos_simulados`

| Campo     | Tipo      | Descripcion                                  |
|-----------|-----------|-----------------------------------------------|
| producto  | string    | Nombre del producto seleccionado              |
| total     | number    | Monto total incluyendo impuesto               |
| titular   | string    | Nombre del titular de la tarjeta               |
| ultimos4  | string    | Ultimos cuatro digitos de la tarjeta           |
| estado    | string    | Resultado de la transaccion: APROBADO o RECHAZADO |
| fecha     | timestamp | Fecha y hora del servidor                      |

## Dependencias principales

| Paquete         | Version  | Proposito                          |
|-----------------|----------|-------------------------------------|
| firebase_core   | ^2.24.2  | Inicializacion de Firebase          |
| cloud_firestore | ^4.14.0  | Base de datos Firestore             |
| intl            | ^0.19.0  | Formateo de fechas                  |
| google_fonts    | ^6.1.0   | Tipografia personalizada            |

## Aviso

Esta aplicacion tiene fines educativos y de demostracion. No procesa pagos reales, no se conecta a ninguna red de tarjetas ni entidad financiera, y el resultado de cada transaccion se determina de forma aleatoria.

## Licencia

Este proyecto se distribuye sin una licencia especifica. Si se desea reutilizar el codigo, se recomienda agregar un archivo LICENSE acorde a las necesidades del autor.
