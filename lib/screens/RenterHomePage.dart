import 'package:flutter/material.dart';
import 'package:parkly/screens/RenterListingsTab.dart';

class RenterHomePage extends StatefulWidget {
  const RenterHomePage({super.key});

  @override
  _RenterHomePageState createState() => _RenterHomePageState();
}

class _RenterHomePageState extends State<RenterHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Reservations', style: TextStyle(fontSize: 24)),
    Text('Calendar', style: TextStyle(fontSize: 24)),
    RenterListingsTab(), // Listings tab for renters
    Text('Chat', style: TextStyle(fontSize: 24)),
    Text('Menu', style: TextStyle(fontSize: 24)),
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
        title: Text('Renter Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Reservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
