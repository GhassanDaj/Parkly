import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkly/screens/CreateListingScreen.dart';
import 'package:intl/intl.dart'; // For date formatting

class RenterListingsTab extends StatefulWidget {
  const RenterListingsTab({Key? key}) : super(key: key);

  @override
  _RenterListingsTabState createState() => _RenterListingsTabState();
}

class _RenterListingsTabState extends State<RenterListingsTab> {
  late final String userId;
  late Stream<QuerySnapshot> listingsStream;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    listingsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('listings') // Fetch listings from user's subcollection
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Listings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: listingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
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
            );
          }

          final listingsDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: listingsDocs.length,
            itemBuilder: (context, index) {
              final doc = listingsDocs[index];
              final listingId = doc.id;
              final address = doc['address'];
              final price = doc['price'];
              final createdAt = (doc['createdAt'] as Timestamp).toDate();
              final formattedDate =
                  DateFormat.yMMMd().add_jm().format(createdAt);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.location_city,
                        color: Colors.blue, size: 40), // Icon for listing
                    title: Text('Address: $address',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Price: \$${price.toString()} - Created at: $formattedDate'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // You can add functionality to view more details of the listing
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
