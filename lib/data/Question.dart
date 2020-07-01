import 'package:demologingg/data/Answer.dart';

class Question {
  int _id;
  String _question_content;
  int _test_id;
  List<Answer> _list_answers;
  bool _isChosen;
  bool _isChosen2;

  Question(this._question_content, this._test_id);

  Question.withId(this._id, this._question_content, this._test_id);

  int get id => _id;
  String get question_content => _question_content;
  int get test_id => _test_id;
  List<Answer> get list_answers => _list_answers;
  bool get isChosen => _isChosen;
  bool get isChosen2 => _isChosen2;


  set question_content(String question_content) {
    _question_content = question_content;
  }

  set test_id(int test_id) {
    _test_id = test_id;
  }

  set list_answers(List<Answer> list_answers) {
    _list_answers = list_answers;
  }

  set isChosen(bool isChosen) {
    _isChosen = isChosen;
  }

  set isChosen2(bool isChosen2) {
    _isChosen2 = isChosen2;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = _id;
    }
    map["question_content"] = _question_content;
    map["test_id"] = _test_id;

    return map;
  }

  Question.fromObject(dynamic o) {
    this._id = o["id"];
    this._question_content = o["question_content"];
    this._test_id = o["test_id"];
    this.isChosen = false;
    this.isChosen2 = false;
  }
}

abstract class QuestionRepository {
  Future fectQuestion();
  Future findQuestionsByTestId(int test_id, bool isSort);
}
