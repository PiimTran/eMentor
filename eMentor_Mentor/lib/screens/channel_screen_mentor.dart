import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ementor_demo/blocs/bloc.dart';
import '../screens/sharing_detail_screen.dart';
import '../components/appbar.dart';
import 'package:ementor_demo/models/channel/channel.dart';
import 'package:ementor_demo/models/channel/channel_sharing.dart';
import 'package:ementor_demo/models/model.dart';
import 'package:ementor_demo/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChannelMentor extends StatelessWidget {
  static const routeName = '/channel-mentor';

  @override
  Widget build(BuildContext context) {
    final channel = ModalRoute.of(context).settings.arguments as Channel;
    print(channel.topicName);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'dash',
              child: Image(
                image: AssetImage('assets/images/java.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                elevation: 5.0,
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      '${channel.topicName}',
                      style: TextStyle(fontSize: 24.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            buildHeader(context, channel),
            FutureBuilder(
              future: getSharingById(channel.channelId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  ChannelSharing channel_info = snapshot.data[0];
                  var _sharings = channel_info.sharing;
                  return _sharings.isEmpty
                      ? Center(child: Text('you don\'t have any sharings'))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _sharings.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Card(
                                elevation: 5.0,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        SharingDetailScreen.routeName,
                                        arguments: _sharings[index]);
                                  },
                                  title:
                                      Text('${_sharings[index].sharingName}'),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: _sharings[index].isApproved != true
                                        ? Text('Draft')
                                        : Text(
                                            'Online',
                                            style: TextStyle(
                                                color: Colors.blue[400]),
                                          ),
                                  ),
                                  trailing: Icon(Icons.more_vert),
                                  leading: FlutterLogo(
                                    size: 72.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                } else
                  return Center(child: CircularProgressIndicator());
              },
            ),
          ]),
        )
      ]),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.of(context)
      //         .pushNamed(NewSharing.routeName, arguments: channel.channelId);
      //   },
      // ),
    );
  }

  Widget buildHeader(context, channel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 5.0,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Sharings',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(NewSharing.routeName,
                        arguments: channel.channelId);
                  },
                  color: Colors.red,
                  height: 50,
                  child: Text(
                    'Create Sharing',
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

class NewSharing extends StatelessWidget {
  static const routeName = '/sharing-create';

  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final maxController = TextEditingController();
  DateTime selectDate;

  TimeOfDay startTime;
  TimeOfDay endTime;
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    print(id);
    // ignore: close_sinks
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    FirebaseUser user = authBloc.state.props[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Create sharing'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // icon: Icon(Icons.book),
                  labelText: 'Sharing name',
                ),
                keyboardType: TextInputType.text,
                autovalidate: true,
                autocorrect: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // icon: Icon(Icons.book),
                  labelText: 'Description',
                ),
                keyboardType: TextInputType.text,
                autovalidate: true,
                autocorrect: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // icon: Icon(Icons.book),
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                autovalidate: true,
                autocorrect: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: maxController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // icon: Icon(Icons.book),
                  labelText: 'Number of students',
                ),
                keyboardType: TextInputType.number,
                autovalidate: true,
                autocorrect: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Choose Date',
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  selectDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  dateController.text = DateFormat.yMd().format(selectDate);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: startTimeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Start time',
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        startTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectDate),
                        );
                        startTimeController.text = startTime.format(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: endTimeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'End time',
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        endTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectDate),
                        );
                        endTimeController.text = endTime.format(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              MaterialButton(
                color: Colors.red,
                child: Text(
                  'Finish',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  DateTime start = DateTime(selectDate.year, selectDate.month,
                      selectDate.day, startTime.hour, startTime.minute);
                  DateTime end = DateTime(selectDate.year, selectDate.month,
                      selectDate.day, endTime.hour, endTime.minute);
                  Sharing _sharing = Sharing(
                    channelId: id,
                    description: descController.text,
                    endTime: end,
                    startTime: start,
                    price: int.parse(priceController.text),
                    maximum: int.parse(maxController.text),
                    imageUrl: 'none',
                    sharingName: nameController.text,
                  );
                  createSharing(_sharing)
                      .then((value) => print(value.statusCode));
                  print(end.toIso8601String());

                  Firestore.instance.collection('sharings').add({
                    'name': nameController.text,
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
