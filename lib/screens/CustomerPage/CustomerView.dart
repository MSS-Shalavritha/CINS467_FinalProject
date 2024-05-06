import 'package:flutter/material.dart';

class CustomerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Customer View'),
        ),
        body: Center(
          child: Text(
            'Welcome to Customer View!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}