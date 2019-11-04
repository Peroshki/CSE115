/*
*   list_views.dart:
*
*   Contains the view for an individual shopping list. Items are displayed in
*   a list with each item containing a description of its name and price.
*
*   constructor: ListViews(listName: String)
*   arguments:
*     listName: The name of the shopping list you wish to view
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class User {
  String name;
  String uid;

  User.fromMap(Map<dynamic, dynamic> data)
    : name = data['name'],
      uid = data['uid'];
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
      users = List.from(data['users'].map((user) => user = User.fromMap(user)));
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

Stream<ShoppingList> getShoppingList(String documentName) {
  return Firestore.instance
      .collection('lists')
      .document(documentName)
      .get()
      .then((snapshot) {
    try {
      return ShoppingList.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}

/*** BEGIN WIDGET GENERATORS ***/

Widget createTotalWidget(double total) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 10.0
    ),
    child: Text(
      'Total: \$$total',
      textScaleFactor: 1.2,
      style: TextStyle(
        color: Colors.white
      ),
    ),
  );
}

Widget createBudgetWidget(double budget) {
  return Padding(
    padding: const EdgeInsets.only(
        right: 10.0
    ),
    child: Text(
      'Budget: \$$budget',
      textScaleFactor: 1.2,
      style: TextStyle(
          color: Colors.white
      ),
    ),
  );
}

Widget createDifferenceWidget(double difference) {
  String text;
  Color textColor;
  if (difference < 0) {
    text = '-(\$$difference)';
    textColor = Colors.red;
  }
  else {
    text = '(\$$difference)';
    textColor = Colors.green;
  }

  return Text(
    text,
    textScaleFactor: 1.2,
    style: TextStyle(
        color: textColor
    ),
  );
}

Widget createDetailsWidget(double total, double budget, double difference) {
  return Container(
    color: Colors.blueGrey,
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        createTotalWidget(total),
        createDifferenceWidget(difference),
        createBudgetWidget(budget)
      ],
    ),
  );
}

List<Widget> createIndividualTotalWidget(Map<String, double> indTotals) {
  List<Widget> indTotalWidgets = List<Widget>();

  for (var indTotal in indTotals.entries) {
    Widget indTotalWidget = Container(
      height: 25,
      child: Text(
        "${indTotal.key}'s total: ${(indTotal.value * 100).roundToDouble() / 100}"
      )
    );

    indTotalWidgets.add(indTotalWidget);
  }

  return indTotalWidgets;
}

Widget createFinishWidget(double groupTotal, Map<String, double> indTotals, double budget) {
  return Container(
    height: 200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: createIndividualTotalWidget(indTotals)
    ),
  );
}

/*** END WIDGET GENERATORS ***/

class ListViews extends StatefulWidget {
  static String tag = 'list_views';

  // Obtained from the constructor
  final String listName;

  // Constructor
  ListViews({Key key, @required this.listName}) : super(key: key);

  @override
  _ListViewsState createState() => _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  Stream shoppingList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    shoppingList = getShoppingList(widget.listName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // Input stream: A document from the database under the 'lists' collection
        stream: getShoppingList(widget.listName),
        builder: (BuildContext c, AsyncSnapshot<ShoppingList> list) {

          // If the list has not yet loaded data, notify the user to wait
          if (!list.hasData)
            return Text('Loading data... Please wait.');

          // If the list has no items, notify the user that the list is empty
          if (list.data.items == null)
            return Center(child: Text('List is empty.'));

          return ListView.builder(
            itemCount: list.data.items.length,

            // Each item is currently formatted as 'Name': 'Price'
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Card(
                  child: ListTile(
                    title: Text(list.data.items[index].name + ': '
                    + list.data.items[index].price.toString()),
                  ),
                ),
              );
            }
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: StreamBuilder<ShoppingList>(
            stream: getShoppingList(widget.listName),
            builder: (BuildContext c, AsyncSnapshot<ShoppingList> list) {
              if (list?.data == null) return Text("Error");

              final ShoppingList s = list.data;

              double total = 0.0;
              for (Item i in s.items) {
                total += i.price;
              }

              final double budget = s.metadata.budget;
              final double difference = budget - total;

              return createDetailsWidget(total, budget, difference);
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.keyboard_arrow_down),
        label: const Text('Finish'),
        backgroundColor: Colors.black,
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) => StreamBuilder<ShoppingList>(
              stream: getShoppingList(widget.listName),
              builder: (BuildContext c, AsyncSnapshot<ShoppingList> list) {
                if (list?.data == null) return Text("Error");

                final ShoppingList s = list.data;

                double groupTotal = 0.0;
                double indTotal = 0.0;
                String name = '';
                Map<String, double> indTotals = <String,double>{};

                for (User user in s.metadata.users) {
                  name = user.name;
                  indTotal = 0.0;

                  for (Item i in list.data.items) {
                    if (i.users.contains(name)) {
                      indTotal += i.price.toDouble() / i.users.length;
                    }
                  }

                  indTotals[name] = indTotal;
                }

                print(indTotals);

                for (Item i in list.data.items) {
                  groupTotal += i.price;
                }

                final double budget = s.metadata.budget;

                return createFinishWidget(groupTotal, indTotals, budget);
              },
            )
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

  }
}