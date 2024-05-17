import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment_project/screens/RestaurantView/LocateRestaurant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  File? _image;

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
              decoration: InputDecoration(
                labelText: 'Restaurant Name',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: landmarkController,
              decoration: InputDecoration(
                labelText: 'Landmark',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black,
              ),
              child: Text(_image == null ? 'Upload Image' : 'Image Uploaded'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final restaurantName = nameController.text;
                final address = addressController.text;
                final phone = phoneController.text;
                final landmark = landmarkController.text;

                try {
                  DocumentReference docRef = await FirebaseFirestore.instance.collection('NewUpdates').add({
                    'restaurantName': restaurantName,
                    'address': address,
                    'phone': phone,
                    'landmark': landmark,
                  });

                  String restaurantID = docRef.id;
                  if (_image != null) {
                    final Reference storageRef = FirebaseStorage.instance.ref().child('restaurant_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
                    final UploadTask uploadTask = storageRef.putFile(_image!);
                    final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null)!);
                    final String imageUrl = await downloadUrl.ref.getDownloadURL();
                    await docRef.update({'imageUrl': imageUrl});
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocateRestaurant(restaurantID: restaurantID)),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Restaurant details saved successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving restaurant details. Please try again later')),
                  );
                }
              },
              child: const Text('Locate on Map'),
              style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}