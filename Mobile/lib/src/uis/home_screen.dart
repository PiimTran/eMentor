import 'package:flutter/material.dart';
import '../models/google_signin/auth.dart';
import '../models/google_signin/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feature'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              try {
                Auth auth = Provider.of(context).auth;
                await auth.signOut();
              } catch (e) {
                print(e);
              }
            },
            child: Text('Sign out'),
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
