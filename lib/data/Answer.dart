class Answer {
  int _id;
  String _answer_content;
  int _question_id;
  int _personality_id;
  bool _isChosen;

  Answer(this._answer_content, this._question_id, this._personality_id);

  Answer.withId(this._id, this._answer_content, this._question_id, this._personality_id);

  int get id => _id;
  String get answer_content => _answer_content;
  int get question_id => _question_id;
  int get personality_id => _personality_id;
  bool get isChosen => _isChosen;

  set answer_content(String answer_content) {
    _answer_content = answer_content;
  }

  set question_id(int question_id) {
    _question_id = question_id;
  }

  set personality_id(int personality_id) {
    _personality_id = personality_id;
  }

  set isChosen(bool isChosen) {
    _isChosen = isChosen;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = _id;
    }
    map["answer_content"] = _answer_content;
    map["question_id"] = _question_id;
    map["personality_id"] = _personality_id;

    return map;
  }

  Answer.fromObject(dynamic o) {
    this._id = o["id"];
    this._answer_content = o["answer_content"];
    this._question_id = o["question_id"];
    this._personality_id = o["personality_id"];
    this._isChosen = false;
  }
}

abstract class AnswerRepository {
  Future fectAnswer();
  Future findAnswersByQuestionId(int question_id, bool isSort);
}
