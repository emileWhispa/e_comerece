import 'package:e_comerece/Partial/ReviewItem.dart';
import 'package:flutter/material.dart';

import 'Json/Review.dart';

class ReviewScreen extends StatefulWidget {
  final List<Review> list;

  const ReviewScreen({Key key, @required this.list}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
      ),
      body: Scrollbar(
          child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                return ReviewItem(review: widget.list[index]);
              })),
    );
  }
}
