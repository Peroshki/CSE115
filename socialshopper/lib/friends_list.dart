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
              Navigator.of(context).pushNamed(
                AddFriend.tag,
                arguments: ModalRoute.of(context).settings.arguments.toString()
              );
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
      body: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      'https://i.imgur.com/BoN9kdC.png')))),
                  title: Text(friends[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          //ensures user wants to delete this
                          return AlertDialog(
                            title: Text('Deleting friends'),
                            content: Text('Are you sure you want to delete: ${friends[index]}'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Delete'),
                                onPressed: (){
                                  friends.removeAt(index);
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        }
                      );},
                  )
                );
            }),
          );
  }
}
