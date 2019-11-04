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

class ShoppingList {
  String documentID;
  List<Item> items;

  ShoppingList.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        items = List.from(snapshot['items'].map((item) => item = Item.fromMap(item)));
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
        stream: Firestore.instance.collection('lists').document(widget.listName).snapshots(),
        builder: (context, snapshot) {

          // If the list has not yet loaded data, notify the user to wait
          if (!snapshot.hasData)
            return Text('Loading data... Please wait.');

          // If the list has no items, notify the user that the list is empty
          if (snapshot.data['items'] == null)
            return Center(child: Text('List is empty.'));

          return ListView.builder(
                  itemCount: snapshot.data['items'].length,

                  // Each item is currently formatted as 'Name': 'Price'
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Card(
                      //height: 50,
                      //color: Colors.blue,
                      child: ListTile(
                          title: Text(snapshot.data['items'][index]['name'] + ': ' 
                          + snapshot.data['items'][index]['price'].toString()),
                          
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
            builder: (BuildContext c, AsyncSnapshot<ShoppingList> data) {
              if (data?.data == null) return Text("Error");

              ShoppingList s = data.data;

              return Text("${s.documentID}");
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check),
        label: const Text('Pay Now'),
        backgroundColor: Colors.black,
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

  }
}