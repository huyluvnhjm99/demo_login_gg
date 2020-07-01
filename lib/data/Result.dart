class Result {
  int _id;
  DateTime _date_create;
  String _gmail;
  String _test_name;
  String _personality;

  Result(this._gmail, this._test_name, this._personality);

  int get id => _id;

  DateTime get date_create => _date_create;

  String get gmail => _gmail;

  String get test_name => _test_name;

  String get personality => _personality;

  set date_create(DateTime date_create) {
    _date_create = date_create;
  }

  set gmail(String gmail) {
    _gmail = gmail;
  }

  set test_name(String test_name) {
    _test_name = test_name;
  }

  set personality(String personality) {
    _personality = personality;
  }


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = _id;
    }
    map["date_create"] = _date_create;
    map["gmail"] = _gmail;
    map["test_name"] = _test_name;
    map["personality"] = _personality;

    return map;
  }

  Result.fromObject(dynamic o) {
    this._id = o["id"];
    this._date_create = o["date_create"];
    this._test_name = o["test_name"];
    this._gmail = o["gmail"];
    this._personality = o["personality"];
  }
}

abstract class ResultRepository {
  Future fectResult(String gmail);
  Future postResult(Result result, String token);
}
