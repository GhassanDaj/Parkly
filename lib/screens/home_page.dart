// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkly/services/auth_provider.dart';
import 'package:parkly/services/parking_spot_provider.dart';
import 'package:parkly/widgets/parking_spots_map.dart';
import 'package:parkly/screens/login_page.dart'; // Ensure you have a LoginPage

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parkingSpotProvider = Provider.of<ParkingSpotProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Parkly'),
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
              leading: Icon(Icons.history),
              title: Text('Your Bookings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Booking History Screen
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await authProvider.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: parkingSpotProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : parkingSpotProvider.errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    parkingSpotProvider.errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              : ParkingSpotsMap(parkingSpots: parkingSpotProvider.parkingSpots),
    );
  }
}
