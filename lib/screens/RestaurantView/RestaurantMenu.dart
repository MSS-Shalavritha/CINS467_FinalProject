import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:assignment_project/screens/HomePage/HomePage.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantMenuPage extends StatefulWidget {
  final String restaurantID;

  const RestaurantMenuPage({Key? key, required this.restaurantID}) : super(key: key);

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  late TextEditingController itemNumberController;
  late TextEditingController itemNameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  File? _image;

  @override
  void initState() {
    super.initState();
    itemNumberController = TextEditingController();
    itemNameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  void dispose() {
    itemNumberController.dispose();
    itemNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.yellow[100],
    appBar: AppBar(
      title: Text('Add Menu Item'),
      backgroundColor: Colors.yellow[100],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: itemNumberController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Item Number',
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: itemNameController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Item Name',
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: descriptionController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: priceController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Price',
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _uploadImage,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.black;
                  }
                  return Colors.black;
                },
              ),
            ),
            child: Text(
              'Upload Image',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 16.0),
          _image != null
              ? Image.file(
                  _image!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
              : Container(),
          SizedBox(height: 16.0),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _addMenuItem();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black;
                      }
                      return Colors.black;
                    },
                  ),
                ),
                child: Text(
                  'Add More',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black;
                      }
                      return Colors.black;
                    },
                  ),
                ),
                child: Text(
                  'Complete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
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

  void _addMenuItem() async {
    final itemNumber = itemNumberController.text;
    final itemName = itemNameController.text;
    final description = descriptionController.text;
    final price = priceController.text;

    try {
      if (_image != null) {
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('menu_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final UploadTask uploadTask = storageRef.putFile(_image!);
        final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null)!);
        final String url = await downloadUrl.ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('NewUpdates').doc(widget.restaurantID).collection('Menu').add({
          'itemNumber': itemNumber,
          'itemName': itemName,
          'description': description,
          'price': price,
          'imageUrl': url,
        });
      } else {
        await FirebaseFirestore.instance.collection('NewUpdates').doc(widget.restaurantID).collection('Menu').add({
          'itemNumber': itemNumber,
          'itemName': itemName,
          'description': description,
          'price': price,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu item added successfully')),
      );
      itemNumberController.clear();
      itemNameController.clear();
      descriptionController.clear();
      priceController.clear();
      setState(() {
        _image = null;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding menu item: $error')),
      );
    }
  }
}
