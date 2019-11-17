/*
  This Page creates a Bottom Navigation Bar 
  with 5 categories of items: Produce, Snacks, Drinks, Meat,
  and the list category is manuel user entry for an item.
  For the UI of each list it displays each item with its price and a
  textbox to the left of the description to allow for the user to type in the
  quantity. If you double tap on an item an alert box will pop up allowing you to 
  select the users who want that item. Once you click 'done' in the alert box
  the item gets populated to the database.
  
  If the user clicks done and the user hasn't typed in a quantity it automatically becomes 1.
  */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'item_input.dart';
import 'menu.dart' as globals;

List<dynamic> produce_Item = [];
List<dynamic> produce_Prices = [];

List<String> drinks_Item = [];
List<dynamic> drink_Prices = [];

List<dynamic> snack_Item = [];
List<dynamic> snack_Prices = [];

List<dynamic> meat_Item = [];
List<dynamic> meat_Prices = [];

List<bool> inputs = new List<bool>();
List<String> users = new List<String>();

//Get Data For Each Category
void getCategoryData(String Category) async {
  DocumentReference ref =
      Firestore.instance.collection('stores').document('SafewayMock');
  DocumentSnapshot store = await ref.get();
  Map<dynamic, dynamic> data = store.data[Category];
  List<dynamic> keys = data.keys.toList();
  List<dynamic> values = data.values.toList();

  if (Category == 'Produce') {
    produce_Item.clear();
    produce_Prices.clear();
    for (int i = 0; i < keys.length; i++) {
      produce_Item.add(keys.elementAt(i));
      produce_Prices.add(values.elementAt(i));
    }
  } else if (Category == 'Snacks') {
    snack_Item.clear();
    snack_Prices.clear();
    for (int i = 0; i < keys.length; i++) {
      snack_Item.add(keys.elementAt(i));
      snack_Prices.add(values.elementAt(i));
    }
  } else if (Category == 'Drinks') {
    drinks_Item.clear();
    drink_Prices.clear();
    for (int i = 0; i < keys.length; i++) {
      drinks_Item.add(keys.elementAt(i));
      drink_Prices.add(values.elementAt(i));
    }
  } else if (Category == 'Meat') {
    meat_Item.clear();
    meat_Prices.clear();

    for (int i = 0; i < keys.length; i++) {
      meat_Item.add(keys.elementAt(i));
      meat_Prices.add(values.elementAt(i));
    }
  }
}

//Populates the database with the items selected by the user
void populateDataBase(String itemName, double price, int quantity) async {
  DocumentReference ref =
      Firestore.instance.collection('lists').document(globals.documentName);
  DocumentSnapshot doc = await ref.get();
  List tags = doc.data['items'];
  ref.updateData({
    'items': FieldValue.arrayUnion([
      {'name': itemName, 'price': price, 'quantity': quantity, 'users': users}
    ])
  });
}

//----------------Creation of each stateful widget classes
class UserCheckBox extends StatefulWidget {
  @override
  _UserCheckBox createState() => _UserCheckBox();
}

class Produce extends StatefulWidget {
  @override
  _Produce createState() => _Produce();
}

class Snacks extends StatefulWidget {
  @override
  _Snacks createState() => _Snacks();
}

class Drinks extends StatefulWidget {
  @override
  _Drinks createState() => _Drinks();
}

class Meat extends StatefulWidget {
  @override
  _Meat createState() => _Meat();
}
// END OF STATEFUL WIDGET CREATION

// UI for how checkbox are displayed on screen and for interaction 
class _UserCheckBox extends State<UserCheckBox> {
  @override
  void initState() {
    inputs.clear();
    users.clear();
    setState(() {
      for (int i = 0; i < 10; i++) {
        inputs.add(false);
      }
    });
  }

  void ChangeVal(bool val, int index) {
    setState(() {
      inputs[index] = val;
      if (val == true) {
        users.add(globals.userNames.elementAt(index));
      } else {
        users.removeAt(index);
      }
    });
  }

  Widget build(BuildContext context) {
    return new Container(
        height: 300,
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: globals.userNames.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
                child: new Column(
              children: <Widget>[
                new CheckboxListTile(
                  value: inputs[index],
                  title: new Text(
                    '${globals.userNames.elementAt(index)}',
                    textAlign: TextAlign.center,
                  ),
                  controlAffinity: ListTileControlAffinity.platform,
                  onChanged: (bool val) {
                    ChangeVal(val, index);
                  },
                )
              ],
            ));
          },
        ));
  }
}

//--------------------Meat 
//UI for meat items
class _Meat extends State<Meat> {
  var quan = 1;
  var priceString;
  var price;

