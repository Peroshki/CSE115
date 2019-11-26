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

// Classes that hold Database Data
class Meat_Items {
  List<dynamic> meat_Names;
  List<dynamic> meat_Prices;

  Meat_Items.fromSnapshot(DocumentSnapshot snapshot)
      : meat_Names = Map.from(snapshot['Meat']).keys.toList(),
        meat_Prices = Map.from(snapshot['Meat']).values.toList();
}

class Drink_Items {
  List<dynamic> drink_Names;
  List<dynamic> drink_Prices;

  Drink_Items.fromSnapshot(DocumentSnapshot snapshot)
      : drink_Names = Map.from(snapshot['Drinks']).keys.toList(),
        drink_Prices = Map.from(snapshot['Drinks']).values.toList();
}

class Snack_Items {
  List<dynamic> snack_Names;
  List<dynamic> snack_Prices;

  Snack_Items.fromSnapshot(DocumentSnapshot snapshot)
      : snack_Names = Map.from(snapshot['Snacks']).keys.toList(),
        snack_Prices = Map.from(snapshot['Snacks']).values.toList();
}

class Produce_Items {
  List<dynamic> produce_Names;
  List<dynamic> produce_Prices;

  Produce_Items.fromSnapshot(DocumentSnapshot snapshot)
      : produce_Names = Map.from(snapshot['Produce']).keys.toList(),
        produce_Prices = Map.from(snapshot['Produce']).values.toList();
}

List<String> users = new List<String>();

//Populates the database with the items selected by the user
void populateDataBase(String itemName, double price, int quantity) async {
  DocumentReference ref =
      Firestore.instance.collection('lists').document(globals.documentName);
  DocumentSnapshot doc = await ref.get();
  List tags = doc.data['items'];

  if (users == Null) {
    users = [];
  }
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
class _Meat extends State<Meat> {
  var quan = 1;
  var priceString;
  var price;
  Meat_Items p;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('stores')
            .document('SafewayMock')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data... Please wait.');
          p = Meat_Items.fromSnapshot(snapshot.data);
          if (p.meat_Names == null)
            return Center(child: Text('List is empty.'));
          return ListView.builder(
            shrinkWrap: true,
            itemCount: p.meat_Names.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                child: GestureDetector(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Expanded(
                        flex: 3,
                        child: Text(
                          p.meat_Names[index] +
                              ' \n\$' +
                              p.meat_Prices[index].toString(),
                          style:
                              TextStyle(fontFamily: 'Open Sans', fontSize: 25),
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
                              priceString = p.meat_Prices[index];
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
        },
      ),
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
                priceString = p.meat_Prices[index].toString();
                price = double.tryParse(priceString);
                populateDataBase(p.meat_Names[index].toString(), price, quan);
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
  Drink_Items p;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('stores')
            .document('SafewayMock')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) return Text('Loading data... Please wait.');

          p = Drink_Items.fromSnapshot(snapshot.data);

          if (p.drink_Names == null)
            return Center(child: Text('List is empty.'));
          return ListView.builder(
            shrinkWrap: true,
            itemCount: p.drink_Names.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                  child: GestureDetector(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Expanded(
                      flex: 3,
                      child: Text(
                        p.drink_Names.elementAt(index) +
                            ' \n\$' +
                            p.drink_Prices.elementAt(index).toString(),
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
                            priceString =
                                p.drink_Prices.elementAt(index).toString();
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
        },
      ),
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
                priceString = p.drink_Prices.elementAt(index).toString();
                price = double.tryParse(priceString);
                populateDataBase(
                    p.drink_Names.elementAt(index).toString(), price, quan);
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
  Snack_Items p;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(

        stream: Firestore.instance
            .collection('stores')
            .document('SafewayMock')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) return Text('Loading data... Please wait.');

          p = Snack_Items.fromSnapshot(snapshot.data);

          if (p.snack_Names == null)
            return Center(child: Text('List is empty.'));

          return ListView.builder(
            shrinkWrap: true,
            itemCount: p.snack_Names.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                  child: GestureDetector(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Expanded(
                      flex: 3,
                      child: Text(
                        p.snack_Names.elementAt(index) +
                            ' \n\$' +
                            p.snack_Prices.elementAt(index).toString(),
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
                            priceString =
                                p.snack_Prices.elementAt(index).toString();
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
        },
      ),
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
                priceString = p.snack_Prices.elementAt(index).toString();
                price = double.tryParse(priceString);
                populateDataBase(
                    p.snack_Names.elementAt(index).toString(), price, quan);
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
  Produce_Items p;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('stores')
            .document('SafewayMock')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data... Please wait.');

          p = Produce_Items.fromSnapshot(snapshot.data);

          if (p.produce_Names == null)
            return Center(child: Text('List is empty.'));

          return ListView.builder(
            shrinkWrap: true,
            itemCount: p.produce_Names.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                child: GestureDetector(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Expanded(
                        flex: 3,
                        child: Text(
                          p.produce_Names.elementAt(index) +
                              ' \n\$' +
                              p.produce_Prices.elementAt(index).toString(),
                          style:
                              TextStyle(fontFamily: 'Open Sans', fontSize: 25),
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
                              priceString =
                                  p.produce_Prices.elementAt(index).toString();
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
        },
      ),
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
                priceString = p.produce_Prices.elementAt(index).toString();
                price = double.tryParse(priceString);
                populateDataBase(
                    p.produce_Names.elementAt(index).toString(), price, quan);
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
  }
}
