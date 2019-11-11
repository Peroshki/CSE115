import 'package:flutter/material.dart';
import 'add_friend.dart';

class Friends extends StatefulWidget {
  static String tag = "friends_list";
  _friendState createState() => _friendState();
}

class _friendState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Friends"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddFriend.tag);
            },
          )
        ],
      ),
    );
  }
}
