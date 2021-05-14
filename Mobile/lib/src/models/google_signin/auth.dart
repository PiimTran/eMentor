import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<String> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  Future<String> currentUser();
  Future<void> signOut();
  Future<String> signInWithGoogle();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await Firestore.instance
        .collection('users')
        .document(authResult.user.uid)
        .setData({
      'username': email.split('@')[0],
      'email': email,
    });

    return authResult.user.uid;
  }

  @override
  Future<String> currentUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user
        .uid;
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _auth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _auth.accessToken,
      idToken: _auth.idToken,
    );

    FirebaseUser fbUser =
        (await _firebaseAuth.signInWithCredential(credential)).user;

    assert(fbUser.email != null);
    assert(fbUser.displayName != null);

    assert(await fbUser.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(fbUser.uid == currentUser.uid);

    if (await isNewUser(fbUser)) {
      await Firestore.instance
          .collection('users')
          .document(fbUser.uid)
          .setData({
        'username': fbUser.email.split('@')[0],
        'email': fbUser.email,
      });
    }
    return fbUser.uid;
  }

  @override
  Future<void> signOut() {
    try {
      _firebaseAuth.signOut();
      _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
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
