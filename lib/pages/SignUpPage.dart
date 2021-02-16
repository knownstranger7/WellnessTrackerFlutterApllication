import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'HomePage.dart';
import 'LogInPage.dart';
import 'MainPage.dart';




class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _username;
  var _email;
  var _password;

  final usernameCon = new TextEditingController();
  final emailCon = new TextEditingController();
  final passwordCon = new TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("WELLNESS",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'ShareTechMono',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: 70,
                                    height: 70,
                                    child: Image.asset("assets/white.png")
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("TRACKER",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'ShareTechMono',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                    fontSize: 45,
                                    fontFamily: 'ShareTechMono',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Username',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 15,
                              child: TextFormField(
                                controller: usernameCon,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontFamily: 'OpenSans'),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  hintText: 'Enter your username',
                                  hintStyle: TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                  suffixIcon: Icon(Icons.account_circle,
                                      color: Colors.white
                                    //color: Colors.black54,
                                  ),
                                ),
                                validator: (value) => value.isEmpty
                                    ? 'Email can\'t be empty'
                                    : null,
                                onSaved: (value) => _username = value.trim(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Email',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 15,
                              child: TextFormField(
                                controller: emailCon,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontFamily: 'OpenSans'),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  hintText: 'Enter your email',
                                  hintStyle: TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                  suffixIcon: Icon(Icons.mail,
                                      color: Colors.white
                                    //color: Colors.black54,
                                  ),
                                ),
                                validator: (value) => value.isEmpty
                                    ? 'Email can\'t be empty'
                                    : null,
                                onSaved: (value) => _email = value.trim(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Password',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 15,
                              child: TextFormField(
                                controller: passwordCon,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontFamily: 'OpenSans'),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                  suffixIcon:
                                  Icon(Icons.lock, color: Colors.white),
                                ),
                                validator: (value) => value.isEmpty
                                    ? 'Password can\'t be empty'
                                    : null,
                                onSaved: (value) => _password = value.trim(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                                onPressed: () {
                                  print('Signed up');
                                  auth.createUserWithEmailAndPassword(email: emailCon.text.trim(), password: passwordCon.text.trim()).then((value) =>
                                  {
                                            FirebaseAuth.instance.currentUser
                                                .updateProfile(
                                              displayName:
                                                  usernameCon.text.trim(),
                                            ),

                                          });
                                  print("before it");

                                  print("after it");
                                  FirebaseFirestore.instance.collection(auth.currentUser.uid).doc("userdata").set(
                                      {
                                        "age":"Enter Age",
                                        "gender":"Enter Gender"
                                      });


                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Mainpage()));

                                  print("Display name:");
                                  print(user.displayName);
                                },
                                color: Colors.white,
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20,fontFamily: "ShareTechMono"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Already have an account?",style: TextStyle(color: Colors.grey),),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage())) ;
                                  },
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Arimo'),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



createAlertDialog1(BuildContext context) {
  TextEditingController customController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'INVALID LOGIN',
                style: TextStyle(
                    color: Color.fromRGBO(159, 163, 167, 1),
                    fontFamily: 'Arimo',
                    fontSize: 14.5),
              ),
            ],
          ),
          elevation: 20.0,
          //backgroundColor: Color.fromRGBO(34, 45, 54, 1),
        );
      });
}

Route ToMainpage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Mainpage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route ToHomepage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Homepage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

