import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDeV24UJKbuDNoj09sn6xbB-w-fZahGu9k",
            authDomain: "ondc-409004.firebaseapp.com",
            projectId: "ondc-409004",
            storageBucket: "ondc-409004.appspot.com",
            messagingSenderId: "543063414981",
            appId: "1:543063414981:web:112308af101952b15878ac",
            measurementId: "G-JFS06NTRBX"));
  } else {
    await Firebase.initializeApp();
  }
}
