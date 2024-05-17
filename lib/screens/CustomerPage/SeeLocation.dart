import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SeeLocationPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const SeeLocationPage({required this.latitude, required this.longitude});

  @override
  _SeeLocationPageState createState() => _SeeLocationPageState();
}

class _SeeLocationPageState extends State<SeeLocationPage> {
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Location'),
        backgroundColor: Colors.yellow[100],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('restaurant_location'),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: InfoWindow(title: 'Restaurant Location'),
          ),
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
