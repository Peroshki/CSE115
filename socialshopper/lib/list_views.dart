import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'menu.dart';


List<String> _random = [
  'chicken',
  'rice',
  'milk',
  'eggs',
  'letuce',
  'soda',
  'shrimp',
  'ceral',
  'napkins',
  'orange juice',
  'apple juice',
  'Sprite',
  'Ranch',
  'BBQ',
  'Ketchup',
  'Tomates',
  'Bananas',
  'Avocado',
  'Celeray',
  'Brocoli',
  'Oatmeal',
  'Lucky Charms',
  'Egg Whites',
  'Corn Dogs',
  'Tamales',
  'Posole', //LMAO
  'Tacos',
  'Wings',
  'Onions',
  'Salsa',
  'Chips',
  'Coffee',
  'Almond Milk',
  'Cookies',
  'Mayo'
];

class ListViews extends StatefulWidget {
  static String tag = 'list_views';
  final String listName;

  ListViews({Key key, @required this.listName}) : super(key: key);

  @override
  _ListViewsState createState() => _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('lists').document(widget.listName).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Text('Loading data... Please wait.');

          if (snapshot.data['items'] == null)
            return Center(child: Text('List is empty.'));

          return ListView.builder(
                  itemCount: snapshot.data['items'].length,
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
