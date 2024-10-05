// lib/widgets/booking_details_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/screens/booking_confirmation_screen.dart';

class BookingDetailsBottomSheet extends StatelessWidget {
  final ParkingSpot parkingSpot;

  const BookingDetailsBottomSheet({Key? key, required this.parkingSpot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Responsive padding
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.0,
          right: 16.0,
          top: 24.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Indicator
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Parking Spot Details
          Text(
            parkingSpot.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            parkingSpot.address,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.attach_money, color: Theme.of(context).primaryColor),
              SizedBox(width: 5),
              Text(
                '\$${parkingSpot.pricePerHour.toStringAsFixed(2)}/hr',
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Action Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookingConfirmationScreen(parkingSpot: parkingSpot),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).primaryColor, // Updated property
                foregroundColor: Colors.white, // Ensures text is white
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Book Now',
                style: TextStyle(color: Colors.white), // Explicit text color
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
