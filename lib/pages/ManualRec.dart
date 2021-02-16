import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'NavHome.dart';

class ManualRec extends StatefulWidget {
  @override
  _ManualRecState createState() => _ManualRecState();
}

class _ManualRecState extends State<ManualRec> {

  double _tbodytemperature;
  int _tbloodpressure;
  int _trespiration;
  int _tglucose ;
  int _theartrate ;
  int _tcholesterol ;
  int _toxygensaturation ;

  bool normal = true;
  bool acuteasthma = false;
  bool hypoxemia=false;
  bool chd=false;
  bool bronchiectasis=false;
  bool prediabetes=false;
  bool diabetes=false;

  FToast fToast;

  TextEditingController _bodytemperature;
  TextEditingController _bloodpressure;
  TextEditingController _respiration;
  TextEditingController _glucose;
  TextEditingController _heartrate;
  TextEditingController _cholesterol;
  TextEditingController _oxygensaturation;

  @override
  initState(){
    _bodytemperature = new TextEditingController();
    _bloodpressure = new TextEditingController();
    _respiration = new TextEditingController();
    _glucose = new TextEditingController();
    _heartrate = new TextEditingController();
    _cholesterol = new TextEditingController();
    _oxygensaturation = new TextEditingController();
    super.initState();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }







  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black26,
      child:  SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child:  Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(30, 50, 30, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'assessing',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'ShareTechMono',
                ),
              ),
              Text(
                'Manual Data',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontFamily: 'ShareTechMono',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              Text(
                "Body Temperature", style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: new InputDecoration(
                  hintText: "Enter body temperature",
                ),
                controller: _bodytemperature,
              ),
              SizedBox(height: 10,),
              Text(
                  "Blood Pressure", style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: new InputDecoration(
                  hintText: "Enter blood pressure value",
                ),
                controller: _bloodpressure,
              ),
              SizedBox(height: 10,),
              Text(
                  "Respiration", style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: new InputDecoration(
                  hintText: "Enter respiration value",
                ),
                controller: _respiration,
              ),
              SizedBox(height: 10,),
              Text(
                  "Glucose", style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: new InputDecoration(
                  hintText: "Enter glucose value",
                ),
                controller: _glucose,
              ),
              SizedBox(height: 10,),
              Text(
                  "Heart Rate", style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: new InputDecoration(
                  hintText: "Enter heart rate",
                ),
                controller: _heartrate,
              ),
              SizedBox(height: 10,),
              Text(
                  "Cholesterol", style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: new InputDecoration(
                  hintText: "Enter cholesterol value",
                ),
                controller: _cholesterol,
              ),
              SizedBox(height: 10,),
              Text(
                  "Oxygen Saturation", style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: new InputDecoration(
                  hintText: "Enter oxygen saturation value",
                ),
                controller: _oxygensaturation,
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.black,
                    child: new Text("Assess",style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'ShareTechMono')),
                    onPressed: (){
                      setState((){
                        this._tbodytemperature = double.parse(_bodytemperature.text);
                        this._tbloodpressure = int.parse(_bloodpressure.text);
                        this._trespiration = int.parse(_respiration.text);
                        this._tglucose = int.parse(_glucose.text);
                        this._theartrate = int.parse(_heartrate.text);
                        this._tcholesterol = int.parse(_cholesterol.text);
                        this._toxygensaturation = int.parse(_oxygensaturation.text);
                      });
                      if(_trespiration>=20 && _trespiration<=30 && _toxygensaturation>=92 && _toxygensaturation<=95)
                        {
                          acuteasthma =true;
                          normal=false;
                        }
                      if(_toxygensaturation>=50 && _toxygensaturation<=91)
                      {
                        hypoxemia =true;
                        normal=false;
                      }
                      if(_theartrate>=45 && _theartrate<=60 && _tcholesterol>=200 && _tcholesterol<=270)
                      {
                        chd =true;
                        normal=false;
                      }
                      if(_trespiration>=40 && _trespiration<=60)
                      {
                        bronchiectasis =true;
                        normal=false;
                      }
                      if(_tglucose>=140 && _tglucose<=199)
                      {
                        prediabetes =true;
                        normal=false;
                      }
                      if(_tglucose>=200){
                        diabetes =true;
                        normal=false;
                    };
                      showDialog(
                          child:Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.75,
                                height:200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Color.fromRGBO(48, 25, 52, 1)
                                ),
                                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    if(normal)...[
                                      Text("The person is",style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: 'ShareTechMono')),
                                      Text("NORMAL",style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.lightGreen,
                                          fontFamily: 'ShareTechMono'))],
                                    if(normal==false)
                                      Text("The person is diagnosed with",style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: 'ShareTechMono')),
                                    SizedBox(height: 20,),
                                    if(acuteasthma)
                                      Text("ACUTE ASTHMA",style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                          fontFamily: 'ShareTechMono')),
                                    if(hypoxemia)
                                      Text("HYPOXEMIA",style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                          fontFamily: 'ShareTechMono')),
                                    if(chd)
                                      Text("CONGENITAL HEART DEFECT",style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                          fontFamily: 'ShareTechMono')),
                                    if(bronchiectasis)
                                      Text("BRONCHIECTASIS",style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                          fontFamily: 'ShareTechMono')),
                                    if(prediabetes)
                                      Text("PREDIABETES",style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                          fontFamily: 'ShareTechMono')),
                                    if(diabetes)
                                      Text("DIABETES",style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                          fontFamily: 'ShareTechMono')),
                                  ],
                                ),
                              ),
                            ),
                          ),context: context);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}