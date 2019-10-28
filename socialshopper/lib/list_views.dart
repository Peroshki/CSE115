import 'package:flutter/material.dart';
import 'main.dart';
import 'menu.dart';

List<String> items = [
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
  'Posole',
  'Tacos',
  'Wings',
  'Onions',
  'Salsa',
  'Chips',
  'Coffee',
  'Almond Milk',
  'Cookies',
  'total: ',
  'your total: ',
];

List<double>  prices= [
  1.23,
  2.34,
  1.11,
  4.44,
  1.29, //10.41
  1.72,
  14.21,
  3.22,
  0.99,
  3.21, //33.76
  4.00,
  2.00,
  1.89,
  2.00, //43.65
  1.92,
  1.33,
  1.23,
  2.22,
  4.00, //54.35
  3.89,
  1.28,
  2.30,
  3.33,
  1.47,
  2.21,
  5.40, //74.23
  3.00,
  4.00,
  7.00,
  1.00,
  2.00, //91.23
  3.89,
  2.67,
  3.45,//101.24
  101.24,
  101.24,
];

class ListViews extends StatefulWidget {
  static String tag = 'list_views';
  @override
  _ListViewsState createState() => _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  /*bool isChecked = false;

  void onChanged(bool value)
  {
    setState(() {
      isChecked = value;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(

        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              height: 50,
              color: Colors.white,
              child: FlatButton(
                onPressed: () {},
                //Text: "there it is!";
                child: Text(
                    '${items[index]}: \$${prices[index].toStringAsFixed(2)}'),
              ));
        },
      ),
    );
  }
}