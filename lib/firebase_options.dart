// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return web;
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
    apiKey: 'AIzaSyClV9HdxVD_-cFu0pVQBb_u0x5v9NudMYc',
    appId: '1:930921923522:web:74d4d8300181df02dd0c5b',
    messagingSenderId: '930921923522',
    projectId: 'jamanacanal',
    authDomain: 'jamanacanal.firebaseapp.com',
    storageBucket: 'jamanacanal.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4g58Sw_2b9Nta0rdoVY6R103JVnGOQXU',
    appId: '1:930921923522:android:0cdde7a0f64d7860dd0c5b',
    messagingSenderId: '930921923522',
    projectId: 'jamanacanal',
    storageBucket: 'jamanacanal.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBRCVzCNbGWiHAqEtCZqsC6WITiKBS1pI',
    appId: '1:930921923522:ios:a816e65c9a1ef83edd0c5b',
    messagingSenderId: '930921923522',
    projectId: 'jamanacanal',
    storageBucket: 'jamanacanal.appspot.com',
    iosBundleId: 'com.example.jamanacanal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDBRCVzCNbGWiHAqEtCZqsC6WITiKBS1pI',
    appId: '1:930921923522:ios:9e906f28612af8c0dd0c5b',
    messagingSenderId: '930921923522',
    projectId: 'jamanacanal',
    storageBucket: 'jamanacanal.appspot.com',
    iosBundleId: 'com.example.jamanacanal.RunnerTests',
  );
}
