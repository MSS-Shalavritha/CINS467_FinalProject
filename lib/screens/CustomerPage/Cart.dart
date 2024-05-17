import 'package:flutter/material.dart';
import 'package:assignment_project/screens/CustomerPage/Address.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;

  const CartPage({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    // Filtering  out the items with quantity > 0
    List<Map<String, dynamic>> cartItems = menuItems.where((item) => item['quantity'] > 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.yellow[100],
      ),
      backgroundColor: Colors.yellow[100],
      body: Column(
        children: [
          Expanded(
            child: cartItems.isNotEmpty
                ? ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final menuItem = cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                        elevation: 6.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            leading: Image.network(menuItem['imageUrl'], width: 90, height: 90),
                            title: Text(menuItem['itemName']),
                            subtitle: Text('Quantity: ${menuItem['quantity']}'),
                            trailing: Text('\$${(double.parse(menuItem['price']) * menuItem['quantity']).toStringAsFixed(2)}'),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No items added to cart.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ),
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${_calculateTotal(cartItems)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black,
                  ),
                  child: Text('Add Address'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotal(List<Map<String, dynamic>> cartItems) {
    double totalAmount = 0;
    for (var menuItem in cartItems) {
      totalAmount += double.parse(menuItem['price']) * menuItem['quantity'];
    }
    return double.parse(totalAmount.toStringAsFixed(2));
  }
}
