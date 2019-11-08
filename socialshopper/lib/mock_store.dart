import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MockStore extends StatefulWidget{
  static String tag = 'mock-store';
  @override
  _MockStore createState() => _MockStore();

}

class _MockStore extends State<MockStore>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Select Items')
      ),
      body: Text('data'));
  }
}