/*
* In this folder you can create a new list and at it to the database.
* You can delete a list from the database; it warns you if you want to fully
* delete or cancel.
* You can open a new list.
* You can add an item to a new list. 
* Specifing the item name, price, and quanitity. 
*/

// import 'dart:convert';
// import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socialshopper/list_setup.dart';
import 'app_settings.dart';
import 'globals.dart' as globals;
import 'list_views.dart';
import 'profile.dart';
import 'store_select.dart';
import 'package:flutter/src/material/page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_input.dart';

//var documentId = '';
List<String> numList = new List(); //Array to hold the list names
List<String> userNames = new List();

//FireBase stuff
final databaseRef = Firestore.instance; //creating an instance of database
var documentName = '';
List<DocumentSnapshot> myLists;

class callUser {
  static void getUsersOfList() async {
    userNames.clear();
    List<String> test = new List();
    final DocumentReference ref =
        Firestore.instance.collection('lists').document(documentName);
    DocumentSnapshot doc = await ref.get();
    Map<dynamic, dynamic> tags = doc.data['metadata'];
    tags.remove('name');
    tags.remove('uid');
    tags.remove('timeCreated');
    tags.remove('store');
    tags.remove('budget');
    tags.forEach((Key, value) => test.add(value.toString()));
    print(test);
    String values = test.elementAt(0);
    print(values);
    List<String> k = values.split(new RegExp(r'(\W+)'));

    for (int i = 0; i < k.length; i++) {
      if (i > 0 && i < k.length - 1) {
        userNames.add(k.elementAt(i));
      }
    }
    //print(userNames);
  }
}

//State of MenuPage
class MenuPage extends StatefulWidget {
  static String tag = 'menu-page';

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 1;
  String userId;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Function to click on a single list
  void listPress(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // updates the app with list in the database
  void putNamesOfListInAList() async {
    // Grab the users document according to their uid
    final DocumentSnapshot user = await Firestore.instance
        .collection('users')
        .document(ModalRoute.of(context).settings.arguments.toString())
        .get();
    userId = ModalRoute.of(context).settings.arguments.toString();
    final QuerySnapshot results =
        await Firestore.instance.collection('lists').getDocuments();

    // Only add the lists to numLists which belong to the user
    final List<DocumentSnapshot> docs = List<DocumentSnapshot>();

    //Check if user has data
    if (user.data != null) {
      if (user.data['lists'] != null) {
        for (String list in user.data['lists']) {
          docs.add(
              results.documents.where((doc) => doc.documentID == list).first);
        }

        var i = 0;
        var val = '';

        if (numList.length < docs.length || numList.length > docs.length) {
          numList.clear();
          while (i < docs.length) {
            val = docs.elementAt(i).documentID;
            //documentId = docs.elementAt(i).documentID;
            _addNewList(val);
            i++;
          }
        }
      }
    }
  }

// Add a new list to the database created by user
  void createRecord(String listName) async {
    await databaseRef.collection("lists").document(listName);
  }

// Deletes list from database and updates array
  void deleteList(int index) async {
    String user = ModalRoute.of(context).settings.arguments.toString();

    String listID = myLists[index].documentID;

    List temp = List();
    DocumentSnapshot snap =
    await databaseRef.collection('users').document(user).get();
    temp = List.from(snap['lists']);
    temp.removeWhere((item) => item == listID);
    await Firestore.instance
        .collection('users')
        .document(user)
        .updateData({'lists': temp});

    databaseRef.collection('lists').document(listID).delete();
  }

//allows to change state of the list appearing
  void _addNewList(String task) {
    if (task.isNotEmpty) {
      setState(() => numList.add(task));
    }
  }

  void _getIndex(int index) {
    //change state of list
    setState(() => numList.elementAt(index));
  }

  void _openList(int index, String name) {
    // Open up a single list
    documentName = myLists[index].documentID;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: ListViews(listName: documentName),
      );
    }));
  }

//This is the whole list
  Widget _buildList() {
    putNamesOfListInAList();
    return StreamBuilder(
      stream: Firestore.instance.collection('lists').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Only display the lists that belong to the user
        List<DocumentSnapshot> lists = snapshot.data.documents;
        myLists = List();
        for (var list in lists) {
          Map<dynamic, dynamic> metadata = list.data['metadata'];
          if (metadata.containsKey('users') && (metadata['users'].length != 0)) {
            for (var user in metadata['users']) {
              print(user.toString());
              if (user is Map && user.containsValue(globals.userUID)) {
                myLists.add(list);
              }
            }
          }
        }

        if (myLists.isEmpty) {
          return Center(
            child: Text(
                'Press + to add a new list.'
            ),
          );
        }

        return ListView.builder(
            itemCount: myLists.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(myLists[index].data['metadata']['name']),
                  onTap: () {
                    _openList(index, myLists[index].data['metadata']['uid']);
                  },
                  onLongPress: () {
                    alertBoxForList(index);
                  },
                ),
              );
            });
      },
    );
  }

// Displays an alert box before deleting list
  void alertBoxForList(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete List?"),
          content: new Text("This will permanelty delete the list."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"), // Cancel button
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Accept"), // Deletes list
              onPressed: () {
                setState(() {
                  deleteList(index);
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _tapAddMoreItems() {
    Navigator.of(context).push<dynamic>(
        // MaterialPageRoute will automatically animate the screen entry, as well
        // as adding a back button to close it
        MaterialPageRoute<dynamic>(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text('Add a new task')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              //_addNewList(val);
              //putNamesOfListInAList();
              createRecord(val); // puts List in database
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: InputDecoration(
                hintText: 'Enter List Name',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

//Scaffold is the main container for main page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text('Lists'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind), title: Text('Profile'))
        ],
      ),
    );
  }

//Menu Page
  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return Settings();
      case 1:
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Lists'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: null,
              ),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      ListSetup.tag
                    );
                  }),
            ],
            automaticallyImplyLeading: false,
          ),
          body: _buildList()
        );
      case 2:
        return Profile();
    }
    return Center(
      child: const Text('No body for selected tab'),
    );
  }
}
