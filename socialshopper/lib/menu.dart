/*
* In this folder you can create a new list and at it to the database.
* You can delete a list from the database; it warns you if you want to fully
* delete or cancel.
* You can open a new list.
* You can add an item to a new list. 
* Specifing the item name, price, and quanitity. 
*/ 

import 'package:flutter/material.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'app_settings.dart';
import 'list_views.dart';
import 'profile.dart';
import 'store_select.dart';
import 'package:flutter/src/material/page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var temp = '';
//FireBase stuff
final databaseRef = Firestore.instance; //creating an instance of database

class MenuPage extends StatefulWidget {
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


  final List<String> _numList = []; //Array to hold the list names

  void putNamesOfListInAList() async {
    // updates the app with list in the database
    final QuerySnapshot results =
        await Firestore.instance.collection('lists').getDocuments();
    final List<DocumentSnapshot> docs = results.documents;

    var i = 0;
    var val = "";

    if (_numList.length < docs.length || _numList.length > docs.length) {
      _numList.clear();
      while (i < docs.length) {
        val = docs.elementAt(i).documentID;
        temp = docs.elementAt(i).documentID;
        _addNewList(val);
        i++;
      }
    }
  }

  void createRecord(String listName) async {
    // functions used to record user data -> database
    await databaseRef.collection("lists").document(listName);
  }

// This functions populates a list with new items and updates database
  void addItemsToList(String name, String item, String price, String quantity) async {
    DocumentReference ref =
        Firestore.instance.collection('lists').document(name);
    DocumentSnapshot doc = await ref.get();
    List tags = doc.data['items'];
    ref.updateData({
      'items': FieldValue.arrayUnion([
        {'name': item, 'price': price, 'quantity': quantity}
      ])
    });
  }

// Gets the Item and Price and adds it to database
  void getNameAndPrice(int index) {
    final FocusNode nodeTwo = FocusNode(); //Focus node moves the cursor
    final FocusNode nodeThree = FocusNode();
    var newItem = "item";
    var price = "0";
    Navigator.of(context).push(MaterialPageRoute<dynamic>(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Enter Item & Price')),
        body: new Container(
            child: Column(
          children: <Widget>[
            Flexible(
              // Textfield for Item name
              child: TextField(
                autofocus: true,
                maxLength: 30,
                maxLengthEnforced: true,
                onSubmitted: (userItem) {
                  newItem = userItem;
                  FocusScope.of(context)
                      .requestFocus(nodeTwo); // This jumps to the other textbox
                },
                decoration: InputDecoration(
                    hintText: 'Enter Item Name',
                    contentPadding: const EdgeInsets.all(16.0)),
              ),
            ),
            Flexible(
              // Textfield for price
              child: TextField(
                autofocus: false,
                focusNode: nodeTwo,
                maxLength: 10,
                maxLengthEnforced: true,
                onSubmitted: (new_Price) {
                  price = new_Price;
                  FocusScope.of(context).requestFocus(nodeThree);
                },
                decoration: InputDecoration(
                    hintText: 'Enter Price Of Item',
                    contentPadding: const EdgeInsets.all(16.0)),
              ),
            ),
            Flexible(
              //Text field for quanity
              child: TextField(
                autofocus: false,
                focusNode: nodeThree,
                maxLength: 10,
                maxLengthEnforced: true,
                onSubmitted: (Amount) {
                  addItemsToList(_numList[index], newItem, price, Amount);//Adds value to the list
                  Navigator.pop(context); // Close the add todo screen
                },
                decoration: InputDecoration(
                    hintText: 'Enter Quantity',
                    contentPadding: const EdgeInsets.all(16.0)),
              ),
            )
          ],
        )),
      );
    }));
  }

  // void getDataFromDatabase() {
  //   // Get Items and Price from DataBase
  //   databaseRef.collection("lists");
  // }

  void deleteList(int index) {
    // Deletes list from database and updates array
    databaseRef.collection('lists').document(_numList[index]).delete();
    putNamesOfListInAList();
  }

  void _addNewList(String task) {
    //allows to change state of the list appearing
    if (task.isNotEmpty) {
      setState(() => _numList.add(task));
    }
  }

  void _getIndex(int index) {
    //change state of list
    setState(() => _numList.elementAt(index));
  }

  void _openList(int index) {
    // Open up a single list
    temp = _numList[index];
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_numList[index]),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                getNameAndPrice(index); // Allows user to enter item and price
              },
            )
          ],
        ),
        body: ListViews(listName: _numList[index]),
      );
    }));
  }

  Widget _buildList() {
    //This is the whole list
    putNamesOfListInAList();
    return ListView.builder(itemBuilder: (context, index) {
      if (index < _numList.length) {
        return _buildTodoItem(_numList[index], index);
      }
    });
  }

  void alertBoxForList(int index) {
    // Displays an alert box before deleting list
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
    //Build one list
    return Card(
        child: ListTile(
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
            onPressed: () {
              Navigator.of(context).pushNamed(StoreSelect.tag);
            },
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