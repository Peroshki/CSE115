import 'package:flutter/material.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( //Scaffold is the main container for main page
      appBar: AppBar( //title bar at the top of the page
        title: Text('Social Shopper'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),
          onPressed: null,),
          IconButton(icon: Icon(Icons.add),
          // color: Colors.red,
          // iconSize: 24.0,
          onPressed: null,),
        ],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[(Text('This is some text'))])),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Setting'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          title: Text('Main Menu'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind), title: Text('Profile'))
      ]),
    );
  }
}

class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_shopping_cart),
          title: Text('Shopping Cart'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), title: Text('Settings'))
      ]),
    );
  }
}
