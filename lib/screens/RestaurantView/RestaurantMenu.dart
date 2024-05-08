import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(
        title: Text('Add Menu Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: itemNumberController,
              decoration: InputDecoration(
                labelText: 'Item Number',
              ),
            ),
            TextFormField(
              controller: itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add menu item to Firestore
                    _addMenuItem();
                  },
                  child: Text('Add More'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Complete menu addition process
                    // You can navigate to another screen or perform any other action here
                  },
                  child: Text('Complete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addMenuItem() async {
    final itemNumber = itemNumberController.text;
    final itemName = itemNameController.text;
    final description = descriptionController.text;
    final price = priceController.text;

    try {
      // Save menu item details in Firestore under the restaurant's ID
      await FirebaseFirestore.instance.collection('NewUpdates').doc(widget.restaurantID).collection('Menu').add({
        'itemNumber': itemNumber,
        'itemName': itemName,
        'description': description,
        'price': price,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu item added successfully')),
      );

      // Clear text fields for the next item
      itemNumberController.clear();
      itemNameController.clear();
      descriptionController.clear();
      priceController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding menu item: $error')),
      );
    }
  }
}
