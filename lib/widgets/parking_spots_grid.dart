// lib/widgets/parking_spots_grid.dart

import 'package:flutter/material.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/screens/parking_spot_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // For loading indicator

class ParkingSpotsGrid extends StatelessWidget {
  final List<ParkingSpot> parkingSpots;

  const ParkingSpotsGrid({Key? key, required this.parkingSpots})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(), // Disable grid scrolling
      shrinkWrap: true,
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 3 / 4,
      ),
      itemCount: parkingSpots.length,
      itemBuilder: (context, index) {
        ParkingSpot spot = parkingSpots[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ParkingSpotDetailsScreen(parkingSpot: spot),
              ),
            );
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Parking Spot Image
                Expanded(
                  child: spot.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: spot.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: SpinKitCircle(
                              color: Theme.of(context).primaryColor,
                              size: 50.0,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child:
                                Icon(Icons.error, size: 50, color: Colors.red),
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.local_parking,
                              size: 50, color: Colors.grey[700]),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        spot.address,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.attach_money,
                              color: Theme.of(context).primaryColor, size: 16),
                          SizedBox(width: 2),
                          Text(
                            '${spot.pricePerHour.toStringAsFixed(2)}/hr',
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
