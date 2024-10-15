import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  _CreateListingScreenState createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _address = '';
  double _price = 0.0;
  double _latitude = 0.0;
  double _longitude = 0.0;

  // Save the listing to Firebase Firestore
  Future<void> _saveListing() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('parking_spots').add({
        'address': _address,
        'price': _price,
        'latitude': _latitude,
        'longitude': _longitude,
        'available': true,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parking spot listed successfully!')),
      );
      Navigator.of(context).pop(); // Go back after listing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Parking Spot Listing'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (value) {
                  _address = value!;
                },
                validator: (value) {
                  return value!.isEmpty ? 'Please enter the address' : null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price per Hour'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.parse(value!);
                },
                validator: (value) {
                  return value!.isEmpty ? 'Please enter the price' : null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _latitude = double.parse(value!);
                },
                validator: (value) {
                  return value!.isEmpty ? 'Please enter the latitude' : null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _longitude = double.parse(value!);
                },
                validator: (value) {
                  return value!.isEmpty ? 'Please enter the longitude' : null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveListing,
                child: Text('Create Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
