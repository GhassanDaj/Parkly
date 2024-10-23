import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting the date

class WishlistDetailsScreen extends StatelessWidget {
  final String wishlistId; // ID of the wishlist document

  const WishlistDetailsScreen({required this.wishlistId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('wishlist')
            .doc(wishlistId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Wishlist item not found.'));
          }

          final wishlistData = snapshot.data!.data() as Map<String, dynamic>;
          final listingId = wishlistData['listingId'];
          final addedAt = (wishlistData['addedAt'] as Timestamp).toDate();
          final formattedDate = DateFormat.yMMMd().add_jm().format(addedAt);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Listing ID: $listingId',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Added At: $formattedDate',
                    style: TextStyle(fontSize: 16)),
                // Add more details if needed
              ],
            ),
          );
        },
      ),
    );
  }
}
