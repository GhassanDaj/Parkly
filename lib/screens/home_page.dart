// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/screens/parking_spot_details_screen.dart';
import 'package:parkly/screens/booking_history_screen.dart';
import 'package:parkly/services/auth_provider.dart';
import 'package:parkly/services/booking_provider.dart';
import 'package:parkly/services/parking_spot_provider.dart';
import 'package:parkly/widgets/parking_spots_map.dart';
import 'package:parkly/widgets/parking_spots_grid.dart';
import 'package:parkly/screens/login_page.dart'; // Replace with your actual login screen

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parkingSpotProvider = Provider.of<ParkingSpotProvider>(context);
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Parking Spots'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Parkly',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              leading: Icon(Icons.local_parking),
              title: Text('Available Spots'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Your Bookings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingHistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                try {
                  await authProvider.signOut();
                  // Navigate to LoginPage and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  // Optionally, show a snackbar or dialog with the error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: parkingSpotProvider.fetchParkingSpots,
        child: Consumer<ParkingSpotProvider>(
          builder: (context, parkingSpotProvider, child) {
            if (parkingSpotProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (parkingSpotProvider.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  parkingSpotProvider.errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (parkingSpotProvider.parkingSpots.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_spots.png', // Ensure this asset exists
                      height: 150,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No available parking spots at the moment.',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  // Google Map - 3/4 of the screen
                  Expanded(
                    flex: 3,
                    child: ParkingSpotsMap(
                        parkingSpots: parkingSpotProvider.parkingSpots),
                  ),
                  // Parking Spots Grid/List - 1/4 of the screen
                  Expanded(
                    flex: 1,
                    child: ParkingSpotsGrid(
                        parkingSpots: parkingSpotProvider.parkingSpots),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
