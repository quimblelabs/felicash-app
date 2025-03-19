// firebase.dart
// import 'package:felicash/firebase_options_prod.dart' as prod;
// import 'package:felicash/firebase_options_stg.dart' as stg;
import 'package:felicash/firebase_options_dev.dart' as dev;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

Future<void> initializeFirebaseApp() async {
  // Determine which Firebase options to use based on the flavor
  final firebaseOptions = switch (appFlavor) {
    //TODO: Add production and staging options
    // 'prod' => prod.DefaultFirebaseOptions.currentPlatform,
    // 'stg' => stg.DefaultFirebaseOptions.currentPlatform,
    'development' => dev.DefaultFirebaseOptions.currentPlatform,
    _ => throw UnsupportedError('Invalid flavor: $appFlavor'),
  };
  await Firebase.initializeApp(options: firebaseOptions);
}
