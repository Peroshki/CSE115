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
import 'menu.dart' as globals;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                    return Card(
                     // height: 50,
                      //color: Colors.blue,
                      color: Colors.blue,
                      elevation:10,
                      child: ListTile(
                        title: Text(snapshot.data['items'][index]['name'] + ': ' 
                        + snapshot.data['items'][index]['price'].toString(), textAlign: TextAlign.center,),
                        trailing: Icon(Icons.delete_forever),

                        onLongPress: (){
                          removeField(index); // Removes item from database
                        },
                      )
                    );

                 
                  }

          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

void removeField(int index)async{ // removes items from database
  DocumentReference ref = Firestore.instance.collection('lists').document(globals.documentName);
  DocumentSnapshot doc = await ref.get();
  List tags = doc.data['items'];
  final hold = tags.elementAt(index); // holds an instance of item trying to delete
  print(hold);
  
  ref.updateData({
    'items': FieldValue.arrayRemove([hold]),// does the deleting
  });
}