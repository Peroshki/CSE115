import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialshopper/add_friend.dart';

import 'globals.dart' as globals;

class Friends extends StatefulWidget {
  static String tag = "friends_list";

  _friendState createState() => _friendState();
}

List<globals.Friend> friends;

void removeFriend(String name) {
  Firestore.instance.runTransaction((Transaction tx) async {
    // Grab the users document from the 'users' collection
    final DocumentReference postRef =
    Firestore.instance.collection('users').document(globals.userUID);

    final DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      var doc = postSnapshot.data;

      // Grab the users friends list from their user page
      List<dynamic> friendsList = List();
      friendsList = doc['friends'].toList();
      print(friendsList.toString());
      friendsList.removeWhere((item) => item['name'] == name);
      print(friendsList.toString());

      // Update the users friends list
      await postRef.updateData({'friends': friendsList});
    }
  });
}

Widget generateFriendWidget(String name, String photo, BuildContext context) {
  return Card(
    child: ListTile(
      onLongPress: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            //ensures user wants to delete this
            return AlertDialog(
              title: Text('Delete Friend'),
              content: Text('Are you sure you want to remove $name from your friend list?'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: globals.mainColor
                    ),
                  ),
                  onPressed: () {
                    //removes from database
                    removeFriend(name);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: globals.mainColor
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(photo ?? globals.anonPhoto),
        backgroundColor: Colors.transparent,
      ),
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
        backgroundColor: globals.mainColor,
        title: Text('Friends'),
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
        stream: Firestore.instance.collection('users').document(globals.userUID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('error');

          friends = List.from(snapshot.data['friends'].map((friend) => globals.Friend.fromMap(friend)));

          if (friends.isEmpty){
            return Center(
              child: const Text('Press + to add a friend.'),
            );
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return generateFriendWidget(
                friends[index].name, friends[index].photo, context);
            }
          );
        },
      ),
    );
  }
}
