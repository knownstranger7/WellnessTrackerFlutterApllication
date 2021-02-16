import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'Account.dart';
import 'ChatBot.dart';
import 'ManualRec.dart';
import 'NavHome.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final formKey = new GlobalKey<FormState>();

  int index = 0;

  var pages = [NavHome(), ManualRec(), ChatBot(), Account()];

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://welness-tracker.herokuapp.com/medidata?state=N"),
        headers: {"Accept": "application/json"});
    List record = json.decode(response.body);
    print(record);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (cIndex) {
            setState(() {
              index = cIndex;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home, color: Colors.white54),
              title: new Text('Home',style: TextStyle(color: Colors.white54),),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.list, color: Colors.white54),
              title: new Text('Manual Rec',style: TextStyle(color: Colors.white54)),
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.help, color: Colors.white54),
                title: new Text('ChatBot',style: TextStyle(color: Colors.white54))),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.white54),
                title: Text('Account',style: TextStyle(color: Colors.white54)))
          ],
        ));
  }
}