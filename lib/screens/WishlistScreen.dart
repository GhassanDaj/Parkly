import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    print('Current User ID: $userId'); // Check if the user ID matches Firestore
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
            print('No data found in wishlist.');
            return Center(child: Text('No items in your wishlist.'));
          }

          try {
            final wishlistDocs = snapshot.data!.docs;
            print('Number of wishlist documents: ${wishlistDocs.length}');

            return ListView.builder(
              itemCount: wishlistDocs.length,
              itemBuilder: (context, index) {
                final doc = wishlistDocs[index];
                final listingId = doc['listingId'];
                final addedAt = (doc['addedAt'] as Timestamp).toDate();

                print('Listing ID: $listingId, Added At: $addedAt');

                return ListTile(
                  title: Text('Listing ID: $listingId'),
                  subtitle: Text('Added at: $addedAt'),
                );
              },
            );
          } catch (e) {
            print('Error fetching wishlist data: $e');
            return Center(child: Text('Error loading wishlist.'));
          }
        },
      ),
    );
  }
}
