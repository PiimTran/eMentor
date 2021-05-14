import 'dart:async';

import 'package:ementor_demo/models/sharing/sharing_info.dart';
import 'package:flutter/material.dart';
import 'package:redis/redis.dart';
import 'package:uuid/uuid.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class CommentBox extends StatefulWidget {
  CommentBox({Key key, this.title, this.sharingId, this.username})
      : super(key: key);
  final String title;
  final String sharingId;
  final String username;

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  TextEditingController _controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Text('Comments'),
          Container(
            child: StreamBuilder<List<Comment>>(
              stream: CommentCreator(widget.sharingId).stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('No data yet'));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Center(child: Text('Done!'));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error!'));
                } else {
                  return Center(
                    child: buildListView(
                        snapshot.data, widget.sharingId, widget.username),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              key: _formKey,
              controller: _controller,
              decoration: InputDecoration(
                  icon: Icon(Icons.text_rotation_none),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.blue,
                    onPressed: () {
                      CommentCreator.addComment(widget.sharingId, Uuid().v1(),
                          widget.username, _controller.text, true);
                      _controller.clear();
                    },
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Add comment'),
              maxLines: 10,
              minLines: 1,
            ),
          ),
          // Container(
          //   // height: 400.0,
          //   color: Colors.red,
          //   child: buildListView(),
          // ),
        ],
      ),
    );
  }

  ListView buildListView(
      List<Comment> data, String sharingId, String username) {
    List<Comment> _data = data;
    List<TextEditingController> _listController = new List();
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      itemCount: _data.length,
      itemBuilder: (BuildContext context, int index) {
        _listController.add(new TextEditingController());

        return CommentSection(
            sharingId: sharingId,
            username: username,
            data: _data,
            listController: _listController,
            index: index);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class CommentSection extends StatefulWidget {
  const CommentSection({
    Key key,
    @required List<Comment> data,
    @required List<TextEditingController> listController,
    this.index,
    this.username,
    this.sharingId,
  })  : _data = data,
        _listController = listController,
        super(key: key);

  final List<Comment> _data;
  final List<TextEditingController> _listController;
  final int index;
  final String username;
  final String sharingId;

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  bool showTextField = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: !widget._data[widget.index].isParent
          ? EdgeInsets.only(right: 40.0, left: 40.0)
          : EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget._data[widget.index].content,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget._data[widget.index].username,
                  style: TextStyle(fontSize: 14.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          showTextField = true;
                        });
                      },
                      child: Text(
                        'Reply',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: showTextField == false
                      ? Container()
                      : Container(
                          // color: Colors.red,
                          child: new ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 50.0,
                            ),
                            child: TextField(
                              key: _formKey,
                              autocorrect: false,
                              controller: widget._listController[widget.index],
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.send),
                                    color: Colors.blue,
                                    onPressed: () {
                                      CommentCreator.insertComment(
                                          widget.sharingId,
                                          widget._data[widget.index].parentId,
                                          Uuid().v1(),
                                          widget.username,
                                          widget._listController[widget.index]
                                              .text,
                                          false);

                                      widget._listController[widget.index]
                                          .clear();

                                      setState(() {
                                        showTextField = false;
                                      });
                                    },
                                  ),
                                  hintText: 'Reply'),
                              // expands: true,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentCreator {
  CommentCreator(String sharingId) {
    _comments.clear();
    var comments = [];

    Future<Command> command = RedisConnector.makeConnection();

    command.then((Command command) => command.send_object([
          'auth',
          '3TbP2wXJYB1oxANb6tVQwU8lRn0CmaPBF9YXZWb9CyU='
        ]).then((value) => command.send_object(
                ["lrange", sharingId, "0", "100"]).then((var response) async {
              if (response != null) {
                comments = response;
                comments.forEach((element) {
                  command.send_object(["hgetall", element.toString()]).then(
                      (value) {
                    String username = value[1];
                    String content = value[3];
                    bool isParent = value[5].toString().contains("true");

                    Comment comment = new Comment(
                        username, content, isParent, element.toString());
                    _comments.add(comment);
                    _controller.sink.add(_comments);
                  });
                });

                // _controller.sink.add(_comments);
              }
            })));
  }
  static loadComment(sharingId) {
    print(_comments.length);
    _comments.clear();
    var comments = [];

    Future<Command> command = RedisConnector.makeConnection();

    command.then((Command command) => command.send_object([
          'auth',
          '3TbP2wXJYB1oxANb6tVQwU8lRn0CmaPBF9YXZWb9CyU='
        ]).then((value) => command.send_object(
                ["lrange", sharingId, "0", "100"]).then((var response) async {
              if (response != null) {
                comments = response;
                comments.forEach((element) {
                  // print(comments.length);
                  command.send_object(["hgetall", element.toString()]).then(
                      (value) {
                    String username = value[1];
                    String content = value[3];
                    bool isParent = value[5].toString().contains("true");

                    Comment comment = new Comment(
                        username, content, isParent, element.toString());
                    _comments.add(comment);
                    // print(_comments.toString() + "here");
                    _controller.sink.add(_comments);
                  });
                });
              }
            })));
  }

  static addComment(String sharingId, String textId, String username,
      String content, bool isParent) {
    Future<Command> command = RedisConnector.makeConnection();

    command.then((Command command) => {
          command.send_object([
            'auth',
            '3TbP2wXJYB1oxANb6tVQwU8lRn0CmaPBF9YXZWb9CyU='
          ]).then((value) {
            command
                .send_object(['lpush', sharingId, textId]).then((var response) {
              return response != 0
                  ? command.send_object(['hset', textId, 'username', username])
                  : Future<int>(() => 0);
            });
          }).then((var response) {
            // print('response' + response);
            return command.send_object(['hset', textId, 'content', content]);
          }).then((var response) {
            return command.send_object(['hset', textId, 'isParent', 'true']);
          }).then((var response) {
            command.send_object(['hgetall', textId]).then((var respone) {
              // print(response);
            });
          }).then((value) {
            loadComment(sharingId);
          })
        });
  }

  static insertComment(String sharingId, String parentId, String commentId,
      String username, String content, bool isParent) {
    Future<Command> command = RedisConnector.makeConnection();

    command.then((Command command) => {
          command
              .send_object(
                  ['auth', '3TbP2wXJYB1oxANb6tVQwU8lRn0CmaPBF9YXZWb9CyU='])
              .then((value) => command.send_object(
                  ['linsert', sharingId, 'after', parentId, commentId]))
              .then((var response) {
                return response != 0
                    ? command
                        .send_object(['hset', commentId, 'username', username])
                    : Future<int>(() => 0);
              })
              .then((var response) {
                return response == 1
                    ? command
                        .send_object(['hset', commentId, 'content', content])
                    : Future<int>(() => 0);
              })
              .then((var response) {
                return response == 1
                    ? command.send_object(
                        ['hset', commentId, 'isParent', isParent.toString()])
                    : Future<int>(() => 0);
              })
              .then((var response) {
                command.send_object(['hgetall', commentId]).then((var respone) {
                  print(response);
                });
              })
              .then((value) {
                loadComment(sharingId);
              })
        });
  }

  static List<Comment> _comments = new List();

  static final _controller = StreamController<List<Comment>>.broadcast();

  Stream<List<Comment>> get stream => _controller.stream;
}

class RedisConnector {
  static RedisConnection conn = new RedisConnection();

  static void testConnection() {
    conn.connect('10.0.2.2', 6379).then((Command command) {
      command.send_object(["lrange", "childrenComment01", "0", "2"]).then(
          (var response) {
        print(response);
      });
    });
  }

  static Future<Command> makeConnection() {
    return conn.connect('ementor.redis.cache.windows.net', 6379);
  }
}

class Comment {
  final String parentId;
  final String username;
  final String content;
  final bool isParent;

  Comment(this.username, this.content, this.isParent, this.parentId);

  @override
  String toString() {
    // TODO: implement toString
    return '$username - $content - $isParent';
  }
}
