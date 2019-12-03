import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'friends_list.dart';
import 'globals.dart' as globals;
import 'login_page.dart';


//Create an instance
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;

class Profile extends StatefulWidget {
  static String tag = 'Profile';

  final String uid;

  // Constructor
  Profile({Key key, @required this.uid}) : super(key: key);

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isSwitched = false;

  //Get and initialize currently logged in user.

  //If user data has an image then use that, else use some icon.
  String imageInit() {
    if (user.photoUrl == null) {
      return 'https://cdn4.iconfinder.com/data/icons/forum-buttons-and-community-signs-1/794/profile-3-512.png';
    } else
      return user.photoUrl;
  }

  //Get the user that is currently logged in.
  initUser() async {
    user = await _auth.currentUser();
    return user;
  }

  //Now uses streambulder to get data from firestore based on the user's uid.
  //First streambuilder gets display name from database
  //Second streambuilder gets email from database
  @override
  Widget build(BuildContext context) {
    initUser();
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: globals.mainColor,
          title: const Text('Profile'),
          automaticallyImplyLeading: false,
          //code for back button
        ),
        body: Center(
            child: Container(
          color: Colors.transparent,
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(globals.userUID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                var userDocument = snapshot.data;

                int numFriends = userDocument['friends'].toList().length;
                int numLists = userDocument['lists'].toList().length;

                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Text(
                      'Hello, ${userDocument['displayName']}!',
                      style: TextStyle(fontSize: 30.0),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(90, 10, 90, 10),
                        child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(imageInit() ?? globals.anonPhoto))),
                    Text(
                      (numLists == 1 && numFriends == 1) ? '$numFriends Friend, $numLists List'
                      : (numFriends == 1) ? '$numFriends Friend          $numLists Lists'
                      : (numLists == 1) ? '$numFriends Friends          $numLists List'
                      : '$numFriends Friends          $numLists Lists',
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.0),
                    Column(children: <Widget>[
                      FlatButton(
                        color: globals.mainColor,
                        textColor: Colors.white,
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                          left: 12.0,
                          right: 12.0
                        ),
                        child: Text(
                          'Friends',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            Friends.tag,
                          );
                        },
                      ),
                      SizedBox(height: 10.0),
                      FlatButton(
                        color: globals.mainColor,
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Log Out',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        onPressed: () {
                          authService.signOut();
                          Navigator.of(context).pushNamed(LoginPage.tag);
                        },
                      ),
                    ]),

                    //button to view friends
                  ],
                );
              }
            },
          ),
        )
            //counter for how many lists have
            ));
  }
}
