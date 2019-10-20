import 'package:flutter/material.dart';

class NewList extends StatefulWidget {
  static String tag = 'new-list';
  @override
  _NewList createState() => new _NewList();
}

class _NewList extends State<NewList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('new List')),
      bottomNavigationBar: BottomNavigationBar(
        //currentIndex: _selectedIndex,
        //onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Setting'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text('Lists'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind), title: Text('Profile'))
        ],
      ),
    );
  }
}
