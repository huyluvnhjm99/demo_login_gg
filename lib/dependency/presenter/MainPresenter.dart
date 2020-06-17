import 'package:demologingg/dependency/dependancy_injector.dart';
import 'package:demologingg/data/PersonalityTest.dart';
import 'package:demologingg/data/Question.dart';
import 'dart:convert';

abstract class PersonalityTestListViewContract {
  void onSuccess(List<PersonalityTest> perTestList);
}

abstract class QuestionListView {
  void onSuccess(List<Question> questionList);
}

class PersonalityTestPresenter {
  PersonalityTestListViewContract _view;
  PersonalityTestRepository _repository;

  PersonalityTestPresenter(this._view) {
    _repository = new Injector().personalityTestRepository;
  }

  void loadPersonalityTest() {
    _repository.fectPersonalityTest().then((response) {
      Iterable list = json.decode(response.body);
      List<PersonalityTest> perTestList = new List<PersonalityTest>();
      perTestList = list.map((model) => PersonalityTest.fromObject(model)).toList();
      _view.onSuccess(perTestList);
    });
  }
}

class QuestionPresenter {
  QuestionListView _view;
  QuestionRepository _repository;

  QuestionPresenter(this._view) {
    _repository = new Injector().questionRepository;
  }

  void loadQuestionList(int test_id) {
    _repository.findQuestionsByTestId(test_id).then((response) {
      Iterable list = json.decode(response.body);
      List<Question> questionList = new List<Question>();
      questionList = list.map((model) => Question.fromObject(model)).toList();
      _view.onSuccess(questionList);
    });
  }
}
