import 'package:flutter/material.dart';
import 'package:socialshopper/store_select.dart';
import 'main.dart';
import 'auth.dart';
import 'login_page.dart';
import 'friends_list.dart';

class Profile extends StatefulWidget {
  static String tag = 'Profile';
  //@override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
//class _Profile extends StatelessWidget{
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: Text('Profile'),
          automaticallyImplyLeading: false,
          //code for back button
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              'https://i.imgur.com/BoN9kdC.png')))),

              FlatButton(
                color: Colors.blue,
                textColor: Colors.black,
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  authService.signOut();
                  Navigator.of(context).pushNamed(LoginPage.tag);
                },
              ),

              //button to view friends
              FlatButton(
                color: Colors.blue,
                textColor: Colors.black,
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'View Friends',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(Friends.tag);
                },
              ),

              //counter for how many lists have
              Text(
                'You currently have: 0 Lists',
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ));
  }
}
