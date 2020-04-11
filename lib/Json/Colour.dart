class Colour {
  int id;
  String name;
  String code;

  bool selected = false;

  Colour.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['color'],
        code = json['colorCode'];
}
