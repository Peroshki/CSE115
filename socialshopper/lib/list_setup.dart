import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_friend.dart';
import 'globals.dart' as globals;
import 'menu.dart';
import 'menu.dart' as menu;

//Creates an instance in the database
final databaseRef = Firestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;

class Arguments {
  final String userId;
  Arguments(this.userId);
}

// functions used to record user data -> database
void createRecord(String listName, int budget, List<String> people, String id, List<String> ids, BuildContext context) async {
  var users = [{'uid' : ids[0], 'name' : people[0]}];
  for (int i = 1; i < ids.length; i++) {
    users.add({'uid' : ids[i], 'name': people[i]});
  }
  //print(users);

  //Sets up the initial list and it's data in the database.
  await databaseRef.collection('lists').document(id.toString()).setData({
    'items': [{}],
    'metadata': {
      'uid': id, //Gets the timestamp
      'timeCreated': DateTime.now(), // Change this. We don't need the precision of milliseconds since epoch
      'store': 'Safeway', // I don't know how to pass in the store select input
      'name': listName,
      'budget': budget,
      'users': users
    }
  });
  menu.numList.add(id);

  //Puts the list data in the list section.
  List<String> lists = [id];

  for(int i = 0; i < ids.length; i++)
      await databaseRef.collection('users').document(ids[i].toString()).updateData({'lists': FieldValue.arrayUnion(lists)});
}

void putInListsDatabase(String listId, List<String> ids) async {
  for (int i = 0; i < ids.length; i++) {
    await databaseRef
        .collection('users')
        .document(ids[i])
        .updateData({'lists': listId});
  }
}

//Sets up the page and the path to get to it.
class ListSetup extends StatefulWidget {
  static String tag = 'list-setup';
  @override
  _ListSetup createState() => _ListSetup();
}

//Main Widget
class _ListSetup extends State<ListSetup> {
  //Initializing variables used throughout the page.
  String name = '', part = '', id = '';
  int budget = -1;
  List<String> people = [];
  List<dynamic> friends = [];
  List<String> ids = [];
  // When we get proper user data, this will be empty and the user will be
  // manually added.
  //Gets the name of the file.
  void getName(String value) {
    setState(() {
      name = value;
    });
  }
  initUser() async {
    user = await _auth.currentUser();
    return user;
  }
  //Gets the name of the participants you're adding.
  void getPeople(String value) {
    setState(() {
      part = value;
    });
  }

  //Gets the budget.
  void getBudget(String value) {
    setState(() {
      budget = int.parse(value);
    });
  }

  //Puts the participants into the list of people
  void onPressed(String name) {
    setState(() {
      people.add(name);
    });
  }

  //Create an in app version of the friends list.
  Future<void> getFriends() async {
    final ref = Firestore.instance
        .collection('users')
        .document(globals.userUID);
    DocumentSnapshot user = await ref.get();
    List<dynamic> friendsList = user.data['friends'];
    friends = friendsList;
  }

  Future<void> personInList(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: const Text('You Already Have This Member.'));
        });
  }

  //Creates a pop up to add new participants.
  Future<void> createAlert(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Container(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                      child: Column(children: <Widget>[

                    //Allows user to get friends from their list
                    Container(
                      child: Column(children: [
                        //For Loop creates tiles for all of the friends to appear on the alert dialog
                        for (int i = 0; i < friends.length; i++)
                          GestureDetector(
                              child: ListTile(title: Text(friends[i]['name'])),
                              onTap: () {
                                //If the person is already in the list don't add them again
                                if (people.contains(friends[i]['name'])) {
                                  Navigator.of(context).pop();
                                  personInList(context);
                                } 
                                else {
                                  //Add the participants name to the people list
                                  onPressed(friends[i]['name']);
                                  //Adds the participant's user ID to another list to use later.
                                  setState(() {
                                    ids.add(friends[i]['uid']);
                                  });
                                  //Leave the alert dialog
                                  Navigator.of(context).pop();
                                }
                              })
                      ]),
                    ),

                    //Navigates to the add friends page
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AddFriend.tag);
                      },
                      padding: const EdgeInsets.all(12),
                      color: Colors.lightBlueAccent,
                      child: Text('Add New Friends',
                          style: TextStyle(color: Colors.white)),
                    )
                  ]))));
        });
  }

  @override
  Widget build(BuildContext context) {
    //initUser();
    final Uuid uuid = Uuid();
    return Scaffold(
      //Top bar of the app
      appBar: AppBar(
        centerTitle: true,
        title: const Text('New List'),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection('users').document(globals.userUID).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Text('Loading user data...');

              //return Text('${snapshot.data['displayName'].toString()}');

              return IconButton(
                padding: const EdgeInsets.only(
                    right: 10.0
                ),
                icon: Icon(Icons.done),
                onPressed: () {
                  setState(() {
                    ids.add(globals.userUID);
                    people.add(snapshot.data['displayName'].toString());
                  });

                  createRecord(name, budget, people,
                      uuid.v4(), ids, context); // Instead of a random number, create a uid for the list.
                  Navigator.of(context).pushNamed(
                    MenuPage.tag,
                    arguments: globals.userUID,
                  );
                },
              );
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// Input for list name
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              bottom: 20.0,
              left: 60.0
            ),
            child: TextField(
              onChanged: (String value) {
                getName(value);
              },
              autocorrect: true,
              decoration: InputDecoration.collapsed(
                hintText: 'Name',
              ),
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600
              ),
            ),
          ),

          Divider(
            thickness: 1.0,
            color: Colors.black,
          ),

          /// Input for budget
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 20.0
                ),
                child: Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    left: 10.0,
                    bottom: 20.0
                  ),
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      getName(value);
                    },
                    autocorrect: true,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Budget',
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            ],
          ),

          Divider(
            thickness: 1.0,
            color: Colors.black,
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0
            ),
            child: Text(
              'Shoppers: ',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),

          StreamBuilder(
            stream: Firestore.instance.collection('users').document(globals.userUID).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Text('Loading user data...');

              return Text('${snapshot.data['displayName'].toString()}');
            },
          )
        ],
      ),
