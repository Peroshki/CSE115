import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialshopper/add_friend.dart';

class Friend {
  String name;
  String uid;

  Friend.fromMap(Map<dynamic, dynamic> data)
    : name = data['name'],
      uid = data['uid'];
}

class Friends extends StatefulWidget {
  static String tag = "friends_list";
  _friendState createState() => _friendState();
}

Widget generateFriendWidget(String name) {
  return Card(
    child: ListTile(
      title: Text(name),
    ),
  );
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
      body: StreamBuilder(
        // TODO: Get the current users account to get their friends list
        stream: Firestore.instance.collection('users').document('S5xWtKZWyFYklveNY7jk7Qfnabf2').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Text('error');

          List<Friend> friends = List.from(snapshot.data['friends'].map((friend) => Friend.fromMap(friend)));

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return generateFriendWidget(friends[index].name);
            }
          );
        },
      ),
    );
  }
}
