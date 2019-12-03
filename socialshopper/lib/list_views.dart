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

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialshopper/payment.dart';

import 'globals.dart' as globals;
import 'globals.dart';
import 'menu.dart';
import 'mock_store.dart';

/*** BEGIN WIDGET GENERATORS ***/

// Generates a widget to display the total price for the entire shopping list
Widget createTotalWidget(double total) {
  return Text(
    'Total: \$${total.toStringAsFixed(2)}',
    textScaleFactor: 1.2,
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.white),
  );
}

// Generates a widget to display the budget for the shopping list
Widget createBudgetWidget(double budget) {
  return Text(
    'Budget: \$${budget.toStringAsFixed(2)}',
    textScaleFactor: 1.2,
    style: TextStyle(color: Colors.white),
  );
}

// Generates a widget to display the difference between
// the group total and the budget for the shopping list
Widget createDifferenceWidget(double difference) {
  String text;
  Color textColor;
  if (difference < 0) {
    text = '-(\$${difference.toStringAsFixed(2).substring(1)})';
    textColor = Colors.red;
  } else {
    text = '(\$${difference.toStringAsFixed(2)})';
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
    color: globals.mainColor,
    height: 70,
    padding: const EdgeInsets.only(top: 5),
    child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Icon(Icons.arrow_drop_up),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          createTotalWidget(total),
          createDifferenceWidget(difference),
          createBudgetWidget(budget)
        ],
      ),
    ]),
  );
}

// Generates a list of widgets for the individual totals
List<Widget> createIndividualTotalWidget(Map<String, double> indTotals) {
  List<Widget> indTotalWidgets = List<Widget>();

  for (var indTotal in indTotals.entries) {
    Widget indTotalWidget = Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
      child: Text(
        '${indTotal.key}\'s Total: \$${((indTotal.value * 100).roundToDouble() / 100).toStringAsFixed(2)}',
        textAlign: TextAlign.center,
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
Widget createFinishWidget(BuildContext context, double groupTotal,
    Map<String, double> indTotals, double budget) {
  List<Widget> colWidgets = createIndividualTotalWidget(indTotals);

  final Widget totalWidget = Container(
    color: globals.mainColor,
    height: 80,
    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            createTotalWidget(groupTotal),
            createDifferenceWidget(budget - groupTotal),
            createBudgetWidget(budget)
          ],
        ),
      ]
    ),
  );
  colWidgets.insert(0, totalWidget);

  final Widget divider = Divider(
    thickness: 5.0,
    color: Colors.white,
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
        // Go to payment page.
        onPressed: () {
          Navigator.of(context).pushNamed(Payment.tag);
        },
      ));
  colWidgets.add(payButton);

  return Container(
    color: globals.mainColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: colWidgets,
    ),
  );
}

List<Widget> createUserWidget(List<String> users) {
  List<Widget> widgets = List();

  widgets.add(
    Divider(
      thickness: 1.0,
    )
  );

  widgets.add(
    Text('Shoppers:')
  );

  for (String user in users) {
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text('$user'),
      )
    );
  }

  return widgets;
}

// Generates a list of widgets, one for each item in the shopping list
Widget createItemCardWidget(Item item) {
  bool expanded = false;
  final double totalPrice = item.price * item.quantity;

  final Widget widget = Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(globals.anonPhoto),
                backgroundColor: Colors.transparent,
                radius: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0
                ),
                child: Text(
                  'x ${item.users.length}',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white
                  ),
                  overflow: TextOverflow.clip,
                ),
              )
            ],
          )
        ],
      ),

      const SizedBox(height: 5.0),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white
            ),
            overflow: TextOverflow.clip,
          ),
          Text(
            'x ${item.quantity}',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white
            ),
            overflow: TextOverflow.clip,
          ),
          Text(
            '= \$${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white
            ),
            overflow: TextOverflow.clip,
          ),
        ],
      )
    ],
  );

  return widget;
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
    print('listname: ' + widget.listName);
    docRef = Firestore.instance.collection('lists').document(widget.listName);
  }

  /*** BEGIN DATABASE METHODS ***/

  // Removes an item from the shopping list at the given index
  void removeFromDatabase(int index) {
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
                  child: Text(
                    'YES',
                    style: TextStyle(
                      color: globals.mainColor
                    ),
                  ),
                  onPressed: () async {
                    removeFromDatabase(index);
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                child: Text(
                  'NO',
                  style: TextStyle(
                      color: globals.mainColor
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
          if (!snapshot.hasData) return Text('Loading data... Please wait.');

          // If the list has no items, notify the user that the list is empty
          if (snapshot.data["items"].length == 0)
            return Center(child: Text('Press + to add an item.'));

          // Create a shopping list object from the list data
          final ShoppingList s = ShoppingList.fromSnapshot(snapshot.data);

          // Build the list of items
          return ListView.builder(
            itemCount: s.items.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Card(
                  child: ExpansionTile(
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.grey,
                      onPressed: () {
                        deleteItemDialog(index);
                      },
                    ),
                    title: createItemCardWidget(s.items[index]),
                    children: createUserWidget(s.items[index].users),
                  ),
                )
              );
            }
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: globals.mainColor,
        title: StreamBuilder(
            stream: docRef.snapshots(),
            builder: (context, snapshot) {
              // If the list has not yet loaded data, provide a placeholder name
              if (!snapshot.hasData) return Text('Name loading...');

              // If the list has no items, notify the user that the list is empty
              if (snapshot.data['items'].length == 0)
                return Text(snapshot.data['metadata']['name']);

              // Create a shopping list object from the list data
              ShoppingList s = ShoppingList.fromSnapshot(snapshot.data);

              // Create a text widget with the list name
              return Text(s.metadata.name);
            }),
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
        color: globals.mainColor,
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
      )),
    );
  }

  void activateBottomSheet() {
    showBottomSheet(
      backgroundColor: globals.mainColor,
        context: context,
        builder: (context) => StreamBuilder(
              stream: docRef.snapshots(),
              builder: (context, snapshot) {
                // If there is no data in the shopping list,
                // return an empty container with 0 height
                if (snapshot?.data == null) return Container(height: 0);

                // If the list has no items, notify the user that the list is empty
                if (snapshot.data['items'].length == 0)
                  return createFinishWidget(context, 0, {}, 0);

                // Create a shopping list object from the list data
                final ShoppingList s = ShoppingList.fromSnapshot(snapshot.data);

                double groupTotal = 0.0;
                double indTotal = 0.0;
                Map<String, double> indTotals = <String, double>{};

                // Calculate every users individual total
                for (ListUser user in s.metadata.users) {
                  indTotal = 0.0;

                  for (Item i in s.items) {
                    if (i.users.contains(user.name)) {
                      // The price for an individual user of an item is
                      // (total price * quantity) / (number of users of the item)
                      indTotal +=
                          (i.price.toDouble() * i.quantity) / i.users.length;
                    }
                  }

                  indTotals[user.name] = indTotal;
                }

                // Calculate the group total
                for (Item i in s.items) {
                  groupTotal += i.price * i.quantity;
                }

                final double budget = s.metadata.budget;

                // Create a final display widget which shows the group and
                // individual totals, and provides a button to initiate payment
                return createFinishWidget(
                    context, groupTotal, indTotals, budget);
              },
            ));
  }
}
