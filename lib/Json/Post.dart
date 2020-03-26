import 'Picture.dart';

import 'User.dart';

class Post {
  String id;
  int views;
  String caption;
  String date;
  String time;
  int comments;
  int likes;
  User user;
  bool liked;
  List<Picture> pictures;

  Post.fromJson(Map<String, dynamic> json)
      : views = int.tryParse(json['post_views']) ?? 0,
        caption = json['post_caption'] ?? "",
        date = json['post_date'],
        time = json['post_time'],
        liked = (int.tryParse(json['am_like'] ?? "") ?? 0) > 0,
        comments = int.tryParse(json['post_comments']) ?? 0,
        likes = int.tryParse(json['post_likes']) ?? 0,
        pictures = _list(json['images']),
        user = User.fromJson(json),
        id = json['post_id'];

  static List<Picture> _list(json) {
    Iterable map = json;
    return map != null ? map.map((f) => Picture.fromJson(f)).toList() : [];
  }

  Map<String, dynamic> toJson() {
    var dt = data();
    if (user != null) dt.addAll(user.toJson());
    return dt;
  }

  Map<String, dynamic> data() => {
        'post_id': id,
        'post_views': '$views',
        'post_caption': caption,
        'post_comments': '$comments',
        'post_likes': '$likes',
        'am_like': liked ? '1' : '0',
        'images': pictures,
      };

  String get image => pictures.isNotEmpty ? pictures.first.thumb : "";

  String get bigImage => pictures.isNotEmpty ? pictures.first.image : "";
}
