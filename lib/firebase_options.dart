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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCbNohO3V8y8EvChE3MkWDagsfcBAejym4',
    appId: '1:868714330637:web:bc3fffd5f3c639cdb97344',
    messagingSenderId: '868714330637',
    projectId: 'hackathon-baa36',
    authDomain: 'hackathon-baa36.firebaseapp.com',
    storageBucket: 'hackathon-baa36.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAk8lpxalqgAdWKFZQC8uDyhLSudnWzSdg',
    appId: '1:868714330637:android:9e5b26d913dfbdabb97344',
    messagingSenderId: '868714330637',
    projectId: 'hackathon-baa36',
    storageBucket: 'hackathon-baa36.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZF5kg5pdI2hSqkbq1f9AnN__wwaOEKbk',
    appId: '1:868714330637:ios:ae4bd42f927f8df4b97344',
    messagingSenderId: '868714330637',
    projectId: 'hackathon-baa36',
    storageBucket: 'hackathon-baa36.appspot.com',
    iosClientId: '868714330637-vgjd05jnr69v2125sa9c9kl7ms8r1j5q.apps.googleusercontent.com',
    iosBundleId: 'com.example.hackathon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZF5kg5pdI2hSqkbq1f9AnN__wwaOEKbk',
    appId: '1:868714330637:ios:ae4bd42f927f8df4b97344',
    messagingSenderId: '868714330637',
    projectId: 'hackathon-baa36',
    storageBucket: 'hackathon-baa36.appspot.com',
    iosClientId: '868714330637-vgjd05jnr69v2125sa9c9kl7ms8r1j5q.apps.googleusercontent.com',
    iosBundleId: 'com.example.hackathon',
  );
}
