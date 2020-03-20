class Category {
  int id;
  String name;
  String url;

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'];

  Map<String, dynamic> toJson() => {"id": id, "name": name, "url": url};
}
