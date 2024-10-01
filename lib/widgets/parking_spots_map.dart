// lib/widgets/parking_spots_map.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/screens/parking_spot_details_screen.dart';
import 'package:parkly/services/location_service.dart'; // If using user location
import 'package:location/location.dart'; // If using user location

class ParkingSpotsMap extends StatefulWidget {
  final List<ParkingSpot> parkingSpots;

  const ParkingSpotsMap({Key? key, required this.parkingSpots})
      : super(key: key);

  @override
  _ParkingSpotsMapState createState() => _ParkingSpotsMapState();
}

class _ParkingSpotsMapState extends State<ParkingSpotsMap> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  LocationService _locationService = LocationService();
  LatLng _initialPosition =
      LatLng(40.758896, -73.985130); // Default to Times Square, NY

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _determinePosition();
  }

  void _setMarkers() {
    Set<Marker> markers = widget.parkingSpots.map((spot) {
      return Marker(
        markerId: MarkerId(spot.id),
        position: LatLng(spot.latitude, spot.longitude),
        infoWindow: InfoWindow(
          title: spot.name,
          snippet: spot.address,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ParkingSpotDetailsScreen(parkingSpot: spot),
              ),
            );
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    }).toSet();

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  Future<void> _determinePosition() async {
    var locationData = await _locationService.getLocation();
    if (locationData != null) {
      setState(() {
        _initialPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
      });
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _initialPosition, zoom: 14.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        // Optionally, set a map style here
      },
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 14.0,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
    );
  }
}
