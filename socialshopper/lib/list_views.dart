/*
*   list_views.dart:
*
*   Contains the view for an individual shopping list. Items are displayed in
*   a list with each item containing a description of its name and price.
*   It also allows for the user to delete items from their shopping list and
*   update the database.
*
*   constructor: ListViews(listName: String)
*   arguments:
*     listName: The name of the shopping list you wish to view
*/

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_input.dart';
import 'menu.dart';
import 'mock_store.dart';

// Represents an item in the shopping list
class Item {
  String name;
  double price;
  int quantity;
  List<String> users;

  Item.fromMap(Map<dynamic, dynamic> data)
      : name = data['name'],
        price = data['price'] * 1.0,
        quantity = data['quantity'],
        users = List.from(data['users']);
}

// Represents the metadata from the shopping list
class Metadata {
  double budget;
  String store;
  Timestamp timeCreated;
  String uid;
  String name;
  List<String> users;

  Metadata.fromMap(Map<dynamic, dynamic> data)
    : budget = data['budget'] * 1.0,
      store = data['store'],
      timeCreated = data['timeCreated'],
      uid = data['uid'],
      name = data['name'],
      users = List.from(data['users']);
}

// Represents a shopping list from Firebase
class ShoppingList {
  String documentID;
  List<Item> items;
  Metadata metadata;

  ShoppingList.fromSnapshot(DocumentSnapshot snapshot)
    : documentID = snapshot.documentID,
      items = List.from(snapshot['items'].map((item) => item = Item.fromMap(item))),
      metadata = Metadata.fromMap(snapshot['metadata']);
}


/*** BEGIN WIDGET GENERATORS ***/

// Generates a widget to display the total price for the entire shopping list
Widget createTotalWidget(double total) {
  return Text(
    'Total: \$$total',
    textScaleFactor: 1.2,
    style: TextStyle(
        color: Colors.white
    ),
  );
}

// Generates a widget to display the budget for the shopping list
Widget createBudgetWidget(double budget) {
  return Text(
    'Budget: \$$budget',
    textScaleFactor: 1.2,
    style: TextStyle(
        color: Colors.white
    ),
  );
}

// Generates a widget to display the difference between
// the group total and the budget for the shopping list
Widget createDifferenceWidget(double difference) {
  String text;
  Color textColor;
  if (difference < 0) {
    text = '-(\$${difference.toString().substring(1)})';
    textColor = Colors.red;
  } else {
    text = '(\$$difference)';
    textColor = Colors.green;
  }

  return Text(
    text,
    textScaleFactor: 1.2,
    style: TextStyle(color: textColor),
  );
}

// Generates the widget for the bottom bar, which displays
// the group total, budget and their difference
Widget createDetailsWidget(double total, double budget, double difference) {
  return Container(
    color: Colors.blueGrey,
    height: 70,
    padding: const EdgeInsets.only(
      left: 5,
      right: 5,
      top: 12
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            createTotalWidget(total),
            createDifferenceWidget(difference),
            createBudgetWidget(budget)
          ],
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: Icon(Icons.arrow_drop_up),
        )
      ]
    ),
  );
}

// Generates a list of widgets for the individual totals
List<Widget> createIndividualTotalWidget(Map<String, double> indTotals) {
  List<Widget> indTotalWidgets = List<Widget>();

  for (var indTotal in indTotals.entries) {
    Widget indTotalWidget = Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: 40.0
      ),
      child: Text(
        "${indTotal.key}'s Total: ${(indTotal.value * 100).roundToDouble() / 100}",
        textScaleFactor: 1.2,
        style: TextStyle(color: Colors.white),
      ),
    );

    indTotalWidgets.add(indTotalWidget);
  }

  return indTotalWidgets;
}

// Generates a widget for the 'finish' view, which the user sees
// before moving on to the payment screen
Widget createFinishWidget(BuildContext context, double groupTotal, Map<String, double> indTotals, double budget) {
  List<Widget> colWidgets = createIndividualTotalWidget(indTotals);

  final Widget totalWidget = Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(
            bottom: 10.0,
            top: 15.0,
            left: 20.0
        ),
        child: createTotalWidget(groupTotal),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 5
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      )
    ],
  );
  colWidgets.insert(0, totalWidget);

  final Widget divider = Divider(
    thickness: 5.0,
    color: Colors.grey,
  );
  colWidgets.insert(1, divider);
  colWidgets.add(divider);

  final Widget payButton = Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: FlatButton(
        child: Text(
          'Pay Now',
          textScaleFactor: 1.2,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
      ));
  colWidgets.add(payButton);

  return Container(
    color: Colors.blueGrey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: colWidgets,
    ),
  );
}

// Generates a list of widgets, one for each item in the shopping list
List<Widget> createItemCardWidget(Item item) {
  final double totalPrice = item.price * item.quantity;

  final List<Widget> widgets = [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text(item.name), Text('\$${totalPrice.toString()}')],
    ),
    Text('Price: \$${item.price}'),
    Text('Quantity: ${item.quantity}'),
    Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text('Shoppers: ${item.users.toString()}'))
  ];

  return widgets;
}

Widget createTitleWidget(String name) {

}

/*** END WIDGET GENERATORS ***/


class ListViews extends StatefulWidget {
  static String tag = 'list_views';

  // The id of the list to read from Firestore,
  // obtained from the constructor
  final String listName;

