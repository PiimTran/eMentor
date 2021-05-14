import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ementor_demo/blocs/bloc.dart';
import 'package:ementor_demo/models/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseScreen extends StatelessWidget {
  List<Sharing> recent_sharings;

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    FirebaseUser user = authBloc.state.props[0];

    // return Scaffold(
    //     body: recent_sharings != null
    //         ? ListView(
    //             children: <Widget>[
    //               Text('no data yet'),
    //             ],
    //           )
    //         : Center(child: Text('You have no sharing')));

    return StreamBuilder(
      stream:
          Firestore.instance.collection('users').document(user.uid).snapshots(),
      builder: (context, snapshot) {
        // try {
          List<dynamic> subs = snapshot.data['subs'];

          
            List<DocumentSnapshot> docs;
            Firestore.instance
                .collection('channel')
                .getDocuments()
                .then((value) {
              docs + (value.documents);
            });
            return docs != null
                ? ListView.builder(
                    itemCount: subs.length,
                    itemBuilder: (context, index) {
                      var cdoc = docs[index];
                      return ListTile(
                        title: Text(cdoc['mentor']),
                      );
                    },
                  )
                : Center(child: Text('no subs'));
          
        // } catch (e) {
        //   return Center(child: Text('error'));
        // }
      },
    );
  }
}
