import 'dart:ffi';

import 'package:flutter/material.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'list_views.dart';
import 'store_select.dart';
import 'creating_new_list.dart';
import 'package:flutter/src/material/page.dart';

List<String> _random = ["chicken", "rice", "milk", "eggs", "letuce"
,"soda", "shrimp", "ceral", "napkins", "orange juice","apple juice", "Sprite", 
"Ranch", "BBQ", "Ketchup"
,"Tomates", "Bananas", "Avocado", "Celeray", "Brocoli","Oatmeal", "Lucky Charms", 
"Egg Whites", "Corn Dogs", "Tamales",
"Posole", "Tacos", "Wings", "Onions", "Salsa","Chips", "Coffee", "Almond Milk", "Cookies", "Mayo"];


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

  void listPress(int index){

    setState(() {
      _selectedIndex = index;
    });
  }

  String _textString = 'Hello There';

  void _doSomething(String text){
    setState(() {
     _textString = text; 
    });
  }

List<String> _numList = []; //Array to hold the lists

  void _addNewList(String task){ //allows to change state of the list appearing
  if(task.length > 0){
    setState(() => _numList.add(task));
  }
  }

  void _getIndex(int index){  //change state of list
     setState(() => _numList.elementAt(index));
  }

  void _openList(int index){ // Open up a single list
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context){
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(_numList[index]),
          ),
          body: new ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _random.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                height: 50,
                color: Colors.amber[500],
                child: Center(child: Text('${_random[index]}')),
              );
            },
          )
        );
      })
    );
  }

  Widget _buildList(){  //This is the whole list
    return new ListView.builder(
      itemBuilder: (context, index){
        if(index < _numList.length){
          return _buildTodoItem(_numList[index], index);
        }
      }
    );
  }

Widget _buildTodoItem(String listName, int index){  //Build one list
  return new ListTile(
    title: new Text(listName),
    onTap: () => _openList(index)
  );
}

void _tapAddMoreItems(){
  Navigator.of(context).push(
    // MaterialPageRoute will automatically animate the screen entry, as well
    // as adding a back button to close it
    new MaterialPageRoute(
      builder: (context) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Add a new task')
          ),
          body: new TextField(

            autofocus: true,
            onSubmitted: (val) {
              _addNewList(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
              hintText: 'Enter List Name',
              contentPadding: const EdgeInsets.all(16.0)
            ),
          )
        );
      }
    )
  );
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
        body: _buildList(),
        floatingActionButton: new FloatingActionButton(
          onPressed: _tapAddMoreItems,
          tooltip: 'Name List',
          child: new Icon(Icons.add),
        ),
        // ListView(  //Creates a list of all elements in the list
        //   padding: const EdgeInsets.all(8),
        //   children: <Widget>[
        //     TextField(onChanged: (text){ // Changes name of title, but looks strange
        //       _doSomething(text);
        //     }),
        //     Container( // Example of a single list on the main page
        //     decoration: BoxDecoration(
        //       border: Border.all(width: 1, color: Colors.black38),
        //       borderRadius: const BorderRadius.all(const Radius.circular(8))
        //     ),
        //     child: ListTile(
        //      title: Text(_textString,
        //      style: TextStyle(fontSize: 30), 
        //      ),
        //     trailing: Icon(Icons.keyboard_arrow_right),
        //     onTap: () {
        //       Navigator.of(context).pushNamed(NewList.tag);  //Linker to next page
        //     },
        //     // onLongPress: (){   //To change name of the list title
        //     //   TextField(onChanged: (text){
        //     //     _doSomething(text);
        //     //   });
        //     // },
        //     ),)

        //   ],
        // ),
      );
      case 2: return Scaffold( //Scaffold is the main container for main page
        appBar: AppBar( //title bar at the top of the page
          centerTitle: true,
          title: Text('Profile'),
          automaticallyImplyLeading: false,
        ),
      );

    }
    return Center(
      child: const Text('No body for selected tab'),
    );
  }
}
