import 'package:demologingg/data/Answer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:demologingg/urls/api_url.dart';

class AnswerApiRepository implements AnswerRepository {

  Map<String, String> header = {
    'Content-type':'application/json',
    'Accept':'application/json'
  };

  @override
  Future fectAnswer() async {
    return await http.get(ApiUrl.ANSWER_URL);
  }

  @override
  Future findAnswersByQuestionId(int question_id, bool isSort) async {
    return await http.get(ApiUrl.ANSWER_FINDBYQUESTIONID_URL + question_id.toString() + ApiUrl.SORT + isSort.toString());
  }
}
