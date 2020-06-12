import 'package:demologingg/dependency/dependancy_injector.dart';
import 'package:demologingg/models/PersonalityTest.dart';

abstract class PersonalityTestListViewContract {
  void onSuccess(List<PersonalityTest> items);
}

class PersonalityTestPresenter {
  PersonalityTestListViewContract _view;
  PersonalityTestRepository _repository;

  PersonalityTestPresenter(this._view) {
    _repository = new Injector().personalityTestRepository;
  }

  void loadPersonalityTest() {
    _repository.fectPersonalityTest().then((data) => _view.onSuccess(data));
  }
}
