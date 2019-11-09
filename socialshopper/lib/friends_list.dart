import 'package:flutter/material.dart';
import 'package:socialshopper/store_select.dart';
import 'main.dart';
import 'profile.dart';

List<String> friends = [
  'Axel',
  'Omar',
  'Alan',
  'Ralph',
  'Sean',
  'Bob',
  'Jacob',
  'arnold',
  'Joe',
  'Sarah',
  'Jessica',
  'Rick',
];

class Friends extends StatefulWidget{
  static String tag = "friends_list";
  _friendState createState() => _friendState();

}

class _friendState extends State<Friends> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Friends"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){},
          )
        ],

      ),
      body: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      'https://i.imgur.com/BoN9kdC.png')))),
                  title: Text(friends[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          //ensures user wants to delete this
                          return AlertDialog(
                            title: Text('Deleting friends'),
                            content: Text('Are you sure you want to delete: ${friends[index]}'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Delete"),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Cancle"),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        }
                      );},
                  )
                );
            }),
          );
  }
}