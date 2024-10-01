// widgets/parking_spots_list.dart
import 'package:flutter/material.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/screens/parking_spot_details_screen.dart';

class ParkingSpotsList extends StatelessWidget {
  final List<ParkingSpot> parkingSpots;

  const ParkingSpotsList({Key? key, required this.parkingSpots})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: parkingSpots.length,
      itemBuilder: (context, index) {
        ParkingSpot spot = parkingSpots[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(Icons.local_parking,
                color: Theme.of(context).primaryColor, size: 40),
            title: Text(
              spot.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              spot.address,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            trailing: Text(
              '\$${spot.pricePerHour.toStringAsFixed(2)}/hr',
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).primaryColor),
            ),
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
        );
      },
    );
  }
}
