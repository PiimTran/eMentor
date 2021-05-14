import 'package:flutter/material.dart';
import './models/google_signin/auth.dart';
import './models/google_signin/provider.dart';
import './uis/home_screen.dart';
import './uis/login_screen.dart';
import './uis/bottom_nav_bar.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMentor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        body: BottomNavBar(),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Provider(
//       auth: Auth(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'E-Mentor',
//         theme: ThemeData(
//           primaryColor: Colors.blue,
//         ),
//         home: BottomNavScreen(),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final Auth auth = Provider.of(context).auth;
//     return StreamBuilder<String>(
//       stream: auth.onAuthStateChanged,
//       builder: (context, AsyncSnapshot<String> snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final bool loggedIn = snapshot.hasData;
//           if (loggedIn == true) {
//             return HomeScreen();
//           } else {
//             return LoginScreen();
//           }
//         }
//         return CircularProgressIndicator();
//       },
//     );
//   }
// }
