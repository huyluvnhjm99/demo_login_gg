import 'package:demologingg/data/PersonalityTest.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:demologingg/urls/api_url.dart';

class PersonalityTestApiRepository implements PersonalityTestRepository {

  @override
  Future fectPersonalityTest() async {
    return await http.get(ApiUrl.PERSONALITYTEST_URL);
  }

  Map<String, String> header = {
    'Content-type':'application/json',
    'Accept':'application/json'
  };
}
