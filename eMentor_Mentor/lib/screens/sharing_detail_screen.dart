import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ementor_demo/blocs/bloc.dart';
import '../models/sharing/sharing_detail.dart';
import '../models/sharing/sharing_info.dart';
import 'package:ementor_demo/screens/home_screen.dart';
import 'package:ementor_demo/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../utilities/redis_commentbox.dart';

import 'package:flutter/material.dart';

class SharingDetailScreen extends StatelessWidget {
  static const routeName = '/Sharing-detail';

  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final sharingInfo =
        ModalRoute.of(context).settings.arguments as SharingInfo;

    // print(sharingInfo.endTime);

    // ignore: close_sinks
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    FirebaseUser user = authBloc.state.props[0];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // title: Text(
        //   sharingInfo.sharingName,
        //   style: TextStyle(
        //       color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w400),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: getSharingDetailById(sharingInfo.sharingId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  SharingDetail sharing = snapshot.data[0];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Card(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/programming.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: size.height * 0.3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  sharing.sharingName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35.0,
                                  ),
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60.0,
                        margin: EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFEFF4F7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildStatItem(
                              '${DateFormat.MEd().format(sharing.startTime)}',
                              Icon(Icons.calendar_today),
                            ),
                            _buildStatItem(
                              '${sharing.maximum}',
                              Icon(Icons.person_add),
                            ),
                            _buildStatItem(
                              '${sharing.price}',
                              Icon(Icons.attach_money),
                            ),
                          ],
                        ),
                      ),
                      buildHeader(context, sharingInfo),
                      Card(
                        margin: EdgeInsets.all(10.0),
                        elevation: 5,
                        child: Container(
                          // margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(20.0),
                          // height: 200.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Time',
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  'Start time: ${new DateFormat.jm().format(sharingInfo.startTime)}, ${new DateFormat.yMd().format(sharingInfo.startTime)}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'End time: ${new DateFormat.jm().format(sharingInfo.endTime)}, ${new DateFormat.yMd().format(sharingInfo.endTime)}'),
                              SizedBox(
                                height: 10,
                              ),
                              // Text('Description: ${sharing.description}'),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        elevation: 5,
                        child: Container(
                          // margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(20.0),
                          // height: 200.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Location',
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Offline at: 269 Lien Phuong, q9'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        elevation: 5,
                        child: Container(
                          // margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(20.0),
                          // height: 200.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Description',
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('- ${sharing.description}'),
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: CommentBox(
                      //     sharingId: sharingInfo.sharingId,
                      //     username: sharingInfo.mentorName,
                      //   ),
                      // ),
                    ],
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Card(
                elevation: 5.0,
                child: CommentBox(
                  sharingId: sharingInfo.sharingId,
                  username: sharingInfo.mentorName,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void enrollUser() {}

  Widget buildHeader(context, sharingInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 5,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Details',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                ),
                MaterialButton(
                  onPressed: () {},
                  color: Colors.red,
                  height: 50,
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildStatItem(String count, Icon icon) {
  TextStyle _statCountTextStyle = TextStyle(
    // color: Colors.black54,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      icon,
      SizedBox(
        width: 5.0,
      ),
      Text(
        count,
        style: _statCountTextStyle,
      ),
    ],
  );
}
