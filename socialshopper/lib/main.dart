import 'package:flutter/material.dart';
import 'package:socialshopper/menu.dart';
import 'package:socialshopper/store_select.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'menu.dart';
import 'app_settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    StoreSelect.tag: (context) => StoreSelect(),
    HomePage.tag: (context) => HomePage(),
    MenuPage.tag: (context) => MenuPage(),
    Settings.tag: (context) => Settings(),
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