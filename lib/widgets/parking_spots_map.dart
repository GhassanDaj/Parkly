import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkly/screens/ListingDetailsScreen.dart';

class ParkingSpotsMap extends StatefulWidget {
  const ParkingSpotsMap({super.key});

  @override
  _ParkingSpotsMapState createState() => _ParkingSpotsMapState();
}

class _ParkingSpotsMapState extends State<ParkingSpotsMap> {
  final Set<Marker> _markers = {};
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _listenToParkingSpots();
  }

  // Real-time listener for Firestore collection
  void _listenToParkingSpots() {
    FirebaseFirestore.instance
        .collection('parking_spots')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _markers.clear(); // Clear old markers
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final double latitude = data['latitude'];
          final double longitude = data['longitude'];

          _markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: data['address'],
                snippet: 'Price: \$${data['price']} per hour',
              ),
              onTap: () {
                // Navigate to the listing details screen with the doc.id (the listing ID)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ListingDetailsScreen(listingId: doc.id),
                  ),
                );
              },
            ),
          );
        }
      });
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
        markers: _markers, // Display the markers
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
