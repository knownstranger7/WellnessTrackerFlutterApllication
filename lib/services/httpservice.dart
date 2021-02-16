import 'dart:convert';

import 'package:wellnesstracker/models/med_data.dart';
import 'package:http/http.dart';
import 'package:wellnesstracker/models/mockapi.dart';

class HttpService {
  final String wellnessUrl = "https://welness-tracker.herokuapp.com/medidata/N";

  Future getWellness() async{
      final Response response = await get(wellnessUrl);
      var data = jsonDecode(response.body);

     print("API Called!!");
     print(DateTime.now().toString());



      // List<WellnessTracker> wellness = body.map((dynamic item) => WellnessTracker.fromJson(item)).toList();
      return WellnessTracker.fromJson(data);



  }
}
