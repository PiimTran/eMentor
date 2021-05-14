import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/google_signin/provider.dart';
import '../models/google_signin/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String _email, _password;
  FormType _formType = FormType.login;

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (_formType == FormType.login) {
          String userId = await auth.signInWithEmailAndPassword(
            _email,
            _password,
          );

          print('Signed in $userId');
        } else {
          String userId = await auth.createUserWithEmailAndPassword(
            _email,
            _password,
          );
          print('Registered in $userId');
        }
      } on PlatformException catch (err) {
        var message = 'error occured';
        if (err.message != null) {
          message = err.message;
        }
        print(message);
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text(message),
        //   backgroundColor: Colors.grey,
        // ));
      } catch (e) {
        print(e);
      }
    }
  }

  void switchFormState(String state) {
    formKey.currentState.reset();

    if (state == 'register') {
      setState(() {
        _formType = FormType.register;
      });
    } else {
      setState(() {
        _formType = FormType.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...buildInputs(),
                SizedBox(
                  height: 40,
                ),
                ...buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        validator: EmailValidator.validate,
        decoration: InputDecoration(labelText: 'Email'),
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        validator: PasswordValidator.validate,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).primaryColor,
          onPressed: submit,
        ),
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Text(
            'Register Account',
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            switchFormState('register');
          },
        ),
        Divider(
          height: 50.0,
        ),
        OutlineButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 20.0),
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
          onPressed: () async {
            try {
              final _auth = Provider.of(context).auth;
              final id = await _auth.signInWithGoogle();
              print('signed in with google $id');
            } catch (e) {
              print(e);
            }
          },
        ),
      ];
    } else {
      return [
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Text(
            'Create Account',
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).primaryColor,
          onPressed: submit,
        ),
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Text(
            'Go to Login',
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            switchFormState('login');
          },
        )
      ];
    }
  }
}
