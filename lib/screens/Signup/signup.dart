// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(const Signup());
// }

// class Signup extends StatelessWidget {
//   const Signup({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sign up',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Sign up'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   late TextEditingController firstNameController;
//   late TextEditingController lastNameController;
//   late TextEditingController emailController;
//   late TextEditingController phoneController;
//   late TextEditingController passwordController;
//   late TextEditingController confirmPasswordController;
//   late String selectedRole = 'Customer'; // Default role
//   List<String> roles = ['Customer', 'Owner']; // Available roles

//   @override
//   void initState() {
//     super.initState();
//     firstNameController = TextEditingController(text: '');
//     lastNameController = TextEditingController(text: '');
//     emailController = TextEditingController(text: '');
//     phoneController = TextEditingController(text: '');
//     passwordController = TextEditingController(text: '');
//     confirmPasswordController = TextEditingController(text: '');
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitForm() async {
//     final firstName = firstNameController.text;
//     final lastName = lastNameController.text;
//     final email = emailController.text;
//     final phone = phoneController.text;
//     final password = passwordController.text;
//     final confirmPassword = confirmPasswordController.text;
//     final customerOrOwner = selectedRole; // Update with the selected value from the dropdown

//     if (firstName.isEmpty ||
//         lastName.isEmpty ||
//         email.isEmpty ||
//         phone.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//       return;
//     }

//     if (password != confirmPassword) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Password and Confirm Password do not match')),
//       );
//       return;
//     }

//     if (!email.contains('@') ||
//         !email.endsWith('.com') ||
//         email.indexOf('@') > email.lastIndexOf('.com')) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Invalid email format')),
//       );
//       return;
//     }

//     if (phone.length != 10 || int.tryParse(phone) == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Phone number must be a 10-digit integer')),
//       );
//       return;
//     }

//     try {
//       // Query Firestore to check if the email already exists
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('Signup')
//           .where('Email', isEqualTo: email)
//           .get();

//       // If the query snapshot is not empty, it means the email already exists
//       if (querySnapshot.docs.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('This email is already registered. Please use a different email.')),
//         );
//         return;
//       }

//       // If the email doesn't exist, proceed to register the user
//       await FirebaseFirestore.instance.collection('Signup').add(<String, dynamic>{
//         'FirstName': firstName,
//         'LastName': lastName,
//         'Email': email,
//         'Phone': phone,
//         'Password': password,
//         'ConfirmPassword': confirmPassword,
//         'CustomerorOwner': customerOrOwner,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User registered successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error registering user. Please try again later')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 controller: firstNameController,
//                 decoration: const InputDecoration(labelText: 'First Name'),
//               ),
//               TextField(
//                 controller: lastNameController,
//                 decoration: const InputDecoration(labelText: 'Last Name'),
//               ),
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//               ),
//               TextField(
//                 controller: phoneController,
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               TextField(
//                 controller: confirmPasswordController,
//                 decoration: const InputDecoration(labelText: 'Confirm Password'),
//                 obscureText: true,
//               ),
//               DropdownButtonFormField<String>(
//                 value: selectedRole,
//                 onChanged: (String? value) {
//                   if (value != null) {
//                     setState(() {
//                       selectedRole = value;
//                     });
//                   }
//                 },
//                 items: roles.map((String role) {
//                   return DropdownMenuItem<String>(
//                     value: role,
//                     child: Text(role),
//                   );
//                 }).toList(),
//                 decoration: const InputDecoration(labelText: 'Customer or Owner?'),
//               ),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: Colors.yellow[100],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const Signup());
}

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Sign up'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back when the arrow button is pressed
            },
          ),
        ),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late String selectedRole = 'Customer';
  List<String> roles = ['Customer', 'Owner'];

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final phone = phoneController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final customerOrOwner = selectedRole;

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('signup').doc(userCredential.user!.uid).set({
        'UID': userCredential.user!.uid,
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
        SnackBar(content: Text('Error registering user. Please try again later')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16.0),
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedRole = value;
                      });
                    }
                  },
                  items: roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Customer or Owner?'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                 onPressed: _submitForm,
                 style: ButtonStyle(
                 backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // Set button color to black
                 ),
                child: Text(
                'Submit',
                style: TextStyle(color: Colors.white), // Set text color to white
                ),
               ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.yellow[100],
    );
  }
}
