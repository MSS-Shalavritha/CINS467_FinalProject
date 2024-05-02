import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  // Create an instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _loginUser(BuildContext context, String email, String password) async {
    try {
      // Sign in the user with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Display a success message if login is successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );
    } catch (e) {
      // Display an error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login. Please check your credentials.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
              controller: emailController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.black),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle Forgot Password
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Call the login function with entered email and password
                _loginUser(context, emailController.text, passwordController.text);
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
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
