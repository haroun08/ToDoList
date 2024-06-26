import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './SignInPage.dart';
import './SignUpPage.dart';
import './home.dart';
import './DateTimePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      projectId: 'e-business-80787',
      apiKey: 'AIzaSyDy3cOJNE-tY_VuTZbFwiuRSvVxAPgUEGE',
      appId: '1:400898808343:android:219d64944f701aba4fda52',
      messagingSenderId: '400898808343',
      storageBucket: 'e-business-80787.appspot.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/SignInPage': (context) => SignInPage(),
        '/SignUpPage': (context) => SignUpPage(),
        '/signUp': (context) => SignUpPage(),
        '/DateTimePage': (context) => DateTimePage(),
      },
    );
  }
}
