//
///  add_friend.dart:
///
///  Contains the view for adding a user to your friend list.
///  You can search for user names with the live search bar at the top.
//

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFriend extends StatefulWidget {
  static String tag = 'add_friend';

  @override
  _AddFriendState createState() => _AddFriendState();
}

/// Add a user to your friend list and update the database accordingly
void addFriend(data){
  // TODO: Grab the current user's page from the database
  // TODO: Add the selected user's uid to the current user's friend list
  // TODO: May require passing in the current user's uid as a parameter
  print(data['uid']);
}

/// Generates an alert to notify the user when another user
/// was successfully added to their friends list
void generateSuccessDialog(String name, BuildContext context) {
  final Widget alert = AlertDialog(
    title: Text('$name was successfully added to your frineds list?'),
    actions: <Widget>[
      FlatButton(
        child: const Text('OK'),
        onPressed: () {
          Navigator.of(context).pop();
        }
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (context) {
      return alert;
    }
  );
}

/// Generate an alert dialog which appears when attempting to add a friend
void generateAlertDialog(data, BuildContext context) {
  final Widget alert = AlertDialog(
    title: Text('Would you like to add ${data['email']} to your frineds list?'),
    actions: <Widget>[
      FlatButton(
        child: const Text('YES'),
        onPressed: () async {
          /// If the user selects 'YES', add the selected user to
          /// your friends list and back out of the alert dialog
          addFriend(data);
          Navigator.of(context).pop();
          generateSuccessDialog(data['email'], context);
        }
      ),
      FlatButton(
        child: const Text('NO'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (context) {
      return alert;
    }
  );
}

/// Generates a widget for each user in the database to search through
Widget generateUserWidget(data, BuildContext context) {
  return Card(
    child: ListTile(
      title: Text(data['email']),
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
        title: const Text('Add a Friend')
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter a username'
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
              if (!snapshot.hasData)
                return const Text('error');

              /// Grab the list of documents from the collection
              final List<DocumentSnapshot> documentList = snapshot.data.documents;

              return Flexible(
                child: ListView.builder(
                  itemCount: documentList.length,
                  itemBuilder: (context, index) {
                    /// Check the username against the filter, and only display
                    /// user names which match a sub-sequence of the filter
                    return filter == null || filter == "" ?
                    generateUserWidget(documentList[index].data, context) :
                    documentList[index].data['email'].toLowerCase().contains(filter) ?
                    generateUserWidget(documentList[index].data, context) :
                    Container();
                  }
                )
              );
            },
          )
        ],
      ),
    );
  }
}