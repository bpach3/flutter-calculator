import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCr6t2BC0-OOjyIAF4L8YcN3jp1y11Q95M",
            authDomain: "todo-7hairz.firebaseapp.com",
            projectId: "todo-7hairz",
            storageBucket: "todo-7hairz.firebasestorage.app",
            messagingSenderId: "742055496312",
            appId: "1:742055496312:web:53221eafbb21b73a9b7b8d",
            measurementId: "G-VQ6B6DKDZ1"));
  } else {
    await Firebase.initializeApp();
  }
}
