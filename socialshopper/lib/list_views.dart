import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListViews extends StatefulWidget {
  static String tag = 'list_views';

  // Stores the name of the list which you wish to view, obtained from the constructor
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
                    return Container(
                      height: 50,
                      color: Colors.blue,
                      child: Center(
                          child: Text(snapshot.data['items'][index]['name'] + ': ' + snapshot.data['items'][index]['price'].toString())
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
