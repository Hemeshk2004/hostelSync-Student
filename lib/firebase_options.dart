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
    apiKey: 'AIzaSyDxmXpSENLjR9qMc0GVbXInkEh9CvPXg6A',
    appId: '1:837634161833:web:ed5e9341c60033faa23db8',
    messagingSenderId: '837634161833',
    projectId: 'hostelsync-ab179',
    authDomain: 'hostelsync-ab179.firebaseapp.com',
    storageBucket: 'hostelsync-ab179.firebasestorage.app',
    measurementId: 'G-JXVT2E6RPB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTLeX6Rf3ys57KXZMUOZhdLcQxNuFq_2w',
    appId: '1:837634161833:android:43bd73032952f625a23db8',
    messagingSenderId: '837634161833',
    projectId: 'hostelsync-ab179',
    storageBucket: 'hostelsync-ab179.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5qb9Qbl9DZpAEUAK_IC8ni9RK0I_WoA8',
    appId: '1:837634161833:ios:d084607c9dcf440fa23db8',
    messagingSenderId: '837634161833',
    projectId: 'hostelsync-ab179',
    storageBucket: 'hostelsync-ab179.firebasestorage.app',
    iosClientId: '837634161833-mohb59d22glsrbaq2h9rbg4tequg2nsr.apps.googleusercontent.com',
    iosBundleId: 'com.example.hostelsync',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5qb9Qbl9DZpAEUAK_IC8ni9RK0I_WoA8',
    appId: '1:837634161833:ios:d084607c9dcf440fa23db8',
    messagingSenderId: '837634161833',
    projectId: 'hostelsync-ab179',
    storageBucket: 'hostelsync-ab179.firebasestorage.app',
    iosClientId: '837634161833-mohb59d22glsrbaq2h9rbg4tequg2nsr.apps.googleusercontent.com',
    iosBundleId: 'com.example.hostelsync',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDxmXpSENLjR9qMc0GVbXInkEh9CvPXg6A',
    appId: '1:837634161833:web:d532d493e30eae7ba23db8',
    messagingSenderId: '837634161833',
    projectId: 'hostelsync-ab179',
    authDomain: 'hostelsync-ab179.firebaseapp.com',
    storageBucket: 'hostelsync-ab179.firebasestorage.app',
    measurementId: 'G-X9ZW9MGWR8',
  );

}