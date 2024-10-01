// screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:parkly/models/parking_spot.dart';
import 'package:parkly/screens/parking_spot_details_screen.dart';
import 'package:parkly/screens/booking_history_screen.dart';
import 'package:parkly/services/auth_provider.dart';
import 'package:parkly/services/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:parkly/widgets/parking_spots_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                authProvider.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<BookingProvider>(context, listen: false)
            .fetchParkingSpots(),
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            if (bookingProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (bookingProvider.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  bookingProvider.errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (bookingProvider.parkingSpots.isEmpty) {
              return Center(
                child: Text(
                  'No available parking spots at the moment.',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return ParkingSpotsList(
                  parkingSpots: bookingProvider.parkingSpots);
            }
          },
        ),
      ),
    );
  }
}
