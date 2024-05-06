// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RestaurantFormPage extends StatefulWidget {
//   const RestaurantFormPage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<RestaurantFormPage> createState() => _RestaurantFormPageState();
// }

// class _RestaurantFormPageState extends State<RestaurantFormPage> {
//   late TextEditingController nameController;
//   late TextEditingController addressController;
//   late TextEditingController phoneController;
//   late TextEditingController landmarkController;

//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController();
//     addressController = TextEditingController();
//     phoneController = TextEditingController();
//     landmarkController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     addressController.dispose();
//     phoneController.dispose();
//     landmarkController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitForm(BuildContext context) async {
//     final restaurantName = nameController.text;
//     final address = addressController.text;
//     final phone = phoneController.text;
//     final landmark = landmarkController.text;

//     try {
//       // Save restaurant details in Firestore with auto-generated ID
//       await FirebaseFirestore.instance.collection('restaurants').doc().set({
//         'restaurantName': restaurantName,
//         'address': address,
//         'phone': phone,
//         'landmark': landmark,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Restaurant details saved successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving restaurant details. Please try again later')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.yellow[100],
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Colors.yellow[100],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TextFormField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Restaurant Name',
//                 labelStyle: TextStyle(color: Colors.black),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextFormField(
//               controller: addressController,
//               decoration: InputDecoration(
//                 labelText: 'Address',
//                 labelStyle: TextStyle(color: Colors.black),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextFormField(
//               controller: phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone',
//                 labelStyle: TextStyle(color: Colors.black),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextFormField(
//               controller: landmarkController,
//               decoration: InputDecoration(
//                 labelText: 'Landmark',
//                 labelStyle: TextStyle(color: Colors.black),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () => _submitForm(context),
//               child: const Text('Save Restaurant Details'), // Updated button text
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantFormPage extends StatelessWidget {
  const RestaurantFormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: RestaurantMap(),
    );
  }
}

class RestaurantMap extends StatefulWidget {
  @override
  _RestaurantMapState createState() => _RestaurantMapState();
}

class _RestaurantMapState extends State<RestaurantMap> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433); // Initial center location

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          mapController = controller;
        });
      },
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 15.0,
      ),
      markers: {
        Marker(
          markerId: MarkerId('restaurantLocation'),
          position: _center,
          infoWindow: const InfoWindow(
            title: 'Restaurant Location',
          ),
        ),
      },
    );
  }
}

