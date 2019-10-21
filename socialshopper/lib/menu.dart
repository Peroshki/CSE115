import 'dart:ffi';

import 'package:flutter/material.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'list_views.dart';
import 'store_select.dart';
import 'creating_new_list.dart';
import 'app_settings.dart';
import 'package:flutter/src/material/page.dart';


class MenuPage extends StatefulWidget {
  static String tag = 'menu-page';
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 1;
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void listPress(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _textString = 'Hello There';

  void _doSomething(String text) {
    setState(() {
      _textString = text;
    });
  }

  final List<String> _numList = []; //Array to hold the lists

  void _addNewList(String task) {
    //allows to change state of the list appearing
    if (task.isNotEmpty) {
      setState(() => _numList.add(task));
    }
  }

  void _getIndex(int index) {
    //change state of list
    setState(() => _numList.elementAt(index));
  }

  void _openList(int index) {
    // Open up a single list
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Text(_numList[index]),
          ),
          body: ListViews(),
      );
    }));
  }

  Widget _buildList() {
    //This is the whole list
    return ListView.builder(itemBuilder: (context, index) {
      if (index < _numList.length) {
        return _buildTodoItem(_numList[index], index);
      }
    });
  }

  Widget _buildTodoItem(String listName, int index) {
    //Build one list
    return ListTile(title: Text(listName), onTap: () => _openList(index));
  }

  void _tapAddMoreItems() {
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well
        // as adding a back button to close it
        MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text('Add a new task')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addNewList(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: InputDecoration(
                hintText: 'Enter List Name',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold is the main container for main page
      body: _getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
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

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return Settings();
      case 1:
        return Scaffold(
          //Scaffold is the main container for main page
          appBar: AppBar(
            //title bar at the top of the page
            centerTitle: true,
            title: const Text('Lists'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: null,
              ),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(StoreSelect.tag);
                  }),
            ],
            automaticallyImplyLeading: false,
          ),
          body: _buildList(),
          floatingActionButton: FloatingActionButton(
            onPressed: _tapAddMoreItems,
            tooltip: 'Name List',
            child: Icon(Icons.add),
          ),
        );
      case 2:
        return Scaffold(
          //Scaffold is the main container for main page
          appBar: AppBar(
            //title bar at the top of the page
            centerTitle: true,
            title: const Text('Profile'),
            automaticallyImplyLeading: false,
          ),
        );
    }
    return Center(
      child: const Text('No body for selected tab'),
    );
  }
}
