import 'package:flutter/material.dart';
import 'login_page.dart';
import 'menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    MenuPage.tag: (context) => MenuPage(),
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