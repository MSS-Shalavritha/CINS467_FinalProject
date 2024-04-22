import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Set border color here
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Set border color here
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              style: TextStyle(color: Colors.black),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Set border color here
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Set border color here
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle Forgot Password
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.black), // Set text color here
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle Login
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black;
                    }
                    return Colors.black; // Default button color
                  },
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white), // Set text color here
              ),
            ),
          ],
        ),
      ),
    );
  }
}