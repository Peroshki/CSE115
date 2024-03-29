import 'package:cloud_firestore/cloud_firestore.dart';
/**
 * This file creates a new page that allows
 * the user to manually enter the name of an item,
 * the price of an item, and the quantity of an item.
 * It also has a checkbox that allows the user to select
 * users who want that item. Lastly, it has a save button
 * that redirects the user back to the list items view page
 * and populates the information the user provided to the database.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu.dart' as globals;
import 'globals.dart' as globals2;

List<bool> inputs = new List<bool>(); // dynamic list for checkboxes
List<String> userVal = globals.numList;
var itemName = '';

//Create a state for checkbox
class UserCheckBox extends StatefulWidget {
  @override
  _UserCheckBox createState() => _UserCheckBox();
}

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
      itemCount: globals.userNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
            child: new Container(
                padding: new EdgeInsets.all(10.0),
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
                )));
      },
    );
  }
}

void addItemsToList(String name, String item, double price, int quantity,
    List<String> users) async {
  DocumentReference ref = Firestore.instance.collection('lists').document(name);
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
Widget getNameAndPrice(BuildContext context) {
  var price = 0.0;
  var quan = 0;
  var p = 'Omar';

  return Scaffold(
    body: Container(
        decoration: BoxDecoration(),
        child: Column(
          children: <Widget>[
            Flexible(
              // Textfield for Item name
              child: TextField(
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                maxLength: 30,
                maxLengthEnforced: true,
                textInputAction: TextInputAction.done,
                onChanged: (String userItem) {
                  itemName = userItem;
                },
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter Item Name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: globals2.mainColor, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.add_shopping_cart),
                    contentPadding: const EdgeInsets.all(16.0)),
              ),
            ),
            Flexible(
              // Textfield for price
              child: TextField(
                autofocus: false,
                maxLength: 10,
                maxLengthEnforced: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (newPrice) {
                  price = double.parse(newPrice);
                },
                onSubmitted: (vt) {},
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.grey),
                  hintText: 'Enter Item Price',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: globals2.mainColor, width: 2.0),
                  ),
                  prefixIcon: Icon(Icons.monetization_on),
                  contentPadding: const EdgeInsets.all(16.0)),
              ),
            ),
            Flexible(
              //Text field for quanity
              child: TextField(
                autofocus: false,
                maxLength: 10,
                maxLengthEnforced: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (Amount) {
                  quan = int.parse(Amount);
                },
                onSubmitted: (v) {},
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter Quantity',
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: globals2.mainColor, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.add_box),
                    contentPadding: const EdgeInsets.all(16.0)),
              ),
            ),
            //Checkbox of user names
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
                for (int i = 0; i < globals.userNames.length; i++) {
                  if (inputs.elementAt(i) == true) {
                    shoppingUsers.add(globals.userNames.elementAt(i));
                    print(globals.userNames.elementAt(i));
                  }
                }
                if (itemName.isNotEmpty &&
                    price.toString().isNotEmpty &&
                    quan.toString().isNotEmpty &&
                    shoppingUsers.isNotEmpty) {
                  addItemsToList(globals.documentName, itemName, price, quan,
                      shoppingUsers);
                  Navigator.of(context).pop();
                }
              },
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              elevation: 0.0,
            )
          ],
        )),
  );
}

// Main class of page
class UserItemInput extends StatefulWidget {
  static String tag = 'user-input';

  @override
  _UserItemInput createState() => _UserItemInput();
}

class _UserItemInput extends State<UserItemInput> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getNameAndPrice(context),
    );
  }
}
