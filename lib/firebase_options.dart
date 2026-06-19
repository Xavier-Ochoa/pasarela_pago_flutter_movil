// INSTRUCCIONES PARA CONFIGURAR FIREBASE:
// CONFIGURACIÓN MANUAL COMPLETADA CON ÉXITO ✅

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Credenciales reales añadidas manualmente
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAX5qWskF1uCn_haSMQUkTDE-MJ0Wtop4w',
    appId: '1:405685947817:web:2c2cca09b341dde63cc8b8',
    messagingSenderId: '405685947817',
    projectId: 'pasarela-pago-movil',
    authDomain: 'pasarela-pago-movil.firebaseapp.com',
    storageBucket: 'pasarela-pago-movil.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAX5qWskF1uCn_haSMQUkTDE-MJ0Wtop4w',
    appId: '1:405685947817:web:2c2cca09b341dde63cc8b8',
    messagingSenderId: '405685947817',
    projectId: 'pasarela-pago-movil',
    storageBucket: 'pasarela-pago-movil.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAX5qWskF1uCn_haSMQUkTDE-MJ0Wtop4w',
    appId: '1:405685947817:web:2c2cca09b341dde63cc8b8',
    messagingSenderId: '405685947817',
    projectId: 'pasarela-pago-movil',
    storageBucket: 'pasarela-pago-movil.firebasestorage.app',
    iosBundleId: 'com.example.flutterPasarelaPago',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAX5qWskF1uCn_haSMQUkTDE-MJ0Wtop4w',
    appId: '1:405685947817:web:2c2cca09b341dde63cc8b8',
    messagingSenderId: '405685947817',
    projectId: 'pasarela-pago-movil',
    storageBucket: 'pasarela-pago-movil.firebasestorage.app',
    iosBundleId: 'com.example.flutterPasarelaPago',
  );
}