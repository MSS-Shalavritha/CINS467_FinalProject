import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow),
      // ),
      home: const RestaurantFormPage(title: 'Restaurant Information'),
    );
  }
}

class RestaurantFormPage extends StatefulWidget {
  const RestaurantFormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RestaurantFormPage> createState() => _RestaurantFormPageState();
}

class _RestaurantFormPageState extends State<RestaurantFormPage> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController landmarkController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    landmarkController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.yellow[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Restaurant Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: landmarkController,
              decoration: const InputDecoration(
                labelText: 'Landmark',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle form submission here
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
