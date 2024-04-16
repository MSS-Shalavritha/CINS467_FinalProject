import 'package:assignment_project/screens/Login/LoginPage.dart';
import 'package:flutter/material.dart';
// import 'package:finalproject/screens/screens.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}


