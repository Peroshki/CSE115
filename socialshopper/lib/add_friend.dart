///  add_friend.dart:
///
///  Contains the view for adding a user to your friend list.
///  You can search for user names with the live search bar at the top.
///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'globals.dart' as globals;

class AddFriend extends StatefulWidget {
  static String tag = 'add_friend';

  @override
  _AddFriendState createState() => _AddFriendState();
}

/// Add a user to your friend list and update the database accordingly
void addFriend(data, BuildContext context) {
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

      // Grab the data of the friend being added,
      // and set their name to their uid if they do not have a display name
      final String uid = data['uid'].toString();
      final String name = data['displayName'] ?? uid;
      final String photo = data['photoURL'] ?? globals.anonPhoto;

      // Create a new entry for the friend you wish to add
      final Map<String, String> friend = <String, String>{
        'name': name,
        'uid': uid,
        'photo': photo
      };

      friendsList.add(friend);

      // Update the users friends list
      await postRef.updateData({'friends': friendsList});
    }
  });
}

/// Generates an alert to notify the user when another user
/// was successfully added to their friends list
void generateSuccessDialog(String name, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('$name was successfully added to your friends list.'),
        actions: <Widget>[
          FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
        ],
      );
    }
  );
}

/// Generate an alert dialog which appears when attempting to add a friend
void generateAlertDialog(data, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Friend'),
        content: Text(
            'Would you like to add ${data['displayName']} to your friends list?'),
        actions: <Widget>[
          FlatButton(
              child: const Text('Add'),
              onPressed: () async {
                /// If the user selects 'YES', add the selected user to
                /// your friends list and back out of the alert dialog
                addFriend(data, context);
                Navigator.of(context).pop();
                generateSuccessDialog(data['displayName'], context);
              }
          ),
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  );
}

/// Generates a widget for each user in the database to search through
Widget generateUserWidget(data, BuildContext context) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(data['photoURL'] ?? globals.anonPhoto),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        // If they do not have a display name, display 'invalid user name'
        data['displayName'] ?? 'Invalid user name'),
      onTap: () {
        generateAlertDialog(data, context);
      },
    ),
  );
}

class _AddFriendState extends State<AddFriend> {
  /// Holds the user's text input to filter against user names from the database
  String filter = '';

  /// Resets the view when the filter is updated
  void getFilter(String value) {
    setState(() {
      filter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.mainColor,
        title: const Text('Add a Friend')),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').document(globals.userUID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Text('Loading user data.');

          String displayName = snapshot.data['displayName'].toString();
          List<dynamic> friends = snapshot.data['friends'].toList();

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 15.0,
                      left: 20.0,
                      right: 20.01
                    ),
                    hintText: "Search",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: globals.mainColor),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    )
                  ),
                  onChanged: (String value) {
                    /// When the text input changes, update the filter
                    getFilter(value);
                  },
                ),
              ),

              StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  /// If the collection has no data, return an error message
                  if (!snapshot.hasData) return const Text('Loading user data.');

                  /// Grab the list of documents from the collection
                  final List<DocumentSnapshot> documentList =
                  snapshot.data.documents;

                  return Flexible(
                    child: ListView.builder(
                      itemCount: documentList.length,
                      itemBuilder: (context, index) {
                        if (documentList[index].data['displayName'] == displayName)
                          return Container();

                        for (var friend in friends) {
                          if (documentList[index].data['displayName'] == friend['name']) {
                            return Container();
                          }
                        }

                        /// Check the username against the filter, and only display
                        /// user names which match a sub-sequence of the filter
                        return filter == null || filter == ""
                        ? generateUserWidget(documentList[index].data, context)
                        : documentList[index].data['displayName'].toLowerCase().contains(filter)
                        ? generateUserWidget(documentList[index].data, context)
                        : Container();
                      }
                    )
                  );
                }
              )
            ]
          );
        }
      )
    );
  }
}