  // Constructor
  ListViews({Key key, @required this.listName}) : super(key: key);

  @override
  _ListViewsState createState() => _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  // A reference to the document containing the shopping list
  DocumentReference docRef;

  // Initiates the state of the page, grabbing the
  // document reference for the shopping list from Firestore
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docRef = Firestore.instance.collection('lists').document(widget.listName);
  }


  /*** BEGIN DATABASE METHODS ***/

  // Removes an item from the shopping list at the given index
  void removeFromDatabase(int index){
    Firestore.instance.runTransaction((Transaction tx) async {
      final DocumentReference postRef =
          Firestore.instance.collection('lists').document(widget.listName);
      final DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        var doc = postSnapshot.data;

        List<dynamic> itemsList = List();
        itemsList = doc['items'].toList();
        for (var i in itemsList) {
          print(i['name']);
        }
        itemsList.removeAt(index);
        for (var i in itemsList) {
          print(i['name']);
        }

        await postRef.updateData({'items': itemsList});
      }
    });
  }
  
  // Shows an alert dialog, prompting the user to consider
  // if they really want to delete the item
  void deleteItemDialog(int index) {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: Text('Are you sure you want to delete this item?'),
         content: Text('This action is permanent.'),
         actions: <Widget>[
           // usually buttons at the bottom of the dialog
           FlatButton(
             child: Text('YES'),
             onPressed: () async {
               removeFromDatabase(index);
               Navigator.of(context).pop();
             }
           ),
           FlatButton(
             child: Text('NO'),
             onPressed: () {
               Navigator.of(context).pop();
             },
           ),
         ],
       );
     }
   );
  }

  /*** END DATABASE METHODS ***/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // Input stream: A document from the database under the 'lists' collection
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          // If the list has not yet loaded data, notify the user to wait
          if (!snapshot.hasData)
            return Text('Loading data... Please wait.');

          // Create a shopping list object from the list data
          final ShoppingList s = ShoppingList.fromSnapshot(snapshot.data);

          // If the list has no items, notify the user that the list is empty
          if (s.items == null) return Center(child: Text('List is empty.'));

          // Build the list of items
          return ListView.builder(
            itemCount: s.items.length,

            itemBuilder: (BuildContext context, int index) {
              List<Widget> widgets = createItemCardWidget(s.items[index]);
              return Center(
                child: ExpansionTile(
                  trailing: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () => deleteItemDialog(index),
                  ),
                  title: widgets.first,
                  children: widgets.sublist(1)
                ),
              );
            }
          );
        },
      ),

      appBar: AppBar(
        title: StreamBuilder(
          stream: docRef.snapshots(),
          builder: (context, snapshot) {
            // If the list has not yet loaded data, provide a placeholder name
            if (!snapshot.hasData)
              return Text('Name loading...');

            // Create a shopping list object from the list data
            ShoppingList s = ShoppingList.fromSnapshot(snapshot.data);

            // Create a text widget with the list name
            return Text(s.metadata.name);
          }
        ),
        actions: <Widget>[
          // A button which routes to the new item page
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              callUser.getUsersOfList();
              Navigator.of(context).pushNamed(MockStore.tag);
            },
          )
        ],
      ),


      bottomNavigationBar: BottomAppBar(
        child: FlatButton(
          color: Colors.blueGrey,
          highlightColor: Colors.transparent,
          onPressed: activateBottomSheet,
          child: StreamBuilder(
            stream: docRef.snapshots(),
            builder: (context, snapshot) {
              // If the list has no data, return an error message
              if (snapshot.data == null) return Text("Error");

              // Create a shopping list object from the list data
              final ShoppingList s = ShoppingList.fromSnapshot(snapshot.data);

              // Calculate the total price for the list
              double total = 0.0;
              for (Item i in s.items) {
                total += i.price * i.quantity;
              }

              // Compare it to the budget to get the difference
              final double budget = s.metadata.budget;
              final double difference = budget - total;

              // Create a widget to display the total, budget and difference
              return createDetailsWidget(total, budget, difference);
            },
          ),
        )
      ),
    );
  }

  void activateBottomSheet() {
    showBottomSheet(
      context: context,
      builder: (context) => StreamBuilder(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          // If there is no data in the shopping list,
          // return an empty container with 0 height
          if (snapshot?.data == null) return Container(height: 0);

          // Create a shopping list object from the list data
          final ShoppingList s = ShoppingList.fromSnapshot(snapshot.data);

          double groupTotal = 0.0;
          double indTotal = 0.0;
          Map<String, double> indTotals = <String,double>{};

          // Calculate every users individual total
          for (String user in s.metadata.users) {
            indTotal = 0.0;

            for (Item i in s.items) {
              if (i.users.contains(user)) {
                // The price for an individual user of an item is
                // (total price * quantity) / (number of users of the item)
                indTotal += (i.price.toDouble() * i.quantity) / i.users.length;
              }
            }

                  indTotals[user] = indTotal;
                }

          // Calculate the group total
          for (Item i in s.items) {
            groupTotal += i.price * i.quantity;
          }

                final double budget = s.metadata.budget;

          // Create a final display widget which shows the group and
          // individual totals, and provides a button to initiate payment
          return createFinishWidget(context, groupTotal, indTotals, budget);
        },
      )
    );
  }
}
