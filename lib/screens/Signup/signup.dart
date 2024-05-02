import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const Signup());
}

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign up',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sign up'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController customerorownerController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: '');
    lastNameController = TextEditingController(text: '');
    emailController = TextEditingController(text: '');
    phoneController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');
    customerorownerController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    customerorownerController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
  final firstName = firstNameController.text;
  final lastName = lastNameController.text;
  final email = emailController.text;
  final phone = phoneController.text;
  final password = passwordController.text;
  final confirmPassword = confirmPasswordController.text;
  final customerOrOwner = customerorownerController.text;

  if (firstName.isEmpty ||
      lastName.isEmpty ||
      email.isEmpty ||
      phone.isEmpty ||
      password.isEmpty ||
      confirmPassword.isEmpty ||
      customerOrOwner.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password and Confirm Password do not match')),
    );
    return;
  }

  if (!email.contains('@') || !email.endsWith('.com') || email.indexOf('@') > email.lastIndexOf('.com')) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid email format')),
    );
    return;
  }

  if (phone.length != 10 || int.tryParse(phone) == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Phone number must be a 10-digit integer')),
    );
    return;
  }

  try {
    // Query Firestore to check if the email already exists
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Signup')
        .where('Email', isEqualTo: email)
        .get();

    // If the query snapshot is not empty, it means the email already exists
    if (querySnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This email is already registered. Please use a different email.')),
      );
      return;
    }

    // If the email doesn't exist, proceed to register the user
    await FirebaseFirestore.instance.collection('Signup').add(<String, dynamic>{
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Phone': phone,
      'Password': password,
      'ConfirmPassword': confirmPassword,
      'CustomerorOwner': customerOrOwner,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User registered successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error registering user. Please try again later')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              TextField(
                controller: customerorownerController,
                decoration: const InputDecoration(labelText: 'Customer or Owner?'),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.yellow[100],
    );
  }
}
