class Sku {
  int id;
  String name;
  String description;

  Sku.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'];
}
