import 'package:ementor_demo/models/user.dart';
import 'package:ementor_demo/services/api.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text('Contacts'),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // print(snapshot.data);
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      User _user = snapshot.data[index];
                      return ListTile(
                        title: Text(_user.email),
                        onTap: () {},
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
      ),
    );
  }
}
