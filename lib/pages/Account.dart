import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart' as m1;
//import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mailer2/mailer.dart' ;
import 'package:pdf/pdf.dart';

import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

import 'LogInPage.dart';

class Account extends StatefulWidget {

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  var _nametext = "username";
  var _emailtext = "email";
  var _agetext = "age";
  var _gendertext = "gender";


  int count = 0;
  double bodytemperatureavg=0;
  int bloodpressureavg=0;
  int respirationavg=0;
  int glucoseavg=0;
  int heartrateavg=0;
  int cholesterolavg=0;
  int oxygensaturationavg=0;
  int stepswalked;
  String age;
  String gender;
  FToast fToast;
  Icon icon;
  Color color;
  String ourfile;
  String chd;


  var myFormat = DateFormat('d-MM-yyyy');


  TextEditingController _cname;
  TextEditingController _cemail;
  TextEditingController _cage;
  TextEditingController _cgender;

  @override
  initState(){
    _cname = new TextEditingController();
    _cemail = new TextEditingController();
    _cage = new TextEditingController();
    _cgender = new TextEditingController();
    super.initState();
    fToast = FToast();
    fToast.init(context);

  }

  DateTime dateToday = DateTime(DateTime
      .now()
      .year, DateTime
      .now()
      .month, DateTime
      .now()
      .day);

  sendMail()  async {
    // String email = 'wellnesstracker7@gmail.com';
    // String password = 'trackerwellness*7';

    var options = new GmailSmtpOptions()
      ..username = 'wellnesstracker7@gmail.com'
      ..password = 'trackerwellness*7';


    // ignore: deprecated_member_use
    // final smtpServer = gmail(email, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.
    // Create our message.
    var emailTransport = new SmtpTransport(options);

    var envelope = new Envelope()
    // final message = m1.Message()
      ..from = 'wellnesstracker7@gmail.com'
      ..recipients.add(user.email)
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Daily Health Report ${myFormat.format(dateToday)}'
      ..attachments.add(Attachment(file: new File(ourfile)))
      ..html = "<h1>Daily Health Report ${myFormat.format(dateToday)}</h1>"
          "<p1>Hi ${user.displayName}, Your Health Report for ${myFormat.format(dateToday)} is here.</p1>";

    // try {
    //   final sendReport = await m1.send(message, smtpServer);
    //
    //   print('Message sent: ' + sendReport.toString());
    // } on m1.MailerException catch (e) {
    //   print('Message not sent.');
    //   for (var p in e.problems) {
    //     print('Problem: ${p.code}: ${p.msg}');
    //   }
    // }

    emailTransport.send(envelope)
        .then((envelope) {
      print('Email sent!');
      emailToast("Email Sent!");
    })
        .catchError((e) => print('Email Error occurred: $e'));

  }

  emailToast(emailtoasttext) {
    if(emailtoasttext=="Sending Health Report"){
      icon=Icon(Icons.timelapse);
      color=Colors.lightBlueAccent;
    } else if(emailtoasttext=="Email Sent!"){
      icon=Icon(Icons.check);
      color=Colors.lightGreenAccent;
    }
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(
            width: 12.0,
          ),
          Text(emailtoasttext),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
  }

