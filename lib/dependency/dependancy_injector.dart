import 'package:demologingg/models/PersonalityTest.dart';
import 'package:demologingg/models/api.services.dart';

class Injector {
  static final Injector _singleton = new Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  PersonalityTestRepository get personalityTestRepository => new PersonalityTestApiRepository();
}