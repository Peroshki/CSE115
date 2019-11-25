import 'package:flutter/material.dart';
import 'list_setup.dart';
import 'menu.dart';

class StoreSelect extends StatefulWidget {
  static String tag = 'store-select';
  @override
  _StoreSelectState createState() => _StoreSelectState();
}

class Arguments{
  String userId;
  Arguments(this.userId);
}

class _StoreSelectState extends State<StoreSelect> {
  //Creates an alert to the user saying that these buttons aren't implemented.
  Future<void> createAlert(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Not Implemented'),
            content: const Text('Coming Soon!'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    const String title = 'Store Select';
    
    //final Arguments args = ModalRoute.of(context).settings.arguments;

    //Creates the Safeway Button
    final safewayButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
                ListSetup.tag,
                arguments: ModalRoute.of(context).settings.arguments,
              );
        },
        padding: EdgeInsets.all(12),
        color: Colors.red[100],
        child: Text('Safeway', style: TextStyle(color: Colors.black)),
      ),
    );

    //Creates the BestBuy Button
    final bestbuyButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(ListSetup.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[100],
        child: Text('BestBuy', style: TextStyle(color: Colors.black)),
      ),
    );

    //Creates the Home Depot Button
    final homeDepotButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          createAlert(context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.orange[100],
        child: Text('Home Depot', style: TextStyle(color: Colors.black)),
      ),
    );

    //Creates the Party City Button
    final partyCityButton = Padding(
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

    //Starts the desplay to the screen
    return MaterialApp(
      title: title,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('Store Select Screen'),

            //Allows for the page to have a "go back" button
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),

        //Creates the grid of buttons
        body: Center(
          heightFactor: 10,
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: safewayButton,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: bestbuyButton,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: homeDepotButton,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: partyCityButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
