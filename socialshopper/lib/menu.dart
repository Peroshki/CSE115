import 'dart:ffi';

import 'package:flutter/material.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'list_views.dart';
import 'store_select.dart';
import 'creating_new_list.dart';
import 'app_settings.dart';
import 'profile.dart';
import 'package:flutter/src/material/page.dart';

class MenuPage extends StatefulWidget {
  // Changes state of menupage
  static String tag = 'menu-page';
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void listPress(int index) {
    // click on list

    setState(() {
      _selectedIndex = index;
    });
  }

  // String _textString = 'Hello There';

  // void _doSomething(String text) {
  //   setState(() {
  //     _textString = text;
  //   });
  // }

  final List<String> _numList = []; //Array to hold the list names

  void putNamesOfListInAList() async {
    // Updates array with the lists in database
    final QuerySnapshot results =
        await Firestore.instance.collection('lists').getDocuments();
    final List<DocumentSnapshot> docs = results.documents;

    var i = 0;
    var val = "";

    if (_numList.length < docs.length || _numList.length > docs.length) {
      _numList.clear();
      while (i < docs.length) {
        val = docs.elementAt(i).documentID;
        _addNewList(val);
        i++;
      }
    }
  }

  void createRecord(String listName) async {
    // functions used to record user data -> database
    await databaseRef
        .collection("lists") // In Collection 'lists'
        .document(listName) // name of the list
        .setData({
      'title': 'Mastering Firestore'
    }); // These are test, later will add the items to the list


  void _doSomething(String text) {
    setState(() {
      _textString = text;
    });
  }

  void getDataFromDatabase() {
    // This doesn't work yet
    // Get Items and Price from DataBase
    databaseRef.collection("lists");
  }

  void deleteList(int index) {
    // Deletes list from database and updates array
    databaseRef.collection('lists').document(_numList[index]).delete();
    putNamesOfListInAList();
  }
<<<<<<< HEAD

  void _addNewList(String task) {
    // Adds List name to array
=======
  void _addNewList(String task) { // Adds List name to array

>>>>>>> b14507a0fc967735d4e8c2d4cb835ba198d548b6
    //allows to change state of the list appearing
    if (task.isNotEmpty) {
      setState(() => _numList.add(task));
    }
  }

  // void _getIndex(int index) {
  //   //change state of list
  //   setState(() => _numList.elementAt(index));
  // }

  void _openList(int index) {
    // Opens up a single list
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_numList[index]),
        ),
        body: ListViews(),
      );
    }));
  }

<<<<<<< HEAD
  Widget _buildList() {
    // This builds list of all the lists
=======

  Widget _buildList() { // This builds list of all the lists
>>>>>>> b14507a0fc967735d4e8c2d4cb835ba198d548b6
    putNamesOfListInAList();
    return ListView.builder(itemBuilder: (context, index) {
      if (index < _numList.length) {
        return _buildTodoItem(_numList[index], index);
      }
    });
  }

<<<<<<< HEAD
  void alertBoxForList(int index) {
    // Displays an alert box before deleting list
=======

  void alertBoxForList(int index) { // Displays an alert box before deleting list
>>>>>>> b14507a0fc967735d4e8c2d4cb835ba198d548b6
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

  Widget _buildTodoItem(String listName, int index) {
    // Interaction with lists
    return Card(
        child: ListTile(
<<<<<<< HEAD
      title: Text(listName),
      onTap: () {
        // opens the list
        setState(() {
          _openList(index);
        });
      },
      onLongPress: () {
        // this deletes item from list view and from database
        setState(() {
          alertBoxForList(index);
        });
      },
    ));
=======
            title: Text(listName),
            onTap: () { // opens the list
              setState(() {
                _openList(index);
              });
            },
            onLongPress: (){ // this deletes item from list view and from database
              setState(() {
              alertBoxForList(index); 
              });
            },));

>>>>>>> b14507a0fc967735d4e8c2d4cb835ba198d548b6
  }

  void _tapAddMoreItems() {
    // This opens up a new page to add name of new list and creats list
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well
        // as adding a back button to close it
        MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text('Add a new task')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              createRecord(val); // puts List in database

              Navigator.pop(context); // Close the add todo screen
            },
            decoration: InputDecoration(
                hintText: 'Enter List Name',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold is the main container for main page
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

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return Settings();
      case 1:
        return Scaffold(
          //Scaffold is the main container for main page
          appBar: AppBar(
            //title bar at the top of the page
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
                    Navigator.of(context).pushNamed(StoreSelect.tag);
                  }),
            ],
            automaticallyImplyLeading: false,
          ),
          body: _buildList(),
          floatingActionButton: FloatingActionButton(
            onPressed: _tapAddMoreItems,
            tooltip: 'Name List',
            child: Icon(Icons.add),
          ),
        );
      case 2:
        return Profile();
    }
    return Center(
      child: const Text('No body for selected tab'),
    );
  }
}