  @override
  void initState() {
    getCategoryData('Meat');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: meat_Item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
          child: GestureDetector(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Expanded(
                  flex: 3,
                  child: Text(
                    meat_Item.elementAt(index) +
                        ' \n\$' +
                        meat_Prices.elementAt(index).toString(),
                    style: TextStyle(fontFamily: 'Open Sans', fontSize: 25),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextField(
                      autofocus: false,
                      maxLength: 3,
                      maxLengthEnforced: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onChanged: (val) {
                        quan = int.parse(val);
                        priceString = meat_Prices.elementAt(index).toString();
                        price = double.tryParse(priceString);
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Qty'),
                    )),
              ],
            ),
            onDoubleTap: () {
              alertBoxForList(index);
            },
          ),
        );
      },
    );
  }

  void alertBoxForList(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select Shoppers"),
          content: UserCheckBox(),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Done"),
              onPressed: () {
                priceString = meat_Prices.elementAt(index).toString();
                price = double.tryParse(priceString);
                populateDataBase(
                    meat_Item.elementAt(index).toString(), price, quan);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

//---------------------------Drinks
//UI for Drink class
class _Drinks extends State<Drinks> {
  var quan = 1;
  var priceString;
  var price;

  @override
  void initState() {
    getCategoryData('Drinks');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: drinks_Item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
            child: GestureDetector(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                flex: 3,
                child: Text(
                  drinks_Item.elementAt(index) +
                      ' \n\$' +
                      drink_Prices.elementAt(index).toString(),
                  style: TextStyle(fontFamily: 'Open Sans', fontSize: 25),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: TextField(
                    autofocus: false,
                    maxLength: 3,
                    maxLengthEnforced: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (val) {
                      quan = int.parse(val);
                      priceString = drink_Prices.elementAt(index).toString();
                      price = double.tryParse(priceString);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Qty'),
                  )),
            ],
          ),
          onDoubleTap: () {
            alertBoxForList(index);
          },
        ));
      },
    );
  }

  void alertBoxForList(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select Shoppers"),
          content: UserCheckBox(),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Done"), 
              onPressed: () {
                priceString = drink_Prices.elementAt(index).toString();
                price = double.tryParse(priceString);
                populateDataBase(
                    drinks_Item.elementAt(index).toString(), price, quan);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

//----------------------Snacks
//UI for all snack items
class _Snacks extends State<Snacks> {
  var quan = 1;
  var priceString;
  var price;

  @override
  void initState() {
    getCategoryData('Snacks');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snack_Item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
            child: GestureDetector(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                flex: 3,
                child: Text(
                  snack_Item.elementAt(index) +
                      ' \n\$' +
                      snack_Prices.elementAt(index).toString(),
                  style: TextStyle(fontFamily: 'Open Sans', fontSize: 25),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: TextField(
                    autofocus: false,
                    maxLength: 3,
                    maxLengthEnforced: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (val) {
                      quan = int.parse(val);
                      priceString = snack_Prices.elementAt(index).toString();
                      price = double.tryParse(priceString);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Qty'),
                  )),
            ],
          ),
          onDoubleTap: () {
            alertBoxForList(index);
          },
        ));
      },
    );
  }

  void alertBoxForList(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select Shoppers"),
          content: UserCheckBox(),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Done"), // Cancel button
              onPressed: () {
                priceString = snack_Prices.elementAt(index).toString();
                price = double.tryParse(priceString);
                populateDataBase(
                    snack_Item.elementAt(index).toString(), price, quan);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
//-----------------------------Produce--------
// UI for Produce
class _Produce extends State<Produce> {
  var quan = 1;
  var priceString;
  var price;

  @override
  void initState() {
    getCategoryData('Produce');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: produce_Item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
            child: GestureDetector(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                flex: 3,
                child: Text(
                  produce_Item.elementAt(index) +
                      ' \n\$' +
                      produce_Prices.elementAt(index).toString(),
                  style: TextStyle(fontFamily: 'Open Sans', fontSize: 25),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: TextField(
                    autofocus: false,
                    maxLength: 3,
                    maxLengthEnforced: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (val) {
                      quan = int.parse(val);
                      priceString = produce_Prices.elementAt(index).toString();
                      price = double.tryParse(priceString);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Qty'),
                  )),
            ],
          ),
          onDoubleTap: () {
            alertBoxForList(index);
          },
        ));
      },
    );
  }

  void alertBoxForList(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select Shoppers"),
          content: UserCheckBox(),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Done"),
              onPressed: () {
                priceString = produce_Prices.elementAt(index).toString();
                price = double.tryParse(priceString);
                populateDataBase(
                    produce_Item.elementAt(index).toString(), price, quan);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

//-----------------------Entire Page Setup
class MockStore extends StatefulWidget {
  static String tag = 'mock-store';
  @override
  _MockStore createState() => _MockStore();
}

class _MockStore extends State<MockStore> {
  int selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(topAppBar(selectedIndex)),
          centerTitle: true,
        ),
        body: selectBottomNav(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: Colors.black,
              ),
              title: Text(
                'Produce',
                style: TextStyle(color: Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.cake,
                color: Colors.black,
              ),
              title: Text('Snacks', style: TextStyle(color: Colors.black)),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.free_breakfast,
                  color: Colors.black,
                ),
                title: Text('Drinks', style: TextStyle(color: Colors.black))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.mood,
                  color: Colors.black,
                ),
                title: Text(
                  'Meat',
                  style: TextStyle(color: Colors.black),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.keyboard,
                  color: Colors.black,
                ),
                title: Text('Enter', style: TextStyle(color: Colors.black)))
          ],
        ));
  }

  Widget selectBottomNav(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return Produce();
      case 1:
        return Snacks();
      case 2:
        return Drinks();
      case 3:
        return Meat();
      case 4:
        return UserItemInput();
    }
    throw 'Invalid select index';
  }

  String topAppBar(int index) {
    var appBarVal;
    switch (index) {
      case 0:
        appBarVal = 'Select Produce';
        return appBarVal;
      case 1:
        appBarVal = 'Select Snacks';
        return appBarVal;
      case 2:
        appBarVal = 'Select Drinks';
        return appBarVal;
      case 3:
        appBarVal = 'Select Meat';
        return appBarVal;
      case 4:
        appBarVal = 'Enter Item Description';
        return appBarVal;
    }
    throw 'Invalid index';
  }
}
