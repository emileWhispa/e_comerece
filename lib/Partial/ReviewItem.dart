import 'package:e_comerece/Json/Review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ReviewItem extends StatefulWidget{
  final Review review;

  const ReviewItem({Key key,@required this.review}) : super(key: key);
  @override
  _ReviewItemState createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(padding: EdgeInsets.only(bottom: 30),child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          radius: 18,
        ),
        Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${widget.review.reviewBy}",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "${widget.review.date}",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 15),
                  Text(
                      "${widget.review.review}"),
                  SizedBox(height: 15),
                  Row(
                    children: List.generate(
                        8,
                            (index) => index == 5
                            ? Spacer()
                            : index == 6
                            ? Icon(
                          Fontisto.heart_alt,
                          size: 15,
                        )
                            : index == 7
                            ? Padding(
                          padding: EdgeInsets.only(
                              left: 5),
                          child: Text("13",
                              style: TextStyle(
                                  fontSize: 17,
                                  color:
                                  Colors.grey)),
                        )
                            : Padding(
                          padding: EdgeInsets.only(
                              right: 7),
                          child: Icon(
                            index > 2
                                ? Icons.star_border
                                : Icons.star,
                            color: index > 2
                                ? Colors.grey
                                : Color(0xffFEE606),
                          ),
                        )).toList(),
                  )
                ],
              ),
            ))
      ],
    ),);
  }
}