import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class APIServices {
  static final String personalityTestUrl = 'https://pto.azurewebsites.net/api/v1/Personalitytest';

  static Future fectPersonalityTest() async {
    return await http.get(personalityTestUrl);
  }


}