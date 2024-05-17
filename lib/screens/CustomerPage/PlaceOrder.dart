import 'package:flutter/material.dart';

class PlaceOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: Text('Place Order'),
        backgroundColor: Colors.yellow[100],
      ),
      body: Center(
        child: Text(
          'Your order is placed successfully',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
