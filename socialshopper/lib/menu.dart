import 'package:flutter/material.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'store_select.dart';
import 'main.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);
  static String tag = 'menu-page';
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<MenuPage> {
  int _selectedIndex = 1;
  bool _dmSelect = false;

//Creates an alert to the user saying that these buttons aren't implemented.
  createAlert(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Not Implemented'),
        content: Text('Coming Soon!'),
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    // If on the App Settings Page
    if(_selectedIndex == 0){
      return Scaffold(

        //Top bar of the app
        appBar: AppBar(
          title: Text('App Settings'),
        ),

        //All of the important app settings
        body: Center(
          child: ListView(
            children: <Widget>[

              //Display Settings
              ListTile(
                title: Text('Display', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    decoration: TextDecoration.underline,
                    fontSize: 20,
                  )
                ),
                subtitle: Text('Enable the settings to change the display.'),
              ),
              SwitchListTile(
                value: _dmSelect,
                title: Text('Dark Mode'),
                onChanged: (bool val) {
                  setState(() {
                    _dmSelect = val;
                  });
                },
              ),

              //Notifications to the user
              ListTile(
                title: Text('Notifications', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    decoration: TextDecoration.underline,
                    fontSize: 20,
                  )
                ),
                subtitle: Text('Enable the settings to recieve notifications.'),
              ),
              SwitchListTile(
                value: false,
                title: Text('Push Notifications enabled:'),
                onChanged: (value) {
                  createAlert(context);
                },
              ),
              SwitchListTile(
                value: false,
                title: Text('Email Notifications enabled:'),
                onChanged: (value) {
                  createAlert(context);
                },
              ),
              SwitchListTile(
                value: false,
                title: Text('Reminder to go shopping:'),
                onChanged: (value) {
                  createAlert(context);
                },
              ),

              // 
              ListTile(
                title: Text('Permissions', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    decoration: TextDecoration.underline,
                    fontSize: 20,
                  )
                ),
                subtitle: Text('Enable the settings to allow this app to access information on your device.'),
              ),
              SwitchListTile(
                value: false,
                title: Text('Allow access to the Downloads Folder:'),
                onChanged: (value) {
                  createAlert(context);
                },
              ),
              SwitchListTile(
                value: false,
                title: Text('Allow access to Venmo:'),
                onChanged: (value) {
                  createAlert(context);
                },
              ),
              SwitchListTile(
                value: false,
                title: Text('Allow access to Facebook:'),
                onChanged: (value) {
                  createAlert(context);
                },
              ),
              SwitchListTile(
                value: true,
                title: Text('Give devs your first born child:'),
                onChanged: (value) {
                  createAlert(context);
                },
              ),
            ]
          )
        ),

        //Bottom Navigation Bar Stuff
        bottomNavigationBar:
           BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
           icon: Icon(Icons.settings),
           title: Text('Setting'),
         ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
           title: Text('Lists'),
         ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind),
              title: Text('Profile')
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,),
      );
    }

    //If the app is on the Main page
    if(_selectedIndex == 1){
      return Scaffold( 
        
        //Top bar of the app
        appBar: AppBar( 
          title: Text('Social Shopper'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),
              onPressed: null,
            ),
           IconButton(icon: Icon(Icons.add),
             onPressed:() {
               Navigator.of(context).pushNamed(StoreSelect.tag);
             },
           ),
          ],
        ),

        //Where the lists will go in the finished product.
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[(Text('Omar\'s Stuff'))]
           ),
        ),

        // Bottom navigation bar stuff
        bottomNavigationBar:
           BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
           icon: Icon(Icons.settings),
           title: Text('Setting'),
         ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
           title: Text('Lists'),
         ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind),
              title: Text('Profile')
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,),
      );
    }

    //This is Sean's stuff
    if(_selectedIndex == 2){
      return Scaffold( 
        
        //Top bar of the app
        appBar: AppBar( 
          title: Text('Profile'),
        ),

        //Where the lists will go in the finished product.
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[(Text('Sean\'s Stuff'))]
           ),
        ),

        // Bottom navigation bar stuff
        bottomNavigationBar:
           BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
           icon: Icon(Icons.settings),
           title: Text('Setting'),
         ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
           title: Text('List'),
         ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind),
              title: Text('Profile')
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,),
      );
    }
  }
}
