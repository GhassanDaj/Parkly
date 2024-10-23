import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingDetailsScreen extends StatefulWidget {
  final String listingId; // ID of the parking spot document

  const ListingDetailsScreen({required this.listingId, super.key});

  @override
  _ListingDetailsScreenState createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  DocumentSnapshot? listingData;

  @override
  void initState() {
    super.initState();
    _fetchListingDetails();
  }

  // Fetch listing details from Firestore
  Future<void> _fetchListingDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('parking_spots')
        .doc(widget.listingId)
        .get();
    setState(() {
      listingData = doc;
    });
  }

  Future<void> _addToWishlist() async {
    final userId = FirebaseAuth.instance.currentUser
        ?.uid; // Fetch the actual user ID from Firebase Auth

    if (userId != null) {
      try {
        // Add the listing to the authenticated user's wishlist
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('wishlist') // Subcollection for wishlist
            .add({
          'listingId': widget.listingId,
          'addedAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Added to wishlist')));
      } catch (e) {
        print("Error adding to wishlist: $e"); // Log any errors
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error adding to wishlist')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User is not authenticated')));
    }
  }

  // Create a booking and add it to Firestore
  Future<void> _createBooking() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        // Add the booking to the global 'bookings' collection
        final bookingData = {
          'userId': userId,
          'listingId': widget.listingId,
          'bookedAt': Timestamp.now(),
        };

        // Add the booking to the global 'bookings' collection
        await FirebaseFirestore.instance
            .collection('bookings')
            .add(bookingData);

        // Also add the booking to the user's 'bookings' subcollection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('bookings')
            .add(bookingData);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Booking created')));
      } catch (e) {
        print("Error creating booking: $e"); // Log any errors
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error creating booking')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User is not authenticated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (listingData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Listing Details'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = listingData!.data() as Map<String, dynamic>;
    final address =
        data.containsKey('address') ? data['address'] : 'Unknown address';
    final price = data.containsKey('price') ? data['price'] : 'N/A';
    final available = data.containsKey('available') ? data['available'] : false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Listing Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: $address', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Price: \$${price.toString()} per hour',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Availability: ${available ? 'Available' : 'Not Available'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addToWishlist,
              child: Text('Add to Wishlist'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createBooking, // Add a booking to Firestore
              child: Text('Create Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
