import 'package:demologingg/data/Question.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:demologingg/urls/api_url.dart';

class QuestionApiRepository implements QuestionRepository {

  Map<String, String> header = {
    'Content-type':'application/json',
    'Accept':'application/json'
  };

  @override
  Future fectQuestion() async {
    return await http.get(ApiUrl.QUESTION_URL);
  }

  @override
  Future findQuestionsByTestId(int test_id) async {
    return await http.get(ApiUrl.QUESTION_FINDBYTESTID_URL + test_id.toString());
  }
}
