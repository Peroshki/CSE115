import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:socialshopper/store_select.dart';
import 'package:uuid/uuid.dart';

import 'add_friend.dart';
import 'globals.dart' as globals;
import 'menu.dart';

/// A global instance of Firestore to use for StreamBuilders.
final Firestore databaseRef = Firestore.instance;

/// Creates a list using the provided data and writes it to the database.
Future<void> createRecord(
    String listName,
    String storeName,
    int budget,
    List<String> people,
    String id,
    List<String> ids,
    BuildContext context) async {
  // Add the primary user to the users array
  var users = [
    {'uid': ids[0], 'name': people[0]}
  ];

  // Add the rest of the shoppers to the users array
  for (int i = 1; i < ids.length; i++) {
    users.add({'uid': ids[i], 'name': people[i]});
  }

  // Set up a list with the users data and an empty items array
  await databaseRef.collection('lists').document(id.toString()).setData({
    'items': [],
    'metadata': {
      'uid': id,
      'timeCreated': DateTime.now(),
      'store': storeName,
      'name': listName,
      'budget': budget,
      'users': users
    }
  });

  // Put the list in an array so we can use arrayUnion
  final List<String> lists = [id];

  // Add the lists ID to every shoppers profile
  for (int i = 0; i < ids.length; i++)
    await databaseRef
        .collection('users')
        .document(ids[i].toString())
        .updateData({'lists': FieldValue.arrayUnion(lists)});
}

/// Alerts the user that a shopper is already part of their list.
Future<void> personInList(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: const Text('This person is already in the list!'));
      });
}

/// Sets up the page and the path to get to it.
class ListSetup extends StatefulWidget {
  static String tag = 'list-setup';

  @override
  _ListSetup createState() => _ListSetup();
}

/// Main Widget
class _ListSetup extends State<ListSetup> {
  Widget createShoppersWidget(List<String> users) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(Icons.person),
                      backgroundColor: globals.mainColor,
                      foregroundColor: Colors.white,
                    ),
                    Padding(
                      child: Text('${users[index]}'),
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  if (index - 1 < 0) return;

                  setState(() {
                    people.removeAt(index - 1);
                    ids.removeAt(index - 1);
                  });
                },
              )
            ],
          );
        });
  }

  /// Create an in app version of the friends list.
  Future<void> getFriends() async {
    final DocumentReference ref =
        Firestore.instance.collection('users').document(globals.userUID);
    final DocumentSnapshot user = await ref.get();

    final List<dynamic> friendsList = user.data['friends'];
    friends = friendsList;
  }

  /// Creates a pop up to add new participants.
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
                                } else {
                                  //Add the participants name to the people list
                                  people.add(friends[i]['name']);
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

  Widget getStoreSelectButton() {
    TextStyle tStyle = TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white);

    if (store == '') {
      return Text('Select Store', style: tStyle);
    }

    return Text('$store', style: tStyle);
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StoreSelect()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    if (result.toString() == 'false') return;
    store = result.toString();
  }

  /// Initializing variables used throughout the page.
  String name = '', part = '', id = '', store = '';
  int budget = -1;
  List<String> people = [];
  List<dynamic> friends = [];
  List<String> ids = [];

  @override
  Widget build(BuildContext context) {
    /// Unique ID generator
    final Uuid uuid = Uuid();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: globals.mainColor,
          centerTitle: true,
          title: const Text('New List'),
          automaticallyImplyLeading: true,
          actions: <Widget>[
            StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(globals.userUID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Text('Loading user data...');

                return IconButton(
                  padding: const EdgeInsets.only(right: 10.0),
                  icon: Icon(Icons.done),
                  onPressed: () {
                    if (store == '') {
                      return showDialog<void>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: const Text('Please select a store.'));
                          });
                    }

                    if (name == '') {
                      return showDialog<void>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: const Text(
                                    'Please give your list a name.'));
                          });
                    }

                    if (budget == -1) {
                      return showDialog<void>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: const Text(
                                    'Please give your list a budget.'));
                          });
                    }

                    ids.insert(0, globals.userUID);
                    people.insert(0, snapshot.data['displayName'].toString());

                    // Create a list with a unique ID.
                    createRecord(
                        name, store, budget, people, uuid.v4(), ids, context);
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 20.0),
                    child: RawMaterialButton(
                      onPressed: () {
                        _navigateAndDisplaySelection(context);
                      },
                      child: getStoreSelectButton(),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: globals.mainColor,
                      padding: const EdgeInsets.all(50.0),
                    ),
                  ),
                  Container()
                ],
              ),

              Divider(
                thickness: 1.0,
                color: Colors.black,
              ),

              /// Input for list name
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 45.0),
                child: TextField(
                  onChanged: (String value) {
                    name = value;
                    print(name);
                  },
                  autocorrect: true,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Name',
                  ),
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
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
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      '\$',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 10.0, bottom: 20.0),
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(6),
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        onChanged: (String value) {
                          if (value == '') {
                            budget = -1;
                            return;
                          }

                          budget = int.parse(value);
                        },
                        autocorrect: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Budget',
                        ),
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w600),
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
                padding: const EdgeInsets.only(top: 25.0, left: 47.5),
                child: Text(
                  'Shoppers: ',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
                ),
              ),

              Divider(
                thickness: 1.0,
                color: Colors.transparent,
              ),

              StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(globals.userUID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Text('Loading user data...');

                  List<String> users = [];
                  print(snapshot.data['displayName'].toString());
                  users.add(snapshot.data['displayName']);

                  for (String p in people) {
                    users.add(p);
                  }

                  return createShoppersWidget(users);
                },
              ),

              Divider(
                thickness: 5.0,
                color: Colors.transparent,
              ),

              /// Button to add new participants to the list.
              Center(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () async {
                    await getFriends();
                    createAlert(context);
                  },
                  padding: const EdgeInsets.all(12),
                  color: globals.mainColor,
                  child: Text('Add Shopper',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        )
      );
  }
}
