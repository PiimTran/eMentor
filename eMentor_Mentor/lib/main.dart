import 'package:ementor_demo/screens/channel_screen_mentee.dart';
import 'package:ementor_demo/screens/channel_screen_mentor.dart';
import 'package:ementor_demo/screens/home_screen.dart';
import 'package:ementor_demo/screens/mentor_screen.dart';
import 'package:ementor_demo/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/bloc.dart';
import 'repositories/repository.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/sharing_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/topic_detail_screen.dart';
import 'components/mentor/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AuthenticationStarted()),
      child: MyApp(userRepository: userRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.blue[900],
        accentColor: Colors.red,
        scaffoldBackgroundColor: Colors.grey[300],
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              button: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              bodyText1: TextStyle(fontSize: 10.0, color: Colors.blue[900]),
              bodyText2: TextStyle(fontSize: 20.0, color: Colors.blue[900]),
              subtitle2: TextStyle(fontSize: 10.0, color: Colors.blue[900]),
              headline5: TextStyle(fontSize: 10.0, color: Colors.blue[900]),
              headline6: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return SplashScreen();
          }
          if (state is AuthenticationSuccess) {
            return MainScreen();
          }
          if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: _userRepository);
          }
          return SplashScreen();
        },
      ),
      routes: {
        SharingDetailScreen.routeName: (ctx) => SharingDetailScreen(),
        TopicDetailScreen.routeName: (ctx) => TopicDetailScreen(),
        MentorScreen.routeName: (ctx) => MentorScreen(),
        ChannelScreen.routeName: (ctx) => ChannelScreen(),
        ChannelMentor.routeName: (ctx) => ChannelMentor(),
        NewSharing.routeName: (ctx) => NewSharing(),
        BottomNavBar.routeName: (ctx) => BottomAppBar()
      },
    );
  }
}
