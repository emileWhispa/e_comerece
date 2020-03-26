

class User {
  String id;
  String _username;
  String first;
  String email;
  String last;
  String phone;
  String party;
  String thumbnail;
  String code;
  String userStatus;
  String userRole;
  String userLevel;
  int language = 0;

  User(this.id, this.first, this.last, this._username, this.phone, this.code,
      this.userStatus, this.party, this.userRole);

  User.fromJson(Map<String, dynamic> json)
      : _username = json['user_username'],
        first = json['user_fname'],
        last = json['user_lname'],
        email = json['user_email'],
        phone = json['user_phone'],
        thumbnail = json['user_thumbnail'],
        party = json['party_id'] ?? "9",
        code = json['verification_code'],
        userStatus = json['user_status'],
        userLevel = json['user_level'],
        language = json['language'] ?? 0,
        userRole = json['user_role'],
        id = json['user_id'];

  String display() => first ?? "" + " " + last ?? "";

  String get username => _username == null ? "Profile names" : _username;

  String singleChar() => username.substring(0, 1).toUpperCase();


  bool notAble() =>
      this.userRole.toLowerCase() == 'volunteer' ||
      this.userRole.toLowerCase() == 'member';

  Map<String, dynamic> toJson(){
    var v = vJson();
    return v;
  }

  Map<String, dynamic> vJson() => {
        'user_username': username,
        'user_phone': phone,
        'verification_code': code,
        'user_email': email,
        'user_lname': last,
        'user_thumbnail': thumbnail,
        'user_fname': first,
        'party_id': party,
        'user_level': userLevel,
        'language': language,
        'user_role': userRole,
        'user_status': userStatus,
        'user_id': id,
      };
}
