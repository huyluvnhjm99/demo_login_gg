import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class APIServices {
  static final String personalityUrl = 'http://192.168.1.5:5005/api/Personalitytest';

  static Future fectPersonalityTest() async {
    return await http.get(personalityUrl);
  }


}