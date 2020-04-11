

class User {
  int id;
  String _username;
  String firebase;
  String email;
  String gender;
  String country;
  String birthDay;
  String phone;

  User(this.id, this.firebase, this.birthDay, this._username, this.phone);

  User.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        firebase = json['firebase'],
        birthDay = json['birthDate'],
        gender = json['gender'],
        country = json['country'],
        email = json['email'],
        phone = json['mobile'],
        id = json['id'];

  String display() => username;

  String get username => _username ?? "Profile names";

  String singleChar() => username.substring(0, 1).toUpperCase();



  Map<String, dynamic> toJson(){
    var v = vJson();
    return v;
  }

  Map<String, dynamic> vJson() => {
        'username': username,
        'mobile': phone,
        'birthDate': birthDay,
        'email': email,
        'country': country,
        'gender': gender,
        'id': id,
      };
}
