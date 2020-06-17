import 'dart:convert' as convert;
import 'package:demologingg/data/User.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:demologingg/urls/api_url.dart';

class UserApiRepository implements UserRepository {

  Map<String, String> header = {
    'Content-type':'application/json',
    'Accept':'application/json',
  };

  @override
  Future<bool> postUser(User user) async {
    var myUser = user.toMap();
    var userBody = convert.json.encode(myUser);
    var res = await http.post(ApiUrl.USER_URL,headers: header, body: userBody);
    return Future.value(res.statusCode == 200 ? true : false);
  }

  @override
  Future fectUser() {
    // TODO: implement fectUser
    throw UnimplementedError();
  }

  @override
  Future findUserByGmail(String gmail) async {
    return await http.get(ApiUrl.USER_FINDBYGMAIL_URL + gmail);
  }
}
