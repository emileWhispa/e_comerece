import 'package:intl/intl.dart';

import 'User.dart';

class Cart {
  int id;
  int size;
  double price;
  User user;
  String date;
  int status;
  String hash;
  DateTime _time;

  Cart.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = json['date'],
        hash = json['hash'],
        price = json['cartPrice'],
        user = User.fromJson(json['user']),
        status = json['status'],
  _time = DateTime.tryParse(json['date']),
        size = json['cartSize'];

  var format = DateFormat("dd MMM yyyy, EEE");

  String get time=>_time == null ? "-----" : format.format(_time);
}
