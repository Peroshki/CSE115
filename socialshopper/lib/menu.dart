import 'package:flutter/material.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'list_views.dart';
import 'store_select.dart';

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
      case 0: return Scaffold( //Scaffold is the main container for main page
        appBar: AppBar( //title bar at the top of the page
          centerTitle: true,
          title: Text('Settings'),
          automaticallyImplyLeading: false,
        ),
      );
      case 1: return Scaffold( //Scaffold is the main container for main page
        appBar: AppBar( //title bar at the top of the page
          centerTitle: true,
          title: Text('Lists'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),
              onPressed: null,),
            IconButton(icon: Icon(Icons.add),
              onPressed:  () {
                Navigator.of(context).pushNamed(StoreSelect.tag);
              }),
          ],
          automaticallyImplyLeading: false,
        ),
      );
      case 2: return Scaffold( //Scaffold is the main container for main page
        appBar: AppBar( //title bar at the top of the page
          centerTitle: true,
          title: Text('Profile'),
          automaticallyImplyLeading: false,
        ),
      );
    }
    return Center(child: Text("No body for selected tab"),);
  }
}

