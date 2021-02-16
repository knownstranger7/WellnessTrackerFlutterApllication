
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart' as m1;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:mailer2/mailer.dart' ;
import 'package:wellnesstracker/services/httpservice.dart';
import 'package:pdf/widgets.dart' as pw;

class NavHome extends StatefulWidget {
  @override
  _NavHomeState createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> {
  final HttpService httpService = HttpService();
  final PredictService predictService = PredictService();
  final BlockchainService blockchainService = BlockchainService();

  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  var myFormat = DateFormat('d-MM-yyyy');
  Timer _timer;
  int count = 0;
  double bodytemperatureavg=0;
  int bloodpressureavg=0;
  int respirationavg=0;
  int glucoseavg=0;
  int heartrateavg=0;
  int cholesterolavg=0;
  int oxygensaturationavg=0;
  int stepswalked;

  int countermail=0;
  FToast fToast;
  String ourfile;

  Icon icon;
  Color color;

  String chd;

  @override
  void initState() {
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


  getdataperiodic(wellness) {
    const oneSec = const Duration(seconds: 3600);

    new Timer.periodic(oneSec, (Timer t) =>
        firestoreInstance.collection("users").add(
            {
              "uid": user.uid,
              "date": myFormat.format(dateToday),
              "steps": wellness.steps,
              "bodytemperature": wellness.bodyTemperature,
              "bloodpressure": wellness.bloodPressure,
              "respiration": wellness.respiration,
              "glucose": wellness.glucose,
              "heartrate": wellness.heartRate,
              "cholesterol": wellness.cholesterol,
              "oxygensaturation": wellness.oxygenSaturation,
              "chdprediction":chd,

            }).then((value) {
          print(value.id);
        }));

  }

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

  Future<void> Pdfgenerator() async {
    final pdf = pw.Document();
    // final image = pw.MemoryImage(
    //   File('/storage/emulated/0/Android/data/com.example.wellnesstracker/files/pdflogo.png').readAsBytesSync(),
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
                          //pw.Text("Age: $age"),
                        ]
                    ),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children:<pw.Widget>[
                          pw.Text("Date: ${myFormat.format(dateToday)}"),
                          pw.SizedBox(
                              height: 5
                          ),
                          //pw.Text("Gender: $gender"),
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
                      pw.Text(chd),
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
      return Scaffold(
        body: FutureBuilder(
            future: httpService.getWellness(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var wellness = snapshot.data;
                getdataperiodic(wellness);
                _timer = new Timer.periodic(Duration(seconds: 30), (timer) {
                  print("Inside Timer");
                  print("Hour: ${DateTime.now().hour} Minute: ${DateTime.now().minute}");
                  if (DateTime.now().hour == 15 && DateTime.now().minute == 48) {
                    countermail++;
                    print("CounterMail: $countermail");

                    firestoreInstance.collection("users").where("uid",isEqualTo: user.uid).where("date",isEqualTo:myFormat.format(dateToday)).get().then((QuerySnapshot querySnapshot) => {
                      querySnapshot.docs.forEach((doc) {
                        bodytemperatureavg=bodytemperatureavg+doc["bodytemperature"];
                        bloodpressureavg=bloodpressureavg+doc["bloodpressure"];
                        respirationavg=respirationavg+doc["respiration"];
                        glucoseavg=glucoseavg+doc["glucose"];
                        heartrateavg=heartrateavg+doc["heartrate"];
                        cholesterolavg=cholesterolavg+doc["cholesterol"];
                        oxygensaturationavg=oxygensaturationavg+doc["oxygensaturation"];
                        count++;

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
                        emailToast("Sending Health Report"),
                        Pdfgenerator(),
                        sendMail(),

                      },
                      {
                        firestoreInstance.collection("dailyhealthreport").add(
                            {
                              "uid": user.uid,
                              "date": myFormat.format(dateToday),
                              "bodytemperatureavg": bodytemperatureavg,
                              "bloodpressureavg": bloodpressureavg,
                              "respirationavg": respirationavg,
                              "glucoseavg":glucoseavg,
                              "heartrateavg":heartrateavg ,
                              "cholesterolavg":cholesterolavg,
                              "oxygensaturationavg": oxygensaturationavg,
                            }).then((value) {
                          print(value.id);
                        })
                      }

                    });
                    emailToast("Sending Health Report");
                    Pdfgenerator();
                    sendMail();
                    count=0;
                    if(countermail==2){ _timer.cancel();}


                  }
                });



                return Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  color: Colors.blueAccent,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.fromLTRB(5, 50, 5, 20),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'monitoring',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'ShareTechMono',
                            ),
                          ),
                          Text(
                            'Live Data',
                            style: TextStyle(
                                fontSize: 35,
                                color: Colors.black,
                                fontFamily: 'ShareTechMono',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20,),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Column(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.directions_walk, color: Colors.white,
                                  size: 33,),
                                title: const Text('Steps',
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  wellness.steps.toString(),
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                              ),
                            ]),
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Column(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.wb_sunny, color: Colors.white,
                                  size: 33,),
                                title: const Text('Body Temperature',
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  wellness.bodyTemperature.toString(),
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                              ),
                            ]),
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Column(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.directions_run, color: Colors.white,
                                  size: 33,),
                                title: const Text('Blood Pressure',
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  wellness.bloodPressure.toString(),
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                              ),
                            ]),
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Column(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.add_circle_outline, color: Colors.white,
                                  size: 33,),
                                title: const Text('Respiration',
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  wellness.respiration.toString(),
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                              ),
                            ]),
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Column(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.add_box, color: Colors.white,
                                  size: 33,),
                                title: const Text('Glucose',
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  wellness.glucose.toString(),
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                              ),
                            ]),
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Column(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.favorite, color: Colors.white,
                                  size: 33,),
                                title: const Text('Heart Rate',
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  wellness.heartRate.toString(),
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                              ),
                            ]),
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Column(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.add_to_photos, color: Colors.white,
                                  size: 33,),
                                title: const Text('Cholesterol',
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  wellness.cholesterol.toString(),
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                              ),
                            ]),
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.black54,
                            child: Column(children: [
                              ListTile(
                                leading: Icon(
                                  Icons.add_box, color: Colors.white,
                                  size: 33,),
                                title: const Text('Oxygen Saturation',
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(
                                  wellness.oxygenSaturation.toString(),
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                              ),
                            ]),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            'montoring',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'ShareTechMono',
                            ),
                          ),
                          Text(
                            'Risk Factors',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontFamily: 'ShareTechMono',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          FutureBuilder(
                              future: predictService.getPrediction(wellness.bloodPressure, wellness.cholesterol, wellness.heartRate),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  var prediction = snapshot.data;
                                  chd = prediction.chd.toString();

                                  return Card(
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.black54,
                                    child: Column(children: [
                                      ListTile(
                                        leading: Icon(
                                          Icons.warning_rounded, color: Colors.white,
                                          size: 33,),
                                        title: const Text('Coronary Heart Disease',
                                            style: TextStyle(color: Colors.white)),
                                        subtitle: Text(
                                          prediction.chd.toString(),
                                          style: TextStyle(color: Colors.white54),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                      ),
                                    ]),
                                  );
                                }
                                return Center(child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                                ));
                              }),
                          SizedBox(height: 10,),
                          Text(
                            'retrieving',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'ShareTechMono',
                            ),
                          ),
                          Text(
                            'Blockchain Data',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontFamily: 'ShareTechMono',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          FutureBuilder(
                              future: blockchainService.getBlockchain(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  var blockchain = snapshot.data;

                                  return Column(
                                    children: [
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.black54,
                                        child: Column(children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.arrow_forward_ios, color: Colors.white,
                                              size: 33,),
                                            title: const Text('Average Body Temperature',
                                                style: TextStyle(color: Colors.white)),
                                            subtitle: Text(
                                              blockchain.bodytemperature.toString(),
                                              style: TextStyle(color: Colors.white54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                          ),
                                        ]),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.black54,
                                        child: Column(children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.arrow_forward_ios, color: Colors.white,
                                              size: 33,),
                                            title: const Text('Average Blood Pressure',
                                                style: TextStyle(color: Colors.white)),
                                            subtitle: Text(
                                              blockchain.bloodpressure.toString(),
                                              style: TextStyle(color: Colors.white54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                          ),
                                        ]),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.black54,
                                        child: Column(children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.arrow_forward_ios, color: Colors.white,
                                              size: 33,),
                                            title: const Text('Average Respiration',
                                                style: TextStyle(color: Colors.white)),
                                            subtitle: Text(
                                              blockchain.respiration.toString(),
                                              style: TextStyle(color: Colors.white54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                          ),
                                        ]),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.black54,
                                        child: Column(children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.arrow_forward_ios, color: Colors.white,
                                              size: 33,),
                                            title: const Text('Average Glucose',
                                                style: TextStyle(color: Colors.white)),
                                            subtitle: Text(
                                              blockchain.glucose.toString(),
                                              style: TextStyle(color: Colors.white54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                          ),
                                        ]),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.black54,
                                        child: Column(children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.arrow_forward_ios, color: Colors.white,
                                              size: 33,),
                                            title: const Text('Average Heart Rate',
                                                style: TextStyle(color: Colors.white)),
                                            subtitle: Text(
                                              blockchain.heartrate.toString(),
                                              style: TextStyle(color: Colors.white54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                          ),
                                        ]),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.black54,
                                        child: Column(children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.arrow_forward_ios, color: Colors.white,
                                              size: 33,),
                                            title: const Text('Average Cholesterol',
                                                style: TextStyle(color: Colors.white)),
                                            subtitle: Text(
                                              blockchain.cholesterol.toString(),
                                              style: TextStyle(color: Colors.white54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                          ),
                                        ]),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.black54,
                                        child: Column(children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.arrow_forward_ios, color: Colors.white,
                                              size: 33,),
                                            title: const Text('Average Oxygen Saturation',
                                                style: TextStyle(color: Colors.white)),
                                            subtitle: Text(
                                              blockchain.oxygensaturation.toString(),
                                              style: TextStyle(color: Colors.white54),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  );
                                }
                                return Center(child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                                ));
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Center(child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ));
            }),
      );
    }
  }

