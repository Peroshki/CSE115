/*
* In this folder you can create a new list and at it to the database.
* You can delete a list from the database; it warns you if you want to fully
* delete or cancel.
* You can open a new list.
* You can add an item to a new list. 
* Specifing the item name, price, and quanitity. 
*/

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/scheduler.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'app_settings.dart';
import 'list_views.dart';
import 'profile.dart';
import 'store_select.dart';
import 'package:flutter/src/material/page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var temp = '';
final List<String> _numList = []; //Array to hold the list names
final List<String> userNames = new List();
//FireBase stuff
final databaseRef = Firestore.instance; //creating an instance of database
var documentName = "";

//Create a state for checkbox
class UserCheckBox extends StatefulWidget {
  //UserCheckBox({Key key, this.title});
  //final String title;
  @override
  _UserCheckBox createState() => _UserCheckBox();
}

class Metadata {
  double budget;
  String store;
  Timestamp timeCreated;
  String uid;
  List<User> users;

  Metadata.fromMap(Map<dynamic, dynamic> data)
      : budget = data['budget'] * 1.0,
        store = data['store'],
        timeCreated = data['timeCreated'],
        uid = data['uid'],
        users =
            List.from(data['users'].map((user) => user = User.fromMap(user)));
}

class ShoppingList {
  String documentID;
  List<Item> items;
  Metadata metadata;

  ShoppingList.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        items = List.from(snapshot['items'].map((item) => item = Item.fromMap(item))),
        metadata = Metadata.fromMap(snapshot['metadata']);
}

void getUsersOfList() async {
  DocumentReference ref =
      Firestore.instance.collection('lists').document(documentName);
  DocumentSnapshot doc = await ref.get();
  Map<dynamic, dynamic> tags = doc.data['metadata'];
  tags.remove('uid');
  tags.remove('timeCreated');
  tags.remove('store');
  tags.remove('budget');
  tags.forEach((Key, value) => userNames.add(value.toString()));
  print(userNames[0]);
  String n = userNames[0];
  List k = n.split(new RegExp(r'(\W+)'));
  //print(n.split(new RegExp(r'(\W+)')));
  userNames.removeLast();
  for(int i=0; i<k.length; i++){
    if(k.elementAt(i) == ' '){
    }
    else if(k.elementAt(i) == 'name')
  }

  for(int j=0; j<userNames.length; j++){
    print(userNames.elementAt(j));
  }
  //Map<dynamic, dynamic> a = tags.cast();
}

// Creates Checkbox to Select Users Who Are Buying Item
class _UserCheckBox extends State<UserCheckBox> {
  List<bool> inputs = new List<bool>(); // dynamic list for checkboxes

  @override
  Future initState() {
    setState(() {
      for (int i = 0; i < 8; i++) {
        inputs.add(false);
      }
    });
  }

  void ChangeVal(bool val, int index) {
    setState(() {
      inputs[index] = val;
    });
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: inputs.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
            child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new CheckboxListTile(
                      value: inputs[index],
                      title: new Text('item ${inputs}'),
                      //controlAffinity: ListTileControlAffinity.platform,
                      onChanged: (bool val) {
                        ChangeVal(val, index);
                      },
                    )
                  ],
                )));
      },
    );
    return null;
  }
}

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

  //Function to click on a single list
  void listPress(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // updates the app with list in the database
  void putNamesOfListInAList() async {
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

// functions used to record user data -> database
  void createRecord(String listName) async {
    await databaseRef.collection("lists").document(listName);
  }

// This functions populates a list with new items and updates database
  void addItemsToList(String name, String item, int price, int quantity,
      List<String> users) async {
    DocumentReference ref =
        Firestore.instance.collection('lists').document(name);
    DocumentSnapshot doc = await ref.get();
    List tags = doc.data['items'];

    ref.updateData({
      'items': FieldValue.arrayUnion([
        {'name': item, 'price': price, 'quantity': quantity, 'users': users}
      ])
    });
  }

// Gets the Item and Price and adds it to database
  void getNameAndPrice(int old_Index) {
    final FocusNode nodeTwo = FocusNode(); //Focus node moves the cursor
    final FocusNode nodeThree = FocusNode();
    final FocusNode nodeFour = FocusNode();
    List<String> users = new List();

    var newItem = "item";
    var price = 0;
    var quan = 0;
    var p = 'Omar';

    Navigator.of(context).push(MaterialPageRoute<dynamic>(builder: (context) {
      TextEditingController controler;
      return Scaffold(
        appBar: AppBar(title: const Text('Add Item To Shopping List')),
        body: new Container(
            decoration: BoxDecoration(),
            child: Column(
              children: <Widget>[
                Flexible(
                  // Textfield for Item nam
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    autofocus: true,
                    maxLength: 30,
                    maxLengthEnforced: true,
                    textInputAction: TextInputAction.next,
                    onChanged: (userItem) {
                      print(userItem);
                      newItem = userItem;
                      //FocusScope.of(context).requestFocus(nodeTwo); // This jumps to the other textbox
                    },
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(nodeTwo);
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Item Name',
                        prefixIcon: Icon(Icons.add_shopping_cart),
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
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (newPrice) {
                      price = int.parse(newPrice);
                    },
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(nodeThree);
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Price Of Item',
                        prefixIcon: Icon(Icons.monetization_on),
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
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (Amount) {
                      quan = int.parse(Amount);
                    },
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Quantity',
                        prefixIcon: Icon(Icons.add_box),
                        contentPadding: const EdgeInsets.all(16.0)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: UserCheckBox(),
                    height: 500,
                  ),
                ),
                FloatingActionButton.extended(
                  tooltip: "Submit",
                  icon: Icon(Icons.save),
                  label: Text("Save"),
                  onPressed: () {
                    //addItemsToList(_numList[old_Index], newItem, price, quan, users);
                    getUsersOfList();
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  elevation: 0.0,
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

  // void _getIndex(int index) {
  //   //change state of list
  //   setState(() => _numList.elementAt(index));
  // }

  void _openList(int index) {
    // Open up a single list
    documentName = _numList[index];
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

//This is the whole list
  Widget _buildList() {
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
