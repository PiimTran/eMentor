import 'package:ementor_demo/blocs/bloc.dart';
import '../blocs/bloc.dart';
import 'package:ementor_demo/components/loading_circle.dart';
import 'package:ementor_demo/models/model.dart';
import 'package:ementor_demo/utilities/sharing_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './topic_detail_screen.dart';
import '../models/topic.dart';
import '../models/major.dart';

import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  // MajorBloc _majorBloc;

  var keys = ['java', 'python', 'c', 'c#', 'english', 'japanese'];

  void selectMajor(BuildContext context) {
    Navigator.of(context).pushNamed('/major-detail');
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(_onScroll);
  //   _majorBloc = BlocProvider.of<MajorBloc>(context);
  // }

  @override
  Widget build(BuildContext context) {
    final sharingBloc = BlocProvider.of<SharingBloc>(context);
    List<Sharing> sharings = sharingBloc.state.props.isEmpty ? [] : sharingBloc.state.props[0];
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SharingSearch(sharings),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Text('Top searches'),
                  Wrap(
                    spacing: 8.0,
                    children: keys.map((key) {
                      return ActionChip(
                        onPressed: () {},
                        label: Text(key),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text('Browse cateories'),
                  Container(
                    height: 400,
                    child: BlocBuilder<MajorBloc, MajorState>(
                        builder: (context, state) {
                      if (state is MajorInitial) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is MajorFailure) {
                        return Center(
                          child: Text('failed to fetch Majors'),
                        );
                      }
                      if (state is MajorSuccess) {
                        if (state.majors.isEmpty) {
                          return Center(
                            child: Text('no majorss'),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.majors.length,
                          itemBuilder: (BuildContext context, int index) {
                            final List<Major> _majors = state.majors;
                            List<Topic> majorTopics = _majors[index].topics;

                            return index > state.majors.length
                                ? LoadingCircle()
                                : ExpansionTile(
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
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    title: Text(
                                                        '  ${majorTopics[index].topicName}'),
                                                    trailing:
                                                        Icon(Icons.arrow_right),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              TopicDetailScreen
                                                                  .routeName,
                                                              arguments:
                                                                  majorTopics[
                                                                      index]);
                                                    },
                                                  );
                                                },
                                              ),
                                            )
                                          : Text("no topic yet"),
                                    ],
                                  );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void _onScroll() {
  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final currentScroll = _scrollController.position.pixels;
  //   if (maxScroll - currentScroll <= _scrollThreshold) {
  //     _majorBloc.add(MajorFetched());
  //   }
  // }
}
