import 'package:ementor_demo/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
              image: AssetImage("assets/images/google_logo.png"), height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Sign in with Google",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      color: Colors.red,
      onPressed: () {
        BlocProvider.of<LoginBloc>(context).add(
          LoginWithGooglePressed(),
        );
      },
    );
  }
}
