import 'package:flutter/material.dart';
import 'package:socialshopper/home_page.dart';
import 'main.dart';
import 'login_page.dart';

class StoreSelect extends StatefulWidget {
  static String tag = 'store-select';
  @override
  _StoreSelectState createState() => new _StoreSelectState();
}



class _StoreSelectState extends State<StoreSelect> {

  createAlert(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Not Implemented'),
        content: Text('Coming Soon!'),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final title = 'Store Select';

    final button1 = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[50],
        child: Text('Safeway', style: TextStyle(color: Colors.black)),
      ),
    );

    final button2 = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[50],
        child: Text('Bestbuy', style: TextStyle(color: Colors.black)),
      ),
    );

    final button3 = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          createAlert(context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[50],
        child: Text('Home Depot', style: TextStyle(color: Colors.black)),
      ),
    );

    final button4 = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          createAlert(context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[50],
        child: Text('Party City', style: TextStyle(color: Colors.black)),
      ),
    );

    return MaterialApp(
      title: title,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Store Select Screen"),
        ),
        body: GridView.count(
            primary: false, 
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget> [
              Container(
               padding: const EdgeInsets.all(8),
               child: button1,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: button2,
              ),
              Container(
               padding: const EdgeInsets.all(8),
               child: button3,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: button4,
              ),
            ],
          ),
      ),
    );
  }
}
