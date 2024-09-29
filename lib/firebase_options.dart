// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCdu3Kd_UMPdQCCKZB3wEx8_XCYYdCdulQ',
    appId: '1:617337189541:web:91eadf9aa98da906f3c94c',
    messagingSenderId: '617337189541',
    projectId: 'parkly-42d0a',
    authDomain: 'parkly-42d0a.firebaseapp.com',
    storageBucket: 'parkly-42d0a.appspot.com',
    measurementId: 'G-0T2ZRX4D4R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxn4_QIvYH4FKzymmB6nFGL3bt9Zw4Lvo',
    appId: '1:617337189541:android:08484ffb8ec56b8df3c94c',
    messagingSenderId: '617337189541',
    projectId: 'parkly-42d0a',
    storageBucket: 'parkly-42d0a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByjYizc2ImAeGkNvVwKrkVttReAdby5zA',
    appId: '1:617337189541:ios:9b77244ee2964712f3c94c',
    messagingSenderId: '617337189541',
    projectId: 'parkly-42d0a',
    storageBucket: 'parkly-42d0a.appspot.com',
    iosBundleId: 'com.example.parkly',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByjYizc2ImAeGkNvVwKrkVttReAdby5zA',
    appId: '1:617337189541:ios:9b77244ee2964712f3c94c',
    messagingSenderId: '617337189541',
    projectId: 'parkly-42d0a',
    storageBucket: 'parkly-42d0a.appspot.com',
    iosBundleId: 'com.example.parkly',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCdu3Kd_UMPdQCCKZB3wEx8_XCYYdCdulQ',
    appId: '1:617337189541:web:182bfd19f6d09b2ef3c94c',
    messagingSenderId: '617337189541',
    projectId: 'parkly-42d0a',
    authDomain: 'parkly-42d0a.firebaseapp.com',
    storageBucket: 'parkly-42d0a.appspot.com',
    measurementId: 'G-ZV59LL65QQ',
  );
}
