/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///      This file creates the basic list settings page of the app before any items can be added to it.
/// All of the metadata collected from this page is put into a new list on the database with the list ID as it's
/// name. This is for our convinience because it allows for the app to easily find the lists the users made
/// in the database instead of searching by individual list names.
///
///   This file still needs some work. Here are the things it needs:
/// * The file needs to look at all pre-existing list data and properly create a new List ID that is unique.
///   Right now this is random, which is bad because it can overwrite other peoples lists.
/// * There should be a functionality to add users in our database into the list instead of just using a text box
/// * This should also get the store in the future and display that to the database.
/// * The files time stamp looks strange, and I don't know how to parse it to become a timestamp in firebase.
////////////////////////////////////////////////////////////////////////////////////////////////////////////

import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'menu.dart';
import 'menu.dart' as globals;

// Creates an instance in the database
final databaseRef = Firestore.instance;

// Generates a widget for each friend currently in the list
Widget generateFriendWidget(String name) {
  return ListTile(
    title: Text('hi'),
    leading: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        const Text(
          'Shopper'
        ),
      ],
    ),
    trailing: IconButton(
      icon: Icon(Icons.cancel),
    ),
  );
}

List<Widget> generateFriendWidgets(friends) {
  List<Widget> widgets = List();

  for (var friend in friends) {
    widgets.add(
      ListTile(
        title: Text(friend['name']),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {

          },
        ),
      )
    );
  }

  return widgets;
}

// Generates a widget to show the user's display name
Widget generateUsernameWidget(String name) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        name,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
      const Text(
        'List Owner',
      ),
    ],
  );
}

/// Creates a pop up to add new participants.
Future<void> createAlert(BuildContext context, friends) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: generateFriendWidgets(friends)
          )
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('DONE'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
  );
}

// functions used to record user data -> database
void createRecord(String listName, int budget, List<String> people, String id) async {
  await databaseRef.collection('lists').document(id.toString()).setData({
    'items' : [
      {
        'name': 'Banana',
        'quantity': 2,
        'price': 4,
        'users': [
          'Alan',
          'Omar'
        ]
      }
    ],
    'metadata': {
      'uid': id,
      //Gets the timestamp
      'timeCreated': DateTime.now(), // Change this. We don't need the precision of milliseconds since epoch
      'store': 'Safeway', // I don't know how to pass in the store select input
      'name': listName,
      'budget': budget,
      'users': people
    }
  });
  globals.numList.add(id);
}

//Sets up the page and the path to get to it.
class ListSetup extends StatefulWidget {
  static String tag = 'list-setup';
  @override
  _ListSetup createState() => _ListSetup();
}

//Main Widget
class _ListSetup extends State<ListSetup> {
  /// Local variables
  String name, part, uid, filter = '';
  List<Map<String, String>> people = List();
  int budget = 0;

  /// Resets the view when the filter is updated.
  void getFilter(String value) {
    filter = value;
  }

  /// Updates the name of the file.
  void getName(String value) {
    name = value;
  }

  /// Gets the name of the participants you're adding.
  void getPeople(String value) {
    part = value;
  }

  /// Gets the budget.
  void getBudget(String value) {
    budget = int.parse(value);
  }

  /// Puts the participants into the list of people
  void addPerson(Map<String, String> person) {
    for (Map<String, String> p in people) {
      if (p['uid'] == person['uid'])
        return;
    }

    people.add(person);
    print(people.map((f) => f['name']).toList().toString());
  }

  @override
  Widget build(BuildContext context) {
    /// A generator for random document names
    final Uuid uuid = Uuid();

    /// Focus nodes to make UI transition seamless
    FocusNode budgetNode = FocusNode();

    return Scaffold(
      //Top bar of the app
      appBar: AppBar(
        centerTitle: true,
        title: const Text('List Setup'),
        automaticallyImplyLeading: true,
      ),

      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: StreamBuilder(
          stream: databaseRef.collection('users').document(
              ModalRoute.of(context).settings.arguments.toString()
          ).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Text('Loading user data...');

            var data = snapshot.data;

            List<dynamic> friends = data['friends'];

            addPerson({'name': data['displayName'], 'uid': data['uid']});

            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'List Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                    )
                  ),
                ),

                //Allows the user to enter the name of the list.
                Container(
                  child: TextField(
                    onChanged: (String value) {
                      getName(value);
                    },
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      // Once the user presses the 'next' button, focus on the budget
                      FocusScope.of(context).requestFocus(budgetNode);
                    },
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: 'Name the List',
                    ),
                  ),
                ),

                ListTile(
                  title: Text('Budget',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 20,
                      )
                  ),
                ),

                // Allows user to set the budget.
                Container(
                  child: TextField(
                    focusNode: budgetNode,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      getBudget(value);
                    },
                    decoration: InputDecoration(
                      hintText: '0',
                    ),
                  ),
                ),

                ListTile(
                  title: Text('Add Participants',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 20,
                      )
                  ),
                ),

                generateUsernameWidget(data['displayName']),

                //Button to add new participants to the list.
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    createAlert(context, friends);
                  },
                  padding: const EdgeInsets.all(12),
                  color: Colors.lightBlueAccent,
                  child: Text('Add New Member',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ),
      ),
      // Button to move to the next page.
      // Have it routed to main because I don't know where the list propogation is going to be held.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          List<String> peoples = people.map((f) => f['name']);
          createRecord(name, budget, peoples,
              uuid.v4()); // Instead of a random number, create a uid for the list.
          Navigator.of(context).pushNamed(MenuPage.tag);
        },
        tooltip: 'New List',
        child: Icon(Icons.done),
      ),
    );
  }
}
