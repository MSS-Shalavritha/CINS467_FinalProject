import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment_project/screens/CustomerPage/Cart.dart';
import 'package:assignment_project/screens/CustomerPage/SeeLocation.dart';

class ViewbyRestaurants extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;
  ViewbyRestaurants({required this.menuItems});

  @override
  _ViewbyRestaurantsState createState() => _ViewbyRestaurantsState();
}


class _ViewbyRestaurantsState extends State<ViewbyRestaurants> {
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
                'latitude': doc['latitude'],
                'longitude': doc['longitude'],
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

  void updateMenuItem(Map<String, dynamic> updatedMenuItem) {
    setState(() {
      int index = menuItems.indexWhere((item) => item['itemID'] == updatedMenuItem['itemID']);
      if (index != -1) {
        menuItems[index] = updatedMenuItem;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View by Restaurants'),
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
      body: RestaurantList(menuItems: menuItems, updateMenuItem: updateMenuItem),
    );
  }
}

class RestaurantList extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;
  final Function(Map<String, dynamic>) updateMenuItem;

  const RestaurantList({required this.menuItems, required this.updateMenuItem});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('NewUpdates').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantDetailsPage(restaurantId: document.id, menuItems: menuItems, updateMenuItem: updateMenuItem)),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        data['restaurantName'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4.0),
                          Text(
                            data['address'],
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8.0),
                          Image.network(
                            data['imageUrl'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeeLocationPage(
                                latitude: data['latitude'],
                                longitude: data['longitude'],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.black,
                        ),
                        child: Text('See Location'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;
  final List<Map<String, dynamic>> menuItems;
  final Function(Map<String, dynamic>) updateMenuItem;

  const RestaurantDetailsPage({required this.restaurantId, required this.menuItems, required this.updateMenuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Details'),
        backgroundColor: Colors.yellow[100],
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    menuItems: menuItems,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.yellow[100],
      body: RestaurantMenuList(restaurantId: restaurantId, updateMenuItem: updateMenuItem),
    );
  }
}

class RestaurantMenuList extends StatefulWidget {
  final String restaurantId;
  final Function(Map<String, dynamic>) updateMenuItem;

  const RestaurantMenuList({required this.restaurantId, required this.updateMenuItem});

  @override
  _RestaurantMenuListState createState() => _RestaurantMenuListState();
}

class _RestaurantMenuListState extends State<RestaurantMenuList> {
  late List<Map<String, dynamic>> menuItems = [];

  @override
  void initState() {
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('NewUpdates')
          .doc(widget.restaurantId)
          .collection('Menu')
          .get();

      querySnapshot.docs.forEach((doc) {
        setState(() {
          menuItems.add({
            'restaurantID': widget.restaurantId,
            'itemID': doc.id,
            'itemName': doc['itemName'],
            'description': doc['description'],
            'price': doc['price'],
            'imageUrl': doc['imageUrl'],
            'quantity': 0,
          });
        });
      });
    } catch (error) {
      print('Error fetching menu items: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: menuItems.map((menuItem) => _buildMenuItemCard(menuItem)).toList(),
      ),
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
                    setState(() {
                      if (menuItem['quantity'] > 0) {
                        menuItem['quantity']--;
                        widget.updateMenuItem(menuItem);
                      }
                    });
                  },
                ),
                Text('${menuItem['quantity']}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      menuItem['quantity']++;
                      widget.updateMenuItem(menuItem);
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