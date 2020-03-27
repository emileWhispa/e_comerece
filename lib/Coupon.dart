import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SuperBase.dart';
class TrapeziumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width * 2/3, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(TrapeziumClipper oldClipper) => false;
}
class Coupon extends StatefulWidget {
  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> with SuperBase {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Coupon"),
      ),
      body: Scrollbar(
          child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: 300,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.black54, Colors.black87],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "New registered users",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Available for over \$500",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400),
                            ),
                            Spacer(),
                            Text(
                              "Valid until during 20-02-2020 till 20-02-2021",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )),
                      Container(
                        decoration: BoxDecoration(color: color),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("\$20",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text("COUPON",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
