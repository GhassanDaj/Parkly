import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkly/widgets/parking_spots_map.dart';
import 'package:parkly/screens/profile_screen.dart'; // ProfileScreen includes the Logout button

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ParkingSpotsMap(), // Removed the parkingSpots parameter, the data will be fetched internally in ParkingSpotsMap
    Text('Wishlists', style: TextStyle(fontSize: 24)), // Wishlists
    Text('Booked', style: TextStyle(fontSize: 24)), // Booked
    Text('Chat', style: TextStyle(fontSize: 24)), // Chat
    ProfileScreen(), // Profile with Logout button
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parkly'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Always show labels
        backgroundColor: Colors.white, // Set navbar background to white
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Booked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Black for selected items
        unselectedItemColor: Colors.black, // Black for unselected items
        onTap: _onItemTapped,
      ),
    );
  }
}
