import 'package:flutter/material.dart';
import 'main.dart';
import 'menu.dart';

class ListViews extends StatefulWidget{
  static String tag = 'list_views';
  @override
  _ListViewsState createState() => new _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('List Name'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
          ListTile(
            title: Text('Item 1'),
          ),
          ListTile(
            title: Text('Item 2'),
          ),
          ListTile(
            title: Text('Item 3'),
          ),
      ]
        ).toList()
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
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }
}