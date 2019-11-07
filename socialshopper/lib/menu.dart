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
 List<String> userNames = new List();
 List<bool> inputs = new List<bool>(); // dynamic list for checkboxes

 
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

// Gets users from MetaData to display 
// When users want to add people to an item
void getUsersOfList() async {
  userNames.clear();
  List<String> test = new List();
  final DocumentReference ref =
      Firestore.instance.collection('lists').document(documentName);
  DocumentSnapshot doc = await ref.get();
  Map<dynamic, dynamic> tags = doc.data['metadata'];
  tags.remove('uid');
  tags.remove('timeCreated');
  tags.remove('store');
  tags.remove('budget');
  tags.forEach((Key, value) => test.add(value.toString()));
  String n = test[0];
  List<String> k = n.split(new RegExp(r'(\W+)'));

  for(int i=0; i<k.length; i++){
    if(i>0 && i<k.length -1 && k.elementAt(i) != 'name'){
       userNames.add(k.elementAt(i));
    }
  }
  print(userNames.length);
}

// Creates Checkbox to Select Users Who Are Buying Item
class _UserCheckBox extends State<UserCheckBox> {
  @override
  void initState() {
    inputs.clear();
    setState(() {
      for (int i = 0; i < 12; i++) {
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
      itemCount: userNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
            child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new CheckboxListTile(
                      value: inputs[index],
                      title: new Text('${userNames.elementAt(index)}', textAlign: TextAlign.center,),
                      controlAffinity: ListTileControlAffinity.platform,
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

// Add a new list to the database created by user
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

// Opens a new page
// Allows user to manually enter
// Item name, Price, Quantity, and select shoppers
  void getNameAndPrice(int old_Index) {
    final FocusNode nodeTwo = FocusNode(); 
    final FocusNode nodeThree = FocusNode();
    //final FocusNode nodeFour = FocusNode();

    var newItem = "item";
    var price = 0;
    var quan = 0;
    var p = 'Omar';

    Navigator.of(context).push(MaterialPageRoute<dynamic>(builder: (context) {
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
                    List<String> shoppingUsers = new List();
                    for(int i=0; i<userNames.length; i++){
                      if(inputs.elementAt(i) == true)
                          {shoppingUsers.add(userNames.elementAt(i)); print(userNames.elementAt(i));}
                    }
                    addItemsToList(_numList[old_Index], newItem, price, quan, shoppingUsers);
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

// Deletes list from database and updates array
  void deleteList(int index) {
    databaseRef.collection('lists').document(_numList[index]).delete();
    putNamesOfListInAList();
  }

//allows to change state of the list appearing
  void _addNewList(String task) {
    if (task.isNotEmpty) {
      setState(() => _numList.add(task));
    }
  }

// Open up a single list
  void _openList(int index) {
    documentName = _numList[index];
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_numList[index]),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                getUsersOfList();
                getNameAndPrice(index);
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

//Button to create a new list
  void _tapAddMoreItems() {
    Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text('Add a new task')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              createRecord(val); 
              Navigator.pop(context);
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
