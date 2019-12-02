import 'package:flutter/material.dart';
import 'package:socialshopper/item_input.dart';
import 'package:socialshopper/payment.dart';
import 'package:socialshopper/store_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_friend.dart';
import 'friends_list.dart';
import 'globals.dart' as globals;
import 'theme.dart';
import 'package:provider/provider.dart';
import 'item_input.dart';
import 'list_setup.dart';
import 'login_page.dart';
import 'menu.dart';
import 'mock_store.dart';
import 'signup_page.dart';
import 'store_select.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;
var prefs;

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

void main(){
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('dark') ?? true;
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
          child: MaterialApp(home: MyApp()),
        ),
      );
    });
  
}

class MyApp extends StatelessWidget with ChangeNotifier {
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),
      title: 'SocialShopper',
      home: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
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
