import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment_project/screens/RestaurantView/RestaurantMenu.dart'; // Import RestaurantMenuPage

class LocateRestaurant extends StatefulWidget {
  final String restaurantID;

  LocateRestaurant({required this.restaurantID});

  @override
  _LocateRestaurantState createState() => _LocateRestaurantState();
}

class _LocateRestaurantState extends State<LocateRestaurant> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(39.728493, -121.837479);
  Marker? _selectedMarker; // Variable to hold the selected marker
  String _message = ''; // Message to be displayed in the scaffold

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locate Restaurant'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to add menu page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RestaurantMenuPage(restaurantID: widget.restaurantID)),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
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
                draggable: true, // Make marker draggable
                onTap: () {
                  setState(() {
                    _selectedMarker = null;
                  });
                },
                onDragEnd: (LatLng position) {
                  // Update the marker position when dragged
                  setState(() {
                    _selectedMarker = Marker(
                      markerId: MarkerId('restaurantLocation'),
                      position: position,
                      infoWindow: const InfoWindow(
                        title: 'Restaurant Location',
                      ),
                      draggable: true,
                    );
                  });
                },
              ),
            },
            onTap: (LatLng position) {
              // Check if tap position is close to a marker
              final markerPosition = _center;
              final distance = calculateDistance(position.latitude, position.longitude, markerPosition.latitude, markerPosition.longitude);
              if (distance < 50) {
                setState(() {
                  _selectedMarker = Marker(
                    markerId: MarkerId('restaurantLocation'),
                    position: _center,
                    infoWindow: const InfoWindow(
                      title: 'Restaurant Location',
                    ),
                    draggable: true,
                  );
                });
              } else {
                setState(() {
                  _selectedMarker = null;
                });
              }
            },
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: ElevatedButton(
              onPressed: _setLocation,
              child: Text('Set Location'), // Updated button text
            ),
          ),
          if (_message.isNotEmpty)
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _setLocation() async {
    if (_selectedMarker != null) {
      double latitude = _selectedMarker!.position.latitude;
      double longitude = _selectedMarker!.position.longitude;

      print('Latitude: $latitude, Longitude: $longitude');

      try {
        // Save latitude and longitude details under the existing restaurant's ID
        await FirebaseFirestore.instance.collection('NewUpdates').doc(widget.restaurantID).update({
          'latitude': latitude,
          'longitude': longitude,
        });

        setState(() {
          _message = 'Restaurant location saved successfully!';
        });
      } catch (error) {
        setState(() {
          _message = 'Error saving restaurant location: $error';
        });
      }
    } else {
      setState(() {
        _message = 'Please select a location on the map!';
      });
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        (cos((lat2 - lat1) * p) / 2 +
            cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2);
    return 12742 * asin(sqrt(a));
  }
}
