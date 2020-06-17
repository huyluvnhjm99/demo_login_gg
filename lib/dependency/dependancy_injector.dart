import 'package:demologingg/data/PersonalityTest.dart';
import 'package:demologingg/data/Question.dart';
import 'package:demologingg/data/User.dart';
import 'package:demologingg/data/repositories/personality_test.api.services.dart';
import 'package:demologingg/data/repositories/user.api.services.dart';
import 'package:demologingg/data/repositories/question.api.services.dart';

class Injector {
  static final Injector _singleton = new Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  PersonalityTestRepository get personalityTestRepository => new PersonalityTestApiRepository();
  UserRepository get userRepository => new UserApiRepository();
  QuestionRepository get questionRepository => new QuestionApiRepository();

//  PersonalityTestRepository get personalityTestRepository {
//    return new PersonalityTestApiRepository();
//  }
}