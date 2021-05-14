import 'package:ementor_demo/blocs/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../blocs/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../screens/course_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/mentor_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg) {
        print('$msg onMesage');
        return;
      },
      onLaunch: (msg) {
        print('$msg onLaunch');
        return;
      },
      onResume: (msg) {
        print('$msg onResume');
        return;
      },
    );
    fbm.subscribeToTopic('sharings');
  }

  int _selectedIndex = 0;

  final List<Widget> _screen = <Widget>[
    MentorScreen(),
    // SearchScreen(),
    // CourseScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SharingBloc(httpClient: http.Client())..add(SharingFetched()),
          ),
          BlocProvider(
            create: (context) =>
                MajorBloc(httpClient: http.Client())..add(MajorFetched()),
          ),
          BlocProvider(
            create: (context) =>
                ChannelBloc(httpClient: http.Client())..add(ChannelFetched()),
          )
        ],
        child: _screen.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
            title: Text('Home'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.search,
          //     size: 30.0,
          //   ),
          //   title: Text('Communication'),
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.school,
          //     size: 30.0,
          //   ),
          //   title: Text('Subscription'),
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 30.0,
            ),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
      ),
    );
  }
}
