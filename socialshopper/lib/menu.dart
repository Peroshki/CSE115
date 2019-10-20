import 'package:flutter/material.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'list_views.dart';

class MenuPage extends StatefulWidget {
  static String tag = 'menu-page';
  @override
  _MenuPageState createState() => new _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( //Scaffold is the main container for main page
      appBar: AppBar( //title bar at the top of the page
        centerTitle: true,
        title: Text('Main Menu'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),
          onPressed: null,),
          IconButton(icon: Icon(Icons.add),
          // color: Colors.red,
          // iconSize: 24.0,
          onPressed: null,),
        ],
      ),
      body: _getBody(_selectedIndex),
      bottomNavigationBar:
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
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
  Widget _getBody(int index){
    switch(index){
      case 0: return Center(child: Text("Settings"),);
      case 1: return Center(child: Text("List"),);
      case 2: return Center(child: Text("Profile"),);
    }
  }
}

