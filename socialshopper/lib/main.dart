import 'package:flutter/material.dart';
import 'package:socialshopper/item_input.dart';
import 'package:socialshopper/payment.dart';
import 'package:socialshopper/store_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_friend.dart';
import 'friends_list.dart';
import 'globals.dart' as globals;
import 'item_input.dart';
import 'list_setup.dart';
import 'login_page.dart';
import 'menu.dart';
import 'mock_store.dart';
import 'signup_page.dart';
import 'store_select.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;
void main() => runApp(MyApp());


// Future<FirebaseUser> init() async {
//  user = await _auth.currentUser();
//   if (user == null) {
//     return null;
//   }
//   else{
//     globals.userUID = user.uid;
//     return user;
//   }
// }


class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    MenuPage.tag: (context) => MenuPage(),
    StoreSelect.tag: (context) => StoreSelect(),
    SignupPage.tag: (context) => SignupPage(),
    ListSetup.tag: (context) => ListSetup(),
    UserItemInput.tag: (context) => UserItemInput(),
    Friends.tag: (context) => Friends(),
    MockStore.tag: (context) => MockStore(),
    AddFriend.tag: (context) => AddFriend(),
    Payment.tag: (context) => Payment(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialShopper',
      home: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
          if (snapshot.hasData) {
            globals.userUID = snapshot.data.uid;
            return MenuPage();
          }
          return LoginPage();
        },
      ),
      routes: routes,
    );
  }
}
