import 'package:flutter/material.dart';
import 'package:socialshopper/item_input.dart';
import 'package:socialshopper/list_views.dart';
import 'package:socialshopper/store_select.dart';
import 'list_setup.dart';
import 'login_page.dart';
import 'menu.dart';
import 'store_select.dart';
import 'signup_page.dart';
import 'item_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    MenuPage.tag: (context) => MenuPage(),
    StoreSelect.tag: (context) => StoreSelect(),
    SignupPage.tag: (context) => SignupPage(),
    ListSetup.tag: (context) => ListSetup(),
    UserItemInput.tag: (context) => UserItemInput(),
    //ListViews.tag: (context) => ListViews(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialShopper',
      home: LoginPage(),
      routes: routes,
    );
  }
}
