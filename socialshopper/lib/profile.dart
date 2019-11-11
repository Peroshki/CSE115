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
  //@override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
//class _Profile extends StatelessWidget{
  bool isSwitched = false;
  //Get and initialize currently logged in user.
  initUser() async {
    user = await _auth.currentUser();
  }

  //If user data has an image then use that, else use some icon.
  String imageInit() {
    if (user.photoUrl == null) {
      return 'https://cdn4.iconfinder.com/data/icons/forum-buttons-and-community-signs-1/794/profile-3-512.png';
    } else
      return user.photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    initUser();
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
                child: Text(
                  'Hello, ${user?.displayName}!',
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 2.0),
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
                            image: NetworkImage(imageInit())))),
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
