import 'package:flutter/material.dart';
import 'package:socialshopper/store_select.dart';
import 'main.dart';
import 'profile.dart';

class Friends extends StatefulWidget{
  static String tag = "friends_list";
  _friendState createState() => _friendState();

}

class _friendState extends State<Friends>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Friends"),
      ),
    );
  }
}