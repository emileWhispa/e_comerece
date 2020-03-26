
class Picture {
  String id;
  String image;
  String thumb;

  Picture.fromJson(Map<String, dynamic> json)
      : image = json['image_address'],
        id = json['image_id'],
        thumb = json['thumb_address'];



  Map<String, dynamic> toJson() => {
    'thumb_address': thumb,
    'image_address': image,
    'image_id': id,
  };

}
