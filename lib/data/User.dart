class User {
  int _id;
  String _gmail;
  String _name;
  String _token;
  String _role;

  User(this._gmail, this._name, this._token, this._role);

  User.withId(this._id, this._gmail, this._name, this._token, this._role);

  int get id => _id;

  String get gmail => _gmail;

  String get name => _name;

  String get token => _token;

  String get role => _role;

  set gmail(String gmail) {
    _gmail = gmail;
  }

  set name(String name) {
    _name = name;
  }

  set token(String token) {
    _token = token;
  }

  set role(String role) {
    _role = role;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = _id;
    }
    map["gmail"] = _gmail;
    map["name"] = _name;
    map["token"] = _token;
    map["role"] = _role;

    return map;
  }

  User.fromObject(dynamic o) {
    this._id = o["id"];
    this._gmail = o["gmail"];
    this._name = o["name"];
    this._token = o["token"];
    this._role = o["role"];
  }
}

  abstract class UserRepository {
    Future fectUser();
    Future<bool> postUser(User user);
    Future findUserByGmail(String gmail);
  }
