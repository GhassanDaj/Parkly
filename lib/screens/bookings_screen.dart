import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:parkly/screens/BookingDetailsScreen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late final String userId;
  late Stream<QuerySnapshot> bookingsStream;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    bookingsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookings') // Fetch bookings from user's subcollection
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          final bookingDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookingDocs.length,
            itemBuilder: (context, index) {
              final doc = bookingDocs[index];
              final bookingId = doc.id; // The ID of the booking document
              final listingId = doc['listingId'];
              final bookedAt = (doc['bookedAt'] as Timestamp).toDate();
              final formattedDate =
                  DateFormat.yMMMd().add_jm().format(bookedAt); // Format date

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.local_parking,
                        color: Colors.blue, size: 40), // Icon for parking
                    title: Text('Listing ID: $listingId',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Booked at: $formattedDate'),
                    trailing: Icon(
                        Icons.chevron_right), // Arrow for more info (if needed)
                    onTap: () {
                      // Navigate to the booking details screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookingDetailsScreen(bookingId: bookingId),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
