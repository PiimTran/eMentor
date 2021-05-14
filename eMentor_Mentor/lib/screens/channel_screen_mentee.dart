import 'package:ementor_demo/blocs/bloc.dart';
import 'package:ementor_demo/models/channel/channel.dart';
import 'package:ementor_demo/models/channel/channel_sharing.dart';
import 'package:ementor_demo/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'sharing_detail_screen.dart';

class ChannelScreen extends StatelessWidget {
  static const routeName = '/channel-screen';

  @override
  Widget build(BuildContext context) {
    final _channel = ModalRoute.of(context).settings.arguments as Channel;

    // ignore: close_sinks
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    FirebaseUser user = authBloc.state.props[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('${_channel.topicName} - ${_channel.mentorName}'),
      ),
      body: FutureBuilder(
        future: getSharingById(_channel.channelId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            ChannelSharing channel_info = snapshot.data[0];
            bool isMe = (channel_info.mentor.email) == user.email;
            var _sharings = channel_info.sharing;
            return Column(
              children: <Widget>[
                isMe
                    ? Text('Your channel')
                    : OutlineButton(
                        onPressed: () {},
                        child: Text('subcribe'),
                      ),
                Expanded(
                  child: _sharings.isEmpty
                      ? Text('No sharings')
                      : ListView.builder(
                          itemCount: _sharings.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SharingDetailScreen.routeName,
                                    arguments: _sharings[index]);
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        40.0, 5.0, 20.0, 5.0),
                                    height: 120.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          50.0, 20.0, 20.0, 20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: 120.0,
                                                child: Text(
                                                  '${_sharings[index].sharingName}',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Text(
                                                '${_sharings[index].price}',
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.0),
                                          Container(
                                            padding: EdgeInsets.all(5.0),
                                            width: 180.0,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Date: ${DateFormat.yMd().format(_sharings[index].startTime)}',
                                              style: TextStyle(
                                                fontSize: 10.0,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(5.0),
                                                width: 180.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Start: ${DateFormat.Hm().format(_sharings[index].startTime)} - End: ${DateFormat.Hm().format(_sharings[index].endTime)}',
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5.0),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   left: 20.0,
                                  //   top: 15.0,
                                  //   bottom: 15.0,
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(20.0),
                                  //     child: Image(
                                  //       width: 110.0,
                                  //       image: NetworkImage(
                                  //         sharing.imageUrl,
                                  //       ),
                                  //       fit: BoxFit.cover,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
