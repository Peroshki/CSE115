import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Color mainColor = const Color.fromARGB(255, 43, 190, 254);

String userUID;

class Friend {
  Friend.fromMap(Map<dynamic, dynamic> data)
      : name = data['name'],
        photo = data['photo'],
        uid = data['uid'];

  String name;
  String photo;
  String uid;
  Timestamp lastSeen;
}

class User {
  User.fromSnapshot(DocumentSnapshot snapshot)
      : displayName = snapshot['displayName'],
        email = snapshot['email'],
        friends = List.from(
            snapshot['items'].map((item) => item = Friend.fromMap(item))),
        lists = List.from(snapshot['lists']),
        photoURL = snapshot['photoURL'],
        uid = snapshot.documentID;

  String displayName;
  String email;
  List<Friend> friends;
  List<String> lists;
  String photoURL;
  String uid;
}

class ListUser {
  ListUser.fromMap(Map<dynamic, dynamic> data)
      : name = data['name'],
        uid = data['uid'];

  String name;
  String uid;
}

// Represents an item in the shopping list
class Item {
  Item.fromMap(Map<dynamic, dynamic> data)
      : name = data['name'],
        price = data['price'] * 1.0,
        quantity = data['quantity'],
        users = List.from(data['users']);

  String name;
  double price;
  int quantity;
  List<String> users;
}

// Represents the metadata from the shopping list
class Metadata {
  Metadata.fromMap(Map<dynamic, dynamic> data)
      : budget = data['budget'] * 1.0,
        store = data['store'],
        timeCreated = data['timeCreated'],
        uid = data['uid'],
        name = data['name'],
        users = List.from(
            data['users'].map((item) => item = ListUser.fromMap(item)));

  double budget;
  String store;
  Timestamp timeCreated;
  String uid;
  String name;
  List<ListUser> users;
}

// Represents a shopping list from Firebase
class ShoppingList {
  ShoppingList.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        items = List.from(
            snapshot['items']?.map((item) => item = Item.fromMap(item))),
        metadata = Metadata.fromMap(snapshot['metadata']);

  String documentID;
  List<Item> items;
  Metadata metadata;
}
