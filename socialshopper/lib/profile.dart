import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'friends_list.dart';
import 'login_page.dart';

//Create an instance
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;

class Profile extends StatefulWidget {
  static String tag = 'Profile';
  final String uid;

  Profile({Key key, @required this.uid}) : super(key: key);

  //@override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
//class _Profile extends StatelessWidget{
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text('Profile'),
          automaticallyImplyLeading: false,
          //code for back button
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(widget.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return new Text("Loading");
                    }
                    var userDocument = snapshot.data;
                    return Text(
                      'Hello, ${userDocument['displayName']}!',
                      style: TextStyle(fontSize: 30),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage('https://cdn4.iconfinder.com/data/icons/forum-buttons-and-community-signs-1/794/profile-3-512.png')))),
              ),
              Text(
                'You currently have: 0 Lists',
                style: TextStyle(fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(widget.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return new Text("Loading");
                    }
                    var userDocument = snapshot.data;
                    return Text(
                      '${userDocument["email"]}',
                      style: TextStyle(fontSize: 20),
                    );
                  },
                ),
              ),
              FlatButton(
                color: Colors.blue,
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: () {
                  authService.signOut();
                  Navigator.of(context).pushNamed(LoginPage.tag);
                },
              ),

              //button to view friends
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'View Friends',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    Friends.tag,
                    arguments: widget.uid
                  );
                },
              ),

              //counter for how many lists have
            ],
          ),
        ));
  }
}
