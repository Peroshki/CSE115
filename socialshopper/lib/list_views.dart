import 'package:flutter/material.dart';
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
  @override
  _ListViewsState createState() => _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _random.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber[500],
            child: Center(child: Text('${_random[index]}')),
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
