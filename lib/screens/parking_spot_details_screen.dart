// lib/screens/parking_spot_details_screen.dart
import 'package:flutter/material.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/screens/booking_confirmation_screen.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Ensure this package is added
import 'package:flutter_spinkit/flutter_spinkit.dart'; // For loading indicator

class ParkingSpotDetailsScreen extends StatelessWidget {
  final ParkingSpot parkingSpot;

  const ParkingSpotDetailsScreen({Key? key, required this.parkingSpot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parkingSpot.name),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parking Spot Image
            parkingSpot.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: parkingSpot.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: SpinKitCircle(
                        color: Theme.of(context).primaryColor,
                        size: 50.0,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      height: 200,
                      child: Icon(Icons.error, size: 100, color: Colors.red),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.local_parking,
                        size: 100, color: Colors.grey[700]),
                  ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parkingSpot.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Theme.of(context).primaryColor),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          parkingSpot.address,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          color: Theme.of(context).primaryColor),
                      SizedBox(width: 5),
                      Text(
                        '${parkingSpot.pricePerHour.toStringAsFixed(2)}/hr',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Additional Details (if any)
                  // ...
                  SizedBox(height: 20),
                  // Book Now Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingConfirmationScreen(
                                parkingSpot: parkingSpot),
                          ),
                        );
                      },
                      icon: Icon(Icons.book_online),
                      label: Text('Book Now'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
