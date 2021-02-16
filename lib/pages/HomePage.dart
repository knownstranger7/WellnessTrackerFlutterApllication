import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'LogInPage.dart';
import 'SignUpPage.dart';

class Homepage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Stack(
            children: <Widget>[Center(child: SwitchScreen())],
          )),
    );
  }
}

class SwitchScreen extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;

  void toggleSwitch(bool value) {
    if (isSwitched == true) {
      setState(() {
        isSwitched = false;
      });
    } else {
      setState(() {
        isSwitched = false;
        Navigator.of(context).push(ToLoginpage());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        'Wellness Check!',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
            fontFamily: 'ShareTechMono'),
      ),
      Transform.scale(
          scale: 2,
          child: Switch(
            onChanged: toggleSwitch,
            value: isSwitched,
            activeColor: Colors.black,
            activeTrackColor: Colors.white70,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.black45,
          )),
    ]);
  }
}

Route ToLoginpage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => LogInPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}