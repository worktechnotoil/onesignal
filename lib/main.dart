import 'package:OneSignalPortal/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "One Signal Portal",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(
        title: "One Signal Portal",
      ),
    );
  }
}

