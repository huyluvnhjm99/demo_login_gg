import 'dart:convert';

import 'package:demologingg/data/Result.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:demologingg/urls/api_url.dart';

class ResultApiRepository implements ResultRepository {

  Future fectToken(String username) async {
    return await http.post(ApiUrl.TOKEN_URL, body: {
      'grant_type':'password',
      'username': username
    });
  }

  @override
  Future fectResult(String gmail) async {
    return await http.get(ApiUrl.TESTRESULT_URL);
  }

  @override
  Future postResult(Result result, String token) async {
    Map<String,String> headers = {'Content-Type':'application/json','authorization':'Bearer ' + token};
    final msg = jsonEncode({"date_create":result.date_create.toString(),"test_name":result.test_name,"personality":result.personality,"gmail":result.gmail});
    return await http.post(ApiUrl.TESTRESULT_URL, headers: headers, body: msg);
  }
}
