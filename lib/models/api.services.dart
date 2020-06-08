import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class APIServices {
  static final String personalityTestUrl = 'http://192.168.1.9:5055/api/Personalitytest';

  static Future fectPersonalityTest() async {
    return await http.get(personalityTestUrl);
  }


}