import 'dart:convert' as convert;
import 'package:demologingg/models/PersonalityTest.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:demologingg/api/api_url.dart';

class PersonalityTestApiRepository implements PersonalityTestRepository {

  @override
  Future fectPersonalityTest() async {
    return await http.get(ApiUrl.personalityTest_url);
  }

//  static Future fectPersonalityTest() async {
//    return await http.get(personalityTestUrl);
//  }

}
