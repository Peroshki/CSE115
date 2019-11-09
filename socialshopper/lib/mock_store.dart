import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialshopper/creating_new_list.dart';

List<String> produce_Item = [
  'Orange',
  'Banana',
  'Cucumber',
  'Broccoli',
  'Apples',
  'Grapes',
];

class Produce extends StatefulWidget {
  @override
  _Produce createState() => _Produce();
}

List<int> quantity = new List()..length = 500;

class _Produce extends State<Produce> {
  @override
  void initState() {
    for (int i = 0; i < 100; i++) {
      quantity.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: produce_Item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
            child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
              //padding: EdgeInsets.only(right: 90),
              flex: 3,
              child: Text(
                (index + 1).toString() + " " + produce_Item.elementAt(index),
                style: TextStyle(fontFamily: 'Open Sans'),
              ),
            ),
            Expanded(
                //width: 50,
                // child: IconButton(icon: Icon(Icons.remove),
                // onPressed: (){
                //   setState(() {
                //     quantity.insert(index, quantity.elementAt(index) + 1);
                //   });
                // },),
                flex: 1,
                child: TextField(
                  autofocus: false,
                  maxLength: 3,
                  maxLengthEnforced: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.go,
                  onChanged: (val) {
                    var quan = int.parse(val);
                    quantity.insert(index, quan);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Qty'),
                )),
            // new Container(
            //   //padding: EdgeInsets.only(left: 140),
            //   child: Text(quantity.elementAt(index).toString()),
            //   // child: ListTile(leading: Icon(Icons.ac_unit),
            //   //)
            // ),
            // new Container(
            //   //alignment: Alignment(0, 0),
            //   //width: 90,
            //   //padding: EdgeInsets.only(left: 40),
            //   child:
            //   IconButton(alignment: Alignment.centerLeft,icon: Icon(Icons.add,),
            //   onPressed: (){
            //     setState(() {
            //       Text(quantity.elementAt(index).toString());
            //       quantity.insert(index, quantity.elementAt(index) -1);
            //     });
            //   },),
            // )
          ],
        ));
      },
    );
  }
}

class MockStore extends StatefulWidget {
  static String tag = 'mock-store';
  @override
  _MockStore createState() => _MockStore();
}

class _MockStore extends State<MockStore> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Select Items')),
        body: selectBottomNav(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Produce'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              title: Text('Snacks'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_ind), 
                title: Text('Drinks')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mood),
              title: Text('Meat')
            )
          ],
        ));
  }

  Widget selectBottomNav(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return Produce();
    }
  }
}
