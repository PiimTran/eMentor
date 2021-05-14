import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ementor_demo/blocs/bloc.dart';
import 'package:ementor_demo/components/loading_circle.dart';
import 'package:ementor_demo/components/sharing_item2.dart';
import 'package:ementor_demo/models/channel/channel.dart';
import 'package:ementor_demo/models/channel/channel_sharing.dart';
import 'package:ementor_demo/screens/sharing_detail_screen.dart';
import 'package:ementor_demo/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../components/newestSharingList_carousel.dart';

import 'package:flutter/material.dart';

import 'channel_screen_mentee.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  ChannelBloc _channelBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _channelBloc = BlocProvider.of<ChannelBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelBloc, ChannelState>(
      builder: (context, state) {
        if (state is ChannelInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ChannelFailure) {
          return Center(
            child: Text('failed to fetch channels'),
          );
        }
        if (state is ChannelSuccess) {
          if (state.channels.isEmpty) {
            return Center(
              child: Text('no channels'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.channels.length
                  ? LoadingCircle()
                  : ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ChannelScreen.routeName,
                          arguments: state.channels[index],
                        );
                      },
                      title: Text(
                          '${state.channels[index].mentorName} - ${state.channels[index].topicName}'),
                    );
            },
            itemCount:
                state.isMax ? state.channels.length : state.channels.length,
            controller: _scrollController,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _channelBloc.add(ChannelFetched());
    }
  }
}
