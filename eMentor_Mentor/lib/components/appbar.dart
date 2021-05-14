import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final Widget leading, title;
  final List<Widget> action;
  const MyAppBar({this.leading, this.title, this.action});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      // backgroundColor: Colors.lightGreen[300],
      leading: leading,
      title: title,
      actions: action,
    );
  }
}
