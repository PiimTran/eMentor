import 'package:ementor_demo/blocs/bloc.dart';
import 'package:ementor_demo/models/model.dart';
import 'package:ementor_demo/repositories/repository.dart';
import 'package:ementor_demo/screens/mentor_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/mentor/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    FirebaseUser user = authBloc.state.props[0];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(user.photoUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(80.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 5.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Text(user.displayName),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(BottomNavBar.routeName);
                    },
                    child: Text('Switch to mentor view'),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            ListTile(
              title: Text('Profile setting'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: () {
                authBloc.add(
                  AuthenticationLoggedOut(),
                );
              },
              child: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
