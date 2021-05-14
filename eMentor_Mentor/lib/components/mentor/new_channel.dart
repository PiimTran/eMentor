import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ementor_demo/blocs/bloc.dart';
import 'package:ementor_demo/components/loading_circle.dart';
import 'package:ementor_demo/models/channel/channel_create.dart';
import 'package:ementor_demo/models/model.dart';
import 'package:ementor_demo/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class NewChannel extends StatefulWidget {
  final Function addChannel;

  const NewChannel({Key key, this.addChannel}) : super(key: key);
  @override
  _NewChannelState createState() => _NewChannelState();
}

class _NewChannelState extends State<NewChannel> {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    FirebaseUser user = authBloc.state.props[0];

    return Column(
      children: <Widget>[
        Text('Please choose a topic'),
        Expanded(
          child: FutureBuilder<List<Major>>(
            future: getMajorList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final List<Major> _majors = snapshot.data;
                    List<Topic> majorTopics = _majors[index].topics;
                    return ExpansionTile(
                      title: Text(
                        _majors[index].majorName,
                      ),
                      children: <Widget>[
                        majorTopics.isNotEmpty
                            ? ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: majorTopics.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(
                                          '  ${majorTopics[index].topicName}'),
                                      trailing: Icon(Icons.arrow_right),
                                      onTap: () {
                                        getMentorId(user.email).then((id) {
                                          ChannelCreate channel = ChannelCreate(
                                            mentorId: id,
                                            topicId: majorTopics[index].topicId,
                                          );

                                          createChannel(channel)
                                              .then((response) {
                                            print(response.statusCode);
                                            widget.addChannel(
                                                channel, user.email);
                                          });
                                        });

                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                              )
                            : Text("no topic yet"),
                      ],
                    );
                  },
                  itemCount: snapshot.data.length,
                );
              } else
                return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
