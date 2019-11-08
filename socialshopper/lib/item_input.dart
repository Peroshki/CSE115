import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'menu.dart' as globals;

List<String> userNames = new List();
List<bool> inputs = new List<bool>(); // dynamic list for checkboxes
List<String> userVal = globals.numList;

class Shoppers {
  List<String> userNames = new List();
  List<bool> inputs = new List<bool>(); // dynamic list for checkboxes
}

//Create a state for checkbox
class UserCheckBox extends StatefulWidget {
  //UserCheckBox({Key key, this.title});
  //final String title;
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
      itemCount: userNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
            child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new CheckboxListTile(
                      value: inputs[index],
                      title: new Text(
                        '${userNames.elementAt(index)}',
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
    //return null;
  }
}

void addItemsToList(String name, String item, int price, int quantity,
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

// updates the app with list in the database
// void putNamesOfListInAList() async {
//   final QuerySnapshot results =
//       await Firestore.instance.collection('lists').getDocuments();
//   final List<DocumentSnapshot> docs = results.documents;

//   var i = 0;
//   var val = "";

//   if (_numList.length < docs.length || _numList.length > docs.length) {
//     _numList.clear();
//     while (i < docs.length) {
//       val = docs.elementAt(i).documentID;
//       temp = docs.elementAt(i).documentID;
//       globals._addNewList(val);
//       i++;
//     }
//   }
// }

// Opens a new page
// Allows user to manually enter
// Item name, Price, Quantity, and select shoppers
Widget getNameAndPrice(BuildContext context) {
  final FocusNode nodeTwo = FocusNode();
  final FocusNode nodeThree = FocusNode();
  //final FocusNode nodeFour = FocusNode();

  var newItem = "item";
  var price = 0;
  var quan = 0;
  var p = 'Omar';

  // Navigator.of(context).push(MaterialPageRoute<dynamic>(builder: (context) {
    return Scaffold(
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
                  for (int i = 0; i < userNames.length; i++) {
                    if (inputs.elementAt(i) == true) {
                      shoppingUsers.add(userNames.elementAt(i));
                      print(userNames.elementAt(i));
                    }
                  }
                  addItemsToList(
                      globals.documentId, newItem, price, quan, shoppingUsers);
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
  //}
  //)
  //);
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Item Description'),
      ),
      body: getNameAndPrice(context),
    );
  }
}
