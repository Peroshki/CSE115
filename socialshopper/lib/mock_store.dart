import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialshopper/creating_new_list.dart';
import 'item_input.dart';
import 'menu.dart' as globals;

List<int> quantity_Produce = new List();
List<int> quantity_Snacks = new List();
List<int> quantity_Drinks = new List();
List<int> quantity_Meat = new List();

List<dynamic> produce_Item = [];
List<dynamic> produce_Prices = [];

List<String> drinks_Item = [];
List<dynamic> drink_Prices = [];

List<dynamic> snack_Item = [];
List<dynamic> snack_Prices = [];

List<dynamic> meat_Item = [];
List<dynamic> meat_Prices = [];

void populateDataBase(String itemName, double price, int quantity) async {
  DocumentReference ref =
      Firestore.instance.collection('lists').document(globals.documentName);
  DocumentSnapshot doc = await ref.get();
  List tags = doc.data['items'];
  List<String> users = ['omar'];
  ref.updateData({
    'items': FieldValue.arrayUnion([
      {'name': itemName, 'price': price, 'quantity': quantity, 'users': users}
    ])
  });
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

void getMeatData() async {
  DocumentReference ref =
      Firestore.instance.collection('stores').document('SafewayMock');
  DocumentSnapshot store = await ref.get();
  Map<dynamic, dynamic> meatData = store.data['Meat'];
  List<dynamic> keys = meatData.keys.toList();
  List<dynamic> values = meatData.values.toList();

  for (int i = 0; i < keys.length; i++) {
    meat_Item.add(keys.elementAt(i));
    meat_Prices.add(values.elementAt(i));
  }
}

class _Meat extends State<Meat> {
  @override
  void initState() {
    getMeatData();
    for (int i = 0; i < 100; i++) {
      quantity_Meat.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: meat_Item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
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
                  textInputAction: TextInputAction.go,
                  onChanged: (val) {
                    var quan = int.parse(val);
                    var priceString = meat_Prices.elementAt(index).toString();
                    var price = double.tryParse(priceString);
                    populateDataBase(
                        meat_Item.elementAt(index).toString(), price, quan);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Qty'),
                )),
          ],
        ));
      },
    );
  }
}

//---------------------------Drink

void getDrinkData() async {
  DocumentReference ref =
      Firestore.instance.collection('stores').document('SafewayMock');
  DocumentSnapshot store = await ref.get();
  Map<dynamic, dynamic> drinkData = store.data['Drinks'];
  List<dynamic> keys = drinkData.keys.toList();
  List<dynamic> values = drinkData.values.toList();

  for (int i = 0; i < keys.length; i++) {
    drinks_Item.add(keys.elementAt(i));
    drink_Prices.add(values.elementAt(i));
  }
}

class _Drinks extends State<Drinks> {
  @override
  void initState() {
    getDrinkData();
    for (int i = 0; i < 100; i++) {
      quantity_Drinks.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: drinks_Item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
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
                  textInputAction: TextInputAction.go,
                  onChanged: (val) {
                    var quan = int.parse(val);
                    var priceString = drink_Prices.elementAt(index).toString();
                    var price = double.tryParse(priceString);
                    populateDataBase(
                        drinks_Item.elementAt(index).toString(), price, quan);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Qty'),
                )),
          ],
        ));
      },
    );
  }
}
//----------------------snacks

void getSnackData() async {
  DocumentReference ref =
      Firestore.instance.collection('stores').document('SafewayMock');
  DocumentSnapshot store = await ref.get();
  Map<dynamic, dynamic> snackData = store.data['Snacks'];
  List<dynamic> keys = snackData.keys.toList();
  List<dynamic> values = snackData.values.toList();

  for (int i = 0; i < keys.length; i++) {
    snack_Item.add(keys.elementAt(i));
    snack_Prices.add(values.elementAt(i));
  }
}

class _Snacks extends State<Snacks> {
  @override
  void initState() {
    getSnackData();
    for (int i = 0; i < 100; i++) {
      quantity_Snacks.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snack_Item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
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
                  textInputAction: TextInputAction.go,
                  onChanged: (val) {
                    var quan = int.parse(val);
                    var priceString = snack_Prices.elementAt(index).toString();
                    var price = double.tryParse(priceString);
                    populateDataBase(
                        snack_Item.elementAt(index).toString(), price, quan);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Qty'),
                )),
          ],
        ));
      },
    );
  }
}
//-----------------------------Produce--------

void getProduceData() async {
  DocumentReference ref =
      Firestore.instance.collection('stores').document('SafewayMock');
  DocumentSnapshot store = await ref.get();
  Map<dynamic, dynamic> produceData = store.data['Produce'];
  List<dynamic> keys = produceData.keys.toList();
  List<dynamic> values = produceData.values.toList();
  produce_Item.clear();

  for (int i = 0; i < keys.length; i++) {
    produce_Item.add(keys.elementAt(i));
    produce_Prices.add(values.elementAt(i));
  }
}

class _Produce extends State<Produce> {
  @override
  void initState() {
    getProduceData();
    for (int i = 0; i < 100; i++) {
      quantity_Produce.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: produce_Item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
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
                  onSubmitted: (val) {
                    var quan = int.parse(val);
                    var priceString =
                        produce_Prices.elementAt(index).toString();
                    var price = double.tryParse(priceString);
                    populateDataBase(
                        produce_Item.elementAt(index).toString(), price, quan);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Qty'),
                )),
          ],
        ));
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
