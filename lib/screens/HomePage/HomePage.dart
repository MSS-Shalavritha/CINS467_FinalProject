import 'package:flutter/material.dart';
import 'package:assignment_project/screens/Login/LoginPage.dart';
import 'package:assignment_project/screens/Signup/signup.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Delivery App'),
      ),
      body: Stack(
        children: [
          // Background Image Container
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/istockphoto-1295633127-1024x1024.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content Centered on the Screen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: Text('Signup'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
