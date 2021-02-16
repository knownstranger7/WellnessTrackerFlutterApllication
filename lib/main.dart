import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wellnesstracker/services/AuthValidate.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: AuthValidate(),
    debugShowCheckedModeBanner: false,
  ));
}