  Future<Uint8List> Pdfgenerator() async {
    final pdf = pw.Document();
    // final image = pw.MemoryImage(File('/storage/emulated/0/Android/data/com.example.wellnesstracker/files/pdflogo.png').readAsBytesSync(),
    // );

    // final assetImage = PdfImage.file(
    //   pdf.document,
    //   bytes:rootBundle.load('assets/pdflogo.png').buffer.asUint8List()
    // );
    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/pdflogo1.png')).buffer.asUint8List(),
    );


    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),

        build: (pw.Context context) => pw.Column(
            children:<pw.Widget> [
              pw.Image(profileImage),
              pw.Center(
                child: pw.Header(
                    level: 0,
                    child: pw.Text("Daily Health Report",style: pw.TextStyle(fontSize: 20,))
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children:<pw.Widget>[
                      pw.Text("Name: ${user.displayName}"),
                      pw.SizedBox(
                          height: 5
                      ),
                      pw.Text("Age: $age"),
                    ]
                  ),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children:<pw.Widget>[
                        pw.Text("Date: ${myFormat.format(dateToday)}"),
                        pw.SizedBox(
                            height: 5
                        ),
                        pw.Text("Gender: $gender"),
                      ]
                  ),
                ]
              ),
              pw.Divider(
                thickness: 1
              ),

              pw.SizedBox(
                  height: 10
              ),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children:<pw.Widget>[
                    pw.Container(
                        //height: 20,
                        width: 140,
                        child:pw.Column(
                            children: <pw.Widget>[
                              pw.Text("Body Temperature",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(
                                  height: 5
                              ),
                              pw.Text("${bodytemperatureavg}°C"),
                            ]
                        ),
                    ),

                    pw.Container(
                      //height: 20,
                        width: 140,
                        child:pw.Column(
                            children: <pw.Widget>[
                              pw.Text("Blood Pressure",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(
                                  height: 5
                              ),
                              pw.Text("$bloodpressureavg mmHg"),
                            ]
                        ),
                    ),

                    pw.Container(
                      //height: 20,
                        width: 140,
                        child: pw.Column(
                            children: <pw.Widget>[
                              pw.Text("Respiration",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(
                                  height: 5
                              ),
                              pw.Text("$respirationavg BPM"),
                            ]
                        ),
                    ),

                    pw.Container(
                      //height: 20,
                        width: 140,
                        child: pw.Column(
                            children: <pw.Widget>[
                              pw.Text("Glucose",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(
                                  height: 5
                              ),
                              pw.Text("$glucoseavg mg/dL"),
                            ]
                        ),
                    ),

                  ]
              ),
              pw.SizedBox(
                  height: 10
              ),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children:<pw.Widget>[
                    pw.Container(
                      //height: 20,
                        width: 140,
                        child:pw.Column(
                            children: <pw.Widget>[
                              pw.Text("Heart Rate",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(
                                  height: 5
                              ),
                              pw.Text("$heartrateavg BPM"),
                            ]
                        ),
                    ),

                    pw.Container(
                      //height: 20,
                        width: 140,
                        child: pw.Column(
                            children: <pw.Widget>[
                              pw.Text("Cholesterol",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(
                                  height: 5
                              ),
                              pw.Text("$cholesterolavg mg/dL"),
                            ]
                        ),
                    ),

                    pw.Container(
                      //height: 20,
                      width: 140,
                      child: pw.Column(
                          children: <pw.Widget>[
                            pw.Text("Oxygen Saturation",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(
                                height: 5
                            ),
                            pw.Text("${oxygensaturationavg}%"),
                          ]
                      ),
                    ),

                  ]
              ),
              pw.SizedBox(
                  height: 10
              ),
              pw.Divider(
                thickness: 1
              ),
              pw.SizedBox(
                  height: 10
              ),
              pw.Container(
                //height: 20,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: <pw.Widget>[
                      pw.Text("Coronary Heart Disease",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(
                          width: 5
                      ),
                      pw.Text(":"),
                      pw.SizedBox(
                          width: 5
                      ),
                      pw.Text("${chd}"),
                    ]
                ),
              ),
              pw.SizedBox(
                  height: 10
              ),
              pw.Divider(
                  thickness: 1
              ),


            ]


        ),
      ),
    );
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    final File ourfilex = File("$appDocPath/Wellness Tracker Healthreport ${myFormat.format(dateToday)}.pdf");
    print("File Location");
    print(ourfilex);
    await ourfilex.writeAsBytes(await pdf.save());
    ourfile=ourfilex.path.toString();
  }


  @override
  Widget build(BuildContext context) {

    FirebaseAuth user = FirebaseAuth.instance;


    if (user.currentUser.displayName!=null){
      _nametext = user.currentUser.displayName;
    } else{
      _nametext = "Enter Username";
      _agetext = "Enter Age";
      _gendertext = "Enter Gender";
    }
    _emailtext=user.currentUser.email;

    CollectionReference users = FirebaseFirestore.instance.collection(user.currentUser.uid);

    return FutureBuilder(
      future: users.doc("userdata").get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          _agetext="Enter age";
          _gendertext="Enter gender";
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          _agetext="Enter age";
          _gendertext="Enter gender";
        }
        if (snapshot.hasData) {
          // snapshot.data.docs.map((DocumentSnapshot document) {
          //   _agetext=document.data()['age'];
          //   _gendertext=document.data()['gender'];
          // });
          print(snapshot.data["age"]);
          return  Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black87,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      width: ((MediaQuery.of(context).size.width)/2)-90,
                      height: ((MediaQuery.of(context).size.width)/2)-90,
                      child: Image.asset("assets/white.png")
                  ),
                  // SizedBox(height: 20,),
                  Text(
                    "WELLNESS TRACKER",
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontFamily: "ShareTechMono",
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontFamily: "ShareTechMono",
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(

                    width:300,
                    child: Column(
                      children: <Widget>[
                        Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      width:(MediaQuery.of(context).size.width*0.25)-5,
                                      height: 40,
                                      alignment: Alignment.topLeft,
                                      child: Center(child: Text("Name",style: TextStyle(color: Colors.white),))),
                                  Container(
                                      width:5,
                                      alignment: Alignment.topLeft,
                                      child: Text(":",style: TextStyle(color: Colors.white),)),
                                  Container(
                                      width:(MediaQuery.of(context).size.width*0.25)+20,
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: Text(_nametext,style: TextStyle(color: Colors.white),),
                                      ))
                                ],
                              ),
                            )
                        ),

                        SizedBox(height: 10,),
                        Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      width:(MediaQuery.of(context).size.width*0.25)-5,
                                      height: 40,
                                      alignment: Alignment.topLeft,
                                      child: Center(child: Text("Age",style: TextStyle(color: Colors.white),))),
                                  Container(
                                      width:5,
                                      alignment: Alignment.topLeft,
                                      child: Text(":",style: TextStyle(color: Colors.white),)),
                                  Container(
                                      width:(MediaQuery.of(context).size.width*0.25)+20,
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: Text(snapshot.data["age"].toString().toUpperCase(),style: TextStyle(color: Colors.white),),
                                      ))
                                ],
                              ),
                            )
                        ),
                        SizedBox(height: 10,),
                        Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      width:(MediaQuery.of(context).size.width*0.25)-5,
                                      height: 40,
                                      alignment: Alignment.topLeft,
                                      child: Center(child: Text("Gender",style: TextStyle(color: Colors.white),))),
                                  Container(
                                      width:5,
                                      alignment: Alignment.topLeft,
                                      child: Text(":",style: TextStyle(color: Colors.white),)),
                                  Container(
                                      width:(MediaQuery.of(context).size.width*0.25)+20,
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: Text(snapshot.data["gender"].toString().toUpperCase(),style: TextStyle(color: Colors.white),),
                                      ))
                                ],
                              ),
                            )
                        ),
                        SizedBox(height: 10,),
                        Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      width:(MediaQuery.of(context).size.width*0.25)-5,
                                      height: 40,
                                      alignment: Alignment.topLeft,
                                      child: Center(child: Text("Email",style: TextStyle(color: Colors.white),))),
                                  Container(
                                      width:5,
                                      alignment: Alignment.topLeft,
                                      child: Text(":",style: TextStyle(color: Colors.white),)),
                                  Container(
                                      width:(MediaQuery.of(context).size.width*0.25)+20,
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: Text(_emailtext,style: TextStyle(color: Colors.white),),
                                      ))
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          showDialog(
                              child:  Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child:  Stack(
                                    overflow: Overflow.visible,
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.75,
                                        height:300,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: Color.fromRGBO(0, 8, 51, 1)
                                        ),
                                        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                                        child: Column(
                                          children: <Widget>[
                                            TextField(
                                              style: TextStyle(color: Colors.white),
                                              decoration: new InputDecoration(
                                                  hintText: "Name",
                                                  hintStyle: TextStyle(color: Colors.white)
                                              ),

                                              controller: _cname,
                                            ),
                                            TextField(
                                              style: TextStyle(color: Colors.white),
                                              decoration: new InputDecoration(
                                                  hintText: "Age",
                                                  hintStyle: TextStyle(color: Colors.white)
                                              ),

                                              controller: _cage,
                                            ),
                                            TextField(
                                              style: TextStyle(color: Colors.white),
                                              decoration: new InputDecoration(
                                                  hintText: "Gender",
                                                  hintStyle: TextStyle(color: Colors.white)
                                              ),

                                              controller: _cgender,
                                            ),

                                            FlatButton(
                                              child: new Text("Save",style: TextStyle(color:Colors.white,fontSize: 20),),
                                              onPressed: (){
                                                setState((){

                                                  this._nametext = _cname.text;
                                                  this._agetext = _cage.text;
                                                  this._gendertext = _cgender.text;

                                                });
                                                FirebaseAuth.instance.currentUser.updateProfile(
                                                  displayName: _nametext,
                                                );
                                                firestoreInstance.collection(user.currentUser.uid).doc("userdata").set(
                                                    {
                                                      "age":_agetext,
                                                      "gender":_gendertext
                                                    });
                                                print(firestoreInstance.collection(user.currentUser.uid).doc("userdata").snapshots());
                                                FirebaseAuth.instance.currentUser.reload();
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                              ), context: context);
                        },
                        color: Colors.black87,
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'ShareTechMono'),
                        ),
                      ),
                      SizedBox(width: 20,),
                      RaisedButton(
                        onPressed: () {
                          firestoreInstance.collection("users").where("uid",isEqualTo: user.currentUser.uid).where("date",isEqualTo:myFormat.format(dateToday)).get().then((QuerySnapshot querySnapshot) => {
                            querySnapshot.docs.forEach((doc) {
                              bodytemperatureavg=bodytemperatureavg+doc["bodytemperature"];
                              bloodpressureavg=bloodpressureavg+doc["bloodpressure"];
                              respirationavg=respirationavg+doc["respiration"];
                              glucoseavg=glucoseavg+doc["glucose"];
                              heartrateavg=heartrateavg+doc["heartrate"];
                              cholesterolavg=cholesterolavg+doc["cholesterol"];
                              oxygensaturationavg=oxygensaturationavg+doc["oxygensaturation"];
                              count++;
                              // print("Body Temperature: $bodytemperatureavg");
                              // print("Count: $count");
                              // chd=doc["chdprediction"];
                              // print(doc["chdprediction"]);

                            }),

                            {
                              bodytemperatureavg=(bodytemperatureavg/count),
                              bodytemperatureavg=double.parse(bodytemperatureavg.toStringAsFixed(1)),
                              bloodpressureavg=(bloodpressureavg~/count),
                              respirationavg=(respirationavg~/count),
                              glucoseavg=(glucoseavg~/count),
                              heartrateavg=(heartrateavg~/count),
                              cholesterolavg=(cholesterolavg~/count),
                              oxygensaturationavg=(oxygensaturationavg~/count),
                              print('Average Body Temperature:$bodytemperatureavg'),
                              print('Average Blood Pressure:$bloodpressureavg'),
                              print('Average Respiration:$respirationavg'),
                              print('Average Glucose:$glucoseavg'),
                              print('Average Heart Rate:$heartrateavg'),
                              print('Average Cholesterol:$cholesterolavg'),
                              print('Average Oxygen Saturation:$oxygensaturationavg'),

                            }
                          });

                          age=snapshot.data["age"];
                          gender=snapshot.data["gender"].toString().toUpperCase();
                          emailToast("Sending Health Report");
                          Pdfgenerator();
                          sendMail();



                        },
                        color: Colors.black87,
                        child: Text(
                          'Send Report',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'ShareTechMono'),
                        ),
                      ),
                    ],
                  ),




                  SizedBox(height: 30,),
                  RaisedButton(
                    onPressed: () {
                      signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LogInPage()));
                    },
                    color: Colors.white54,
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'ShareTechMono'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return  Center(child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ));
      },
    );


  }
  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch (e){
      print(e.toString());
      return null;
    }
  }
}