//      Container(
//          padding: const EdgeInsets.all(32.0),
//          child: Center(
//            child: Column(
//              children: <Widget>[
//                ListTile(
//                  title: Text('List Name',
//                      style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        decoration: TextDecoration.underline,
//                        fontSize: 20,
//                      )),
//                ),
//
//                //Allows the user to enter the name of the list.
//                Container(
//                  child: TextField(
//                    onChanged: (String value) {
//                      getName(value);
//                    },
//                    autocorrect: true,
//                    decoration: InputDecoration(
//                      hintText: 'Name the List',
//                    ),
//                  ),
//                ),
//
//                ListTile(
//                  title: Text('Set Budget',
//                      style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        decoration: TextDecoration.underline,
//                        fontSize: 20,
//                      )),
//                ),
//
//                // Allows user to set the budget.
//                Container(
//                  child: TextField(
//                    keyboardType: TextInputType.number,
//                    onChanged: (String value) {
//                      getBudget(value);
//                    },
//                    decoration: InputDecoration(
//                      hintText: '0',
//                    ),
//                  ),
//                ),
//
//                ListTile(
//                  title: Text('Other Participants',
//                      style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        decoration: TextDecoration.underline,
//                        fontSize: 20,
//                      )),
//                ),
//
//                //Displays the people in the list.
//                Expanded(
//                    child: ListView.builder(
//                      itemCount: people.length,
//                      itemBuilder: (context, int index) {
//                        return Row(
//                          textDirection: TextDirection.rtl,
//                          children: <Widget>[
//                            //Creates the button to remove participants from the list.
//                            Expanded(
//                                child: FlatButton(
//                                    onPressed: () {
//                                      setState(() {
//                                        people.removeAt(index);
//                                      });
//                                      setState(() {
//                                        ids.removeAt(index);
//                                      });
//                                    },
//                                    child: Align(
//                                      alignment: Alignment.centerRight,
//                                      child: const Text(
//                                        'Remove',
//                                        style: TextStyle(
//                                            fontSize: 15.0, color: Colors.red),
//                                      ),
//                                    ))),
//
//                            //Displays the names of the participants on screen
//                            Expanded(
//                              child: ListTile(title: Text(people[index])),
//                            ),
//                          ],
//                        );
//                      },
//                    )
//                  ),
//
//                //Button to add new participants to the list.
//                RaisedButton(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(24),
//                  ),
//                  onPressed: () async {
//                    await getFriends();
//                    createAlert(context);
//                  },
//                  padding: const EdgeInsets.all(12),
//                  color: Colors.lightBlueAccent,
//                  child: Text('Add New Member',
//                      style: TextStyle(color: Colors.white)),
//                ),
//              ],
//            ),
//          )),
      // Button to move to the next page.
      // Have it routed to main because I don't know where the list propogation is going to be held.
      floatingActionButton: FloatingActionButton(
        //Puts the User Id in the list of IDs
        onPressed: () {
          setState(() {
            ids.add(user.uid);
          });
          
          createRecord(name, budget, people,
              uuid.v4(), ids, context); // Instead of a random number, create a uid for the list.
          Navigator.of(context).pushNamed(
            MenuPage.tag,
            arguments: user.uid,
          );
        },
        tooltip: 'New List',
        child: Icon(Icons.done),
      ),
    );
  }
}
