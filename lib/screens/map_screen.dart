import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingSpotsMap extends StatefulWidget {
  const ParkingSpotsMap({super.key});

  @override
  _ParkingSpotsMapState createState() => _ParkingSpotsMapState();
}

class _ParkingSpotsMapState extends State<ParkingSpotsMap> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchParkingSpots();
  }

  // Fetch parking spots from Firebase Firestore
  Future<void> _fetchParkingSpots() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('parking_spots').get();
    setState(() {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        _markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(data['latitude'], data['longitude']),
            infoWindow: InfoWindow(
              title: data['address'],
              snippet: 'Price: \$${data['price']} per hour',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Parking Spots'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(43.651070, -79.347015), // Example: Toronto coordinates
          zoom: 14.0,
        ),
        markers: _markers,
      ),
    );
  }
}
