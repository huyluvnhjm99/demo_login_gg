import 'dart:async';
import 'package:demologingg/data/Answer.dart';
import 'package:demologingg/data/Personality.dart';
import 'package:demologingg/data/Result.dart';
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

abstract class PersonalityView {
  void onSuccess(List<Personality> perList);
  void _calculateResult();
}

abstract class ResultView {
  void onSuccesss(List<Result> resultList);
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

class PersonalityPresenter {
  PersonalityView _view;
  PersonalityRepository _personalityRepo;

  PersonalityPresenter(this._view) {
    _personalityRepo = new Injector().personalityRepository;
  }

  void loadPersonality() {
    _personalityRepo.fectPersonality().then((response) {
      Iterable list = json.decode(response.body);
      List<Personality> perList = new List<Personality>();
      perList = list.map((model) => Personality.fromObject(model)).toList();
      _view.onSuccess(perList);
    });
  }
}

class ResultPresenter {
  ResultView _view;
  List<Result> resultList;
  ResultRepository _resultRepo;

  ResultPresenter(this._view) {
    _resultRepo = new Injector().resultRepository;
  }

  void postResult(Result result, String token) {
    _resultRepo.postResult(result, token);
  }

  void loadResultList(String gmail) {
    _resultRepo.fectResult(gmail).then((response) {
      Iterable list = json.decode(response.body);
      resultList = new List<Result>();
      resultList = list.map((model) => Result.fromObject(model)).toList();
    }).then((data) {
      Timer timer = new Timer(const Duration(seconds: 10), () async {
        await _view.onSuccesss(resultList);
      });
    });
  }
}

class QuestionPresenter {
  QuestionListView _view;
  QuestionRepository _questRepo;
  AnswerRepository _answerRepo;
  List<Question> questionList;
  List<Answer> answerList;

  QuestionPresenter(this._view) {
    _questRepo = new Injector().questionRepository;
    _answerRepo = new Injector().answerRepository;
  }

  void loadQuestionList(int test_id) {
    _questRepo.findQuestionsByTestId(test_id, false).then((response) {
      Iterable list = json.decode(response.body);
      questionList = new List<Question>();
      questionList = list.map((model) => Question.fromObject(model)).toList();
      answerList = new List<Answer>();
    }).whenComplete(() {
      questionList.forEach((quest)  {
        _answerRepo.findAnswersByQuestionId(quest.id, false).then((response) async {
          Iterable list = json.decode(response.body);
          answerList = list.map((model) => Answer.fromObject(model)).toList();
          quest.list_answers = answerList;
        });
      });
    }).then((data) {
       Timer timer = new Timer(const Duration(seconds:10),() async {
         await _view.onSuccess(questionList);
      });
    });
  }

  void loadAnswerForQuestion(List<Question> questionList) async {
     List<Answer> answerList = new List<Answer>();

     questionList.forEach((quest) {
      _answerRepo.findAnswersByQuestionId(quest.id, false).then((response) {
        Iterable list = json.decode(response.body);
        answerList = list.map((model) => Answer.fromObject(model)).toList();
      }).whenComplete(() => quest.list_answers = answerList);
    });
  }
}

