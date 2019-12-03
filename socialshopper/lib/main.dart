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

var darkModeOn = false;
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;

void main() {
  SharedPreferences.getInstance().then((prefs) {
    darkModeOn = prefs.getBool('dark') ?? true;
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
      child: MaterialAppWTheme(),
    );
  }
}

class MaterialAppWTheme extends StatelessWidget {
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
    final theme = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: theme.getTheme(),
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
