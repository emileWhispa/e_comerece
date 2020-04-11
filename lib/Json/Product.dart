import 'package:sqflite/sqflite.dart';

import 'Colour.dart';
import 'Review.dart';
import 'Sku.dart';

class Product {
  int id;
  String name;
  String url;
  double price;
  int count = 0;
  int items = 0;
  String _size;
  String _color;
  bool selected = false;
  List<String> _images;
  List<Review> _reviews;
  List<Sku> _skus;
  List<Colour> _colors;

  Product(this.name, this.price, this.url,this.items);

  Product.fromJson(Map<String, dynamic> json, {int items: 0,String color,String size})
      : id = json['id'],
        name = json['name'],
        count = json['quantity'],
        items = items,
        _size = size ?? json['size'],
        _color = color ?? json['color'],
        _images = getImages(json),
        _reviews = getReviews(json),
        _skus = getSku(json),
        _colors = getColors(json),
        price = json['price'],
        url = json['url'];

  static List<String> getImages(Map<String, dynamic> json) {
    Iterable _map = json['imageList'];
    if (_map != null) {
      return _map.map((f) => '${f['url']}').toList();
    }
    return null;
  }

  static List<Review> getReviews(Map<String, dynamic> json) {
    Iterable _map = json['reviewList'];
    if (_map != null) {
      return _map.map((f) => Review.fromJson(f)).toList();
    }
    return null;
  }

  static List<Sku> getSku(Map<String, dynamic> json) {
    Iterable _map = json['skuList'];
    if (_map != null) {
      return _map.map((f) => Sku.fromJson(f)).toList();
    }
    return null;
  }

  static List<Colour> getColors(Map<String, dynamic> json) {
    Iterable _map = json['colorList'];
    if (_map != null) {
      return _map.map((f) => Colour.fromJson(f)).toList();
    }
    return null;
  }

  List<String> get images => _images ?? [];

  List<Review> get reviews => _reviews ?? [];

  List<Sku> get sku => _skus ?? [];

  List<Colour> get colors => _colors ?? [];

  List<Review> get subReviews =>
      reviews.sublist(0, reviews.length > 5 ? 5 : reviews.length);

  Product.fromDb(Map<String, dynamic> json)
      : name = json['title'],
        id = json['id'],
        count = json['count'],
        items = json['items'],
        _size = json['size'],
        _color = json['color'],
        price = json['price'],
        url = json['url'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "price": price,
        "size": _size,
        "color": _color
      };

  double get total => items * price;

  // A method that retrieves all the dogs from the dogs table.
  static Future<List<Product>> itemList(Database db,
      {int limit: 50, int offset: 1, String append: "", String search}) async {
    // Get a reference to the database.\
    if (db == null || !db.isOpen) return [];

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = (await db.query('cart',
            limit: limit,
            offset: limit == null ? null : (offset - 1) * limit,
            orderBy: "id desc"))
        .toList();

    return maps.map((map) => Product.fromDb(map)).toList();
  }

  void inc() {
    if (items < count) {
      items++;
    }
  }

  void dec() {
    if (items > 1) {
      items--;
    }
  }

  set color(String color) {
    this._color = color;
  }

  String get color => _color;

  String get size => _size;

  set size(String size) {
    this._size = size;
  }

  // A method that retrieves all the dogs from the dogs table.
  static Future<Product> byId(Database db, String id,
      {int limit: 1, int offset: 0}) async {
    // Get a reference to the database.
    if (db == null || !db.isOpen) return null;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('cart',
        where: "id = ? ",
        limit: limit,
        whereArgs: [id],
        orderBy: "id desc",
        offset: offset);
    return maps.isNotEmpty ? Product.fromDb(maps[0]) : null;
  }

  Future<void> updateItem(Database db) async {
    // Get a reference to the database.

    if (db == null || !db.isOpen) return;

    // Remove the Dog from the Database
    await db.update(
      "cart", this.toMap(),
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteItem(Database db) async {
    // Get a reference to the database.

    if (db == null || !db.isOpen) return;

    // Remove the Dog from the Database.
    await db.delete(
      'cart',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> insertItem(Database db) async {
    // Get a reference to the database.
    if (db == null || !db.isOpen) return;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    id = await db.insert(
      "cart",
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, dynamic> toMap() => {
        "items": items,
        "title": name,
        "id": id,
        "size": _size,
        "color": _color,
        "count": count,
        "price": price,
        "url": url
      };
}
