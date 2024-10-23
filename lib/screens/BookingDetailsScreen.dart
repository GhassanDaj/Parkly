import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId; // ID of the booking document

  const BookingDetailsScreen({required this.bookingId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('bookings')
            .doc(bookingId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Booking not found.'));
          }

          final bookingData = snapshot.data!.data() as Map<String, dynamic>;
          final listingId = bookingData['listingId'];
          final bookedAt = (bookingData['bookedAt'] as Timestamp).toDate();
          final formattedDate = DateFormat.yMMMd().add_jm().format(bookedAt);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Listing ID: $listingId',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Booked At: $formattedDate',
                    style: TextStyle(fontSize: 16)),
                // Add more details if available
              ],
            ),
          );
        },
      ),
    );
  }
}
