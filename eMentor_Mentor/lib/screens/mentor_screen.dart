import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ementor_demo/blocs/bloc.dart';
import 'package:ementor_demo/components/mentor/new_channel.dart';
import 'package:ementor_demo/models/channel/channel.dart';
import 'package:ementor_demo/models/channel/channel_create.dart';
import 'package:ementor_demo/models/mentor/mentor_channel.dart';
import 'package:ementor_demo/screens/channel_screen_mentor.dart';
import 'package:ementor_demo/screens/contact_list.dart';
import 'package:ementor_demo/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/appbar.dart';

class MentorScreen extends StatefulWidget {
  static const routeName = '/mentor-screen';
  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  Future<List<MentorChannel>> _channelList;
  @override
  void initState() {
    super.initState();
  }

  void _addNewChannel(ChannelCreate channel, String email) {
    setState(() {
      _channelList = getChannelById(email);
    });
  }

  void _startAddNewChannel(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewChannel(
            addChannel: _addNewChannel,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    FirebaseUser user = authBloc.state.props[0];

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: MyAppBar(
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Mentor', style: TextStyle(color: Colors.white)),
                ],
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Column(
              children: <Widget>[
                buildHeader(context),
                SizedBox(
                  height: 30.0,
                ),
                ListChannelWidget(user: user),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: size.height * 0.2,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Based on your experience, we think these resources will be helpful.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Container(
                  // height: size.height * 0.5,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[350],
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      FlutterLogo(
                        size: 140,
                      ),
                      Container(
                        height: size.height * 0.2,
                        width: size.width * 0.7,
                        child: Center(
                          child: Text(
                            'Based on your experience, we think these resources will be helpful.',
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Container(
                        height: size.height * 0.2,
                        width: size.width * 0.7,
                        child: Center(
                          child: Text(
                            'Based on your experience, we think these resources will be helpful.',
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  // height: size.height * 0.5,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[350],
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      FlutterLogo(
                        size: 140,
                      ),
                      Container(
                        height: size.height * 0.2,
                        width: size.width * 0.7,
                        child: Center(
                          child: Text(
                            'Based on your experience, we think these resources will be helpful.',
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Container(
                        height: size.height * 0.2,
                        width: size.width * 0.7,
                        child: Center(
                          child: Text(
                            'Based on your experience, we think these resources will be helpful.',
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Row buildHeader(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Channels',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
        MaterialButton(
          onPressed: () {
            _startAddNewChannel(context);
          },
          color: Colors.red,
          height: 50,
          child: Text(
            'New Channel',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class ListChannelWidget extends StatelessWidget {
  const ListChannelWidget({
    Key key,
    @required this.user,
  }) : super(key: key);

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getChannelById(user.email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          MentorChannel mentor = snapshot.data[0];
          var channels = mentor.channels;
          return channels.isEmpty
              ? Text('you don\'t have any channel')
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ChannelMentor.routeName,
                              arguments: channels[index]);
                        },
                        title: Text(
                            '${channels[index].topicName} \n \n ${channels[index].mentorName}'),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(''),
                        ),
                        trailing: Icon(Icons.more_vert),
                        leading: FlutterLogo(
                          size: 72.0,
                        ),
                      ),
                    );
                  },
                );
        } else
          return Center(child: CircularProgressIndicator());
      },
    );
  }
}
