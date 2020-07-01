class Personality {
  int _id;
  String _type;
  String _description;

  Personality(this._type, this._description);

  int get id => _id;
  String get type => _type;
  String get description => _description;

  set type(String type) {
    _type = type;
  }

  set description(String description) {
    _description = description;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = _id;
    }
    map["type"] = _type;
    map["description"] = _description;

    return map;
  }

  Personality.fromObject(dynamic o) {
    this._id = o["id"];
    this._description = o["description"];
    this._type = o["type"];
  }
}

abstract class PersonalityRepository {
  Future fectPersonality();
  Future fectPersonalityById(int id);
}
