
class Product {
  int id;
  String name;
  String url;
  double price;

  Product(this.name,this.price,this.url);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'],
        url = json['url'];

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "url": url, "price": price};
}
