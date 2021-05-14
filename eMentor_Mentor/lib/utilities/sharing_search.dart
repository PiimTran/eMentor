import 'dart:collection';

import 'package:ementor_demo/components/sharing_item2.dart';
import 'package:ementor_demo/models/model.dart';
import 'package:flutter/material.dart';

class SharingSearch extends SearchDelegate<Sharing> {
  final List<Sharing> sharings;

  SharingSearch(this.sharings);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final result = sharings
        .where((element) => element.sharingName.toLowerCase().contains(query))
        .toList();
    return sharings.isEmpty || sharings == null
        ? Center(
            child: Text('No data'),
          )
        : ListView.builder(
            itemCount: result.length,
            itemBuilder: (BuildContext context, int index) {
              return SharingItem2(sharing: result[index]);
            },
          );
  }
}
