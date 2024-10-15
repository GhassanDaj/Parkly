import 'package:flutter/material.dart';
import 'package:parkly/screens/CreateListingScreen.dart';

class RenterListingsTab extends StatelessWidget {
  const RenterListingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Listings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You don\'t have any listings yet.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the CreateListingScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => CreateListingScreen()),
                );
              },
              child: Text('Create a Listing'),
            ),
          ],
        ),
      ),
    );
  }
}
