import 'package:demologingg/data/Personality.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:demologingg/urls/api_url.dart';

class PersonalityApiRepository implements PersonalityRepository {

  Map<String, String> header = {
    'Content-type':'application/json',
    'Accept':'application/json'
  };

  @override
  Future fectPersonality() async {
    return await http.get(ApiUrl.PERSONALITY_URL);
  }

  @override
  Future fectPersonalityById(int id) async {
    return await http.get(ApiUrl.PERSONALITY_FINDBYID_URL + id.toString());
  }
}
