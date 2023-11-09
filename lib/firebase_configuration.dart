import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

Future<FirebaseApp> initializeFirebase({required FirebaseOptions options}) async {
  if (kIsWeb) {
    return Firebase.initializeApp();
  } else {
    return Firebase.initializeApp(options: options);
  }
}
