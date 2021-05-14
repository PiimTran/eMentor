import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/sharing/sharing.dart';
import '../components/sharing_item2.dart';
import '../components/sharing_item1.dart';

class TopicDetailScreen extends StatelessWidget {
  static const routeName = '/topic-screen';

  @override
  Widget build(BuildContext context) {
    final topic = ModalRoute.of(context).settings.arguments as Topic;
    // List<Sharing> _sharinglist =
    // sharings.where((element) => element.topicId == topic.topicId).toList();

    return Scaffold(
      appBar: AppBar(),
      body: Container(
          // width: MediaQuery.of(context).size.width,
          // child: SingleChildScrollView(
          //   child: Column(
          //     children: <Widget>[
          //       Text(
          //         topic.topicName,
          //         style: TextStyle(fontSize: 30.0),
          //       ),
          //       Text('detail about topic'),
          //       SizedBox(
          //         height: 50,
          //       ),
          //       Text('Recommended for you'),
          //       Container(
          //         height: 300,
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemCount: _sharinglist.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return SharingItem1(_sharinglist[index]);
          //           },
          //         ),
          //       ),
          //       SizedBox(
          //         height: 50,
          //       ),
          //       Text('All sharings'),
          //       Container(
          //         child: Column(
          //           children: List.generate(_sharinglist.length, (index) {
          //             return SharingItem2(sharing: _sharinglist[index],);
          //           }),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ),
    );
  }
}
