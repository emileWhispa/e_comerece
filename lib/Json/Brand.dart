class Brand {
  int id;
  String name;
  String url;

  Brand(this.name,this.url);

  Brand.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'];

  Map<String, dynamic> toJson() => {"id": id, "name": name, "url": url};
}
