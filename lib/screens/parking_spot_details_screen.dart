// screens/parking_spot_details_screen.dart
import 'package:flutter/material.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/screens/booking_confirmation_screen.dart';

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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(parkingSpot.address, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                'Price per hour: \$${parkingSpot.pricePerHour.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Book Now'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookingConfirmationScreen(parkingSpot: parkingSpot),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
