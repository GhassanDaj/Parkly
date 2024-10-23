import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:parkly/screens/WishlistDetailsScreen.dart'; // For formatting the date

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late final String userId;
  late Stream<QuerySnapshot> wishlistStream;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    wishlistStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Wishlist'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: wishlistStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items in your wishlist.'));
          }

          final wishlistDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: wishlistDocs.length,
            itemBuilder: (context, index) {
              final doc = wishlistDocs[index];
              final wishlistId = doc.id; // ID of the wishlist document
              final listingId = doc['listingId'];
              final addedAt = (doc['addedAt'] as Timestamp).toDate();
              final formattedDate =
                  DateFormat.yMMMd().add_jm().format(addedAt); // Format date

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.favorite,
                        color: Colors.red, size: 40), // Icon for wishlist
                    title: Text('Listing ID: $listingId',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Added at: $formattedDate'),
                    trailing: Icon(Icons.chevron_right), // Arrow for more info
                    onTap: () {
                      // Navigate to the wishlist details screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WishlistDetailsScreen(wishlistId: wishlistId),
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
