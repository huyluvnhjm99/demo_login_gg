import 'package:demologingg/data/Question.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:demologingg/urls/api_url.dart';

class TokenApiRepository {

  Future fectToken(String username) async {
    return await http.post(ApiUrl.TOKEN_URL, body: {
      'grant_type':'password',
      'username': username
    });
  }
}
