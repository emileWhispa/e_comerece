class SubCategory {
  int id;
  String name;
  String url;

  SubCategory(this.id,this.name,this.url);

  SubCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'];

  Map<String, dynamic> toJson() => {"id": id, "name": name, "url": url};
}
