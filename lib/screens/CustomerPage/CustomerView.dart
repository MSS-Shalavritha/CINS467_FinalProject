import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment_project/screens/CustomerPage/Cart.dart';
import 'package:assignment_project/screens/CustomerPage/ViewbyRestaurants.dart';

class CustomerViewPage extends StatefulWidget {
  @override
  _CustomerViewPageState createState() => _CustomerViewPageState();
}

class _CustomerViewPageState extends State<CustomerViewPage> {
  late List<Map<String, dynamic>> menuItems = [];

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('NewUpdates').get();
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance.collection('NewUpdates').doc(doc.id).collection('Menu').get().then((menuSnapshot) {
          menuSnapshot.docs.forEach((menuDoc) {
            setState(() {
              menuItems.add({
                'restaurantID': doc.id,
                'itemID': menuDoc.id,
                'itemName': menuDoc['itemName'],
                'description': menuDoc['description'],
                'price': menuDoc['price'],
                'imageUrl': menuDoc['imageUrl'],
                'quantity': 0,
              });
            });
          });
        });
      });
    } catch (error) {
      print('Error fetching menu items: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items Available'),
        backgroundColor: Colors.yellow[100],
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () async {
              final updatedItems = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    menuItems: menuItems,
                  ),
                ),
              );
              if (updatedItems != null) {
                setState(() {
                  menuItems = updatedItems;
                });
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.yellow[100],
      body: SingleChildScrollView(
        child: Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: menuItems.map((menuItem) => _buildMenuItemCard(menuItem)).toList(),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewbyRestaurants(
                  menuItems: menuItems,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: Text(
            'View by Restaurants',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMenuItemCard(Map<String, dynamic> menuItem) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(menuItem['imageUrl'], width: double.infinity, height: 200, fit: BoxFit.cover),
            SizedBox(height: 8.0),
            Text(
              menuItem['itemName'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              menuItem['description'],
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4.0),
            Text(
              'Price: \$${menuItem['price']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (menuItem['quantity'] > 0) {
                      setState(() {
                        menuItem['quantity']--;
                      });
                    }
                  },
                ),
                Text('${menuItem['quantity']}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      menuItem['quantity']++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}