import 'package:ementor_demo/screens/channel_screen_mentor.dart';
import 'package:ementor_demo/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  static const routeName = 'mentor-main-screen';
  BottomNavBar({Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    ChannelMentor(),
    Scaffold(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Channels'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            title: Text('Communication'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.fastfood),
          //   title: Text('Thông báo'),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen[900],
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
      ),
    );
  }
}
