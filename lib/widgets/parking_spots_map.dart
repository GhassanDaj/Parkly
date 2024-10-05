// lib/widgets/parking_spots_map.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/widgets/booking_details_bottom_sheet.dart';

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
  BitmapDescriptor? availableIcon;
  BitmapDescriptor? bookedIcon;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
    _setMarkers();
    _determinePosition();
  }

  Future<void> _loadMarkerIcons() async {
    availableIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/icons/available_marker.png', // Ensure this asset exists
    );
    bookedIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/icons/booked_marker.png', // Ensure this asset exists
    );
    setState(() {}); // Refresh to apply custom icons
  }

  void _setMarkers() {
    Set<Marker> markers = widget.parkingSpots.map((spot) {
      return Marker(
        markerId: MarkerId(spot.id),
        position: LatLng(spot.latitude, spot.longitude),
        infoWindow: InfoWindow(
          title: spot.name,
          snippet: '\$${spot.pricePerHour}/hr',
          onTap: () {
            _showBookingDetailsBottomSheet(spot);
          },
        ),
        icon: spot.isAvailable
            ? (availableIcon ??
                BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure))
            : (bookedIcon ??
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
      );
    }).toSet();

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  Future<void> _determinePosition() async {
    // Implement your location determination logic here
  }

  void _showBookingDetailsBottomSheet(ParkingSpot spot) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BookingDetailsBottomSheet(parkingSpot: spot);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        // Optionally, set a map style here
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(40.758896, -73.985130),
        zoom: 14.0,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
    );
  }
}
