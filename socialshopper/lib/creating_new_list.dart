import 'package:flutter/material.dart';

import 'globals.dart' as globals;

class NewList extends StatefulWidget {
  static String tag = 'new-list';

  @override
  _NewList createState() => new _NewList();
}

class _NewList extends State<NewList> {
  final shoppinglist = [
    'item 1',
    'item 2',
    'item 3',
    'item 4',
    'item 5',
    'item 6',
    'item 7',
    'item 8',
    'item 9',
    'item 10',
    'item 11',
    'item 12',
    'item 13',
    'item 14',
    'item 15',
    'item 16',
    'item 17',
    'item 18',
    'item 19',
    'item 20',
    'item 21',
    'item 22'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('new List'),
        backgroundColor: globals.mainColor,
      ),
      body: ListView.builder(
        itemCount: shoppinglist.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(shoppinglist[index]),
          );
        },
      ),
    );
  }
}
