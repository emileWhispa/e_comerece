import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'item.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Item> _list = <Item>[
    Item(48.6, "JAY ROX ORIGINAL CASUAL SHOES",
        "https://cdn.shopify.com/s/files/1/0298/8149/9785/products/1231_1_03de5b61-bde3-4098-8260-763b0af0cf67_1024x1024.jpg?v=1578658312"),
    Item(16.9, "PARTY DRESS",
        "https://static.stelly.com.au/img/p/1/9/1/5/0/1/191501-large_default.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          elevation: 2.0,
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: (){})
          ],
        ),
        backgroundColor: Colors.black12,
        body: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                var _item = _list[index];
                return Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3)),
                  child: Row(
                    children: <Widget>[
                      CachedNetworkImage(
                        height: 90,
                        width: 90,
                        imageUrl: _item.url,
                        fit: BoxFit.cover,
                        placeholder: (context, str) => Container(
                          height: 90,
                          width: 90,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: 90,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              _item.title,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            )),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Color(0xffffe707),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    '\$${_item.price}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(child: SizedBox.shrink()),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CupertinoButton(
                                      child:
                                          new Icon(Icons.remove_circle_outline),
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () => setState(() {}),
                                    ),
                                    Text(
                                      '1',
                                      textAlign: TextAlign.center,
                                    ),
                                    CupertinoButton(
                                      child: new Icon(Icons.add_circle_outline),
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {},
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              },
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    "Sub total: \$65",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: SizedBox.shrink()),
                  RaisedButton(
                    color: Color(0xffffe707),
                      child: Text("Complete Order"),
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      onPressed: () {})
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }
}


