import 'dart:convert';

import 'package:wellnesstracker/models/blockchainapi.dart';
import 'package:wellnesstracker/models/med_data.dart';
import 'package:wellnesstracker/models/predictapi.dart';
import 'package:http/http.dart';
import 'package:wellnesstracker/models/mockapi.dart';

class HttpService {
  final String wellnessUrl = "https://welness-tracker.herokuapp.com/medidata/N";

  Future getWellness() async{
      final Response response = await get(wellnessUrl);
      var data = jsonDecode(response.body);
     print("Random value API Called!!");
     print(DateTime.now().toString());
      return WellnessTracker.fromJson(data);
  }
}

class PredictService {
  final String predictUrl = "https://welness-tracker.herokuapp.com/chdprediction";

  Future getPrediction(int bp,int chol,int heartrate) async{
    final Response response = await get('$predictUrl?bp=$bp&chol=$chol&heartrate=$heartrate');
    var data = jsonDecode(response.body);

    print("Predict API Called!!");
    print(DateTime.now().toString());
    return WellnessPrediction.fromJson(data);
  }
}

class BlockchainService {
  final String blockchainUrl = "http://192.168.1.6:5000/wtb/view";

  Future getBlockchain() async{
    final Response response = await get(blockchainUrl);
    var data = jsonDecode(response.body);
    print("Blockchain API Called!!");
    print(data['data']['bodytemperature']);
    print(DateTime.now().toString());
    return Data.fromJson(data['data']);

  }
}
