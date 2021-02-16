import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellnesstracker/pages/HomePage.dart';
import 'package:wellnesstracker/pages/LogInPage.dart';
import 'package:wellnesstracker/pages/MainPage.dart';

class AuthValidate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {


    final user = FirebaseAuth.instance.currentUser;
    print(user);

    if (user == null){
      return Homepage();
    } else {
      return Mainpage();
    }
  }
}