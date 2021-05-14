import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ementor_demo/models/mentor/mentor.dart';
import 'package:ementor_demo/models/user.dart';
import 'package:ementor_demo/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);

    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();

    if (await isNewUser(firebaseUser)) {
      addNewUser(firebaseUser);

      Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .setData({'subs': []}, merge: true);
    }

    updateUserData(firebaseUser);

    return firebaseUser;
  }

  Future<void> signInWithCredentials(String email, String password) async {
    FirebaseUser firebaseUser;
    try {
      firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
    } catch (e) {
      print('exception: $e');
    }
    updateUserData(firebaseUser);
  }

  Future<void> signUp({String email, String password}) async {
    FirebaseUser firebaseUser =
        (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
            .user;
    updateUserData(firebaseUser);
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return (await _firebaseAuth.currentUser());
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref =
        Firestore.instance.collection('users').document(user.uid);

    return ref.setData({
      'displayname': user.displayName,
      'email': user.email,
      'uid': user.uid,
      'lastSignIn': DateTime.now(),
      'photoUrl': user.photoUrl,
    }, merge: true);
  }

  void addNewUser(FirebaseUser fbUser) {
    User user = User(
      avatarUrl: fbUser.photoUrl,
      email: fbUser.email,
      fullname: fbUser.displayName,
      phone: "string",
      yearOfBirth: 0,
    );

    Mentor mentor = Mentor(user: user);

    createUser(user).then((response) {
      if (response.statusCode == 200) {
        print('sucess to add new user ${response.statusCode}');
        createMentor(mentor).then((response) {
          if (response.statusCode == 200)
            print('sucess to create mentor ${response.statusCode}');
          else
            print('fail to create mentor ${response.statusCode}');
          print(response.body.toString());
        });
      } else {
        print('fail to add new user ${response.statusCode}');
      }

      print(response.headers.toString());
    });
  }

  Future<bool> isNewUser(FirebaseUser user) async {
    QuerySnapshot result = await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    return docs.length == 0 ? true : false;
  }
}
