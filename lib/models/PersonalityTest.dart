class PersonalityTest {
  int _id;
  String _type;
  String _description;
  String _image;

  PersonalityTest(this._description, this._type);
  PersonalityTest.withId(this._id, this._description, this._type);

  int get id => _id;
  String get type => _type;
  String get description => _description;
  String get image => _image;

  set type(String type) {
    _type = type;
  }

  set description(String description) {
    _description = description;
  }

  set image(String image) {
    _image = image;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["type"] = _type;
    map["description"] = _description;
    map["image"] = _image;

    if(id != null) {
      map["id"] = _id;
    }

    return map;
  }

  PersonalityTest.fromObject(dynamic o) {
    this._id = o["id"];
    this._type = o["type"];
    this._description = o["description"];
    this._image = o["image"];
  }
}