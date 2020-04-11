class Review {
  int id;
  String review;
  String reviewBy;
  String date;

  Review.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        review = json['review'],
        date = json['date'],
        reviewBy = json['reviewedBy'];
}
