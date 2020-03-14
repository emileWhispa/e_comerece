import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comerece/Partial/TouchableOpacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'item.dart';

class Description extends StatefulWidget {
  final Item item;

  const Description({Key key, @required this.item}) : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffd3d3d4),
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.item.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView(
            children: <Widget>[
              CachedNetworkImage(
                  height: 300,
                  width: double.infinity,
                  imageUrl: widget.item.url,
                  fit: BoxFit.cover),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Color(0xffefeff1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        '\$${widget.item.price}',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        '${widget.item.title}',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        '8 orders',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Color(0xffefeff1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Store coupons",
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "11,500 Rwf off",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Color(0xffefeff1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Free shipping",
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Estimated arrival: 04th july 2020")
                  ],
                ),
              )
            ],
          )),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    children: <Widget>[
                      Icon(FontAwesome.shopping_cart,color: Color(0xffffe707),size: 30,),
                      Positioned(top: 0,left:0,child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(3),
                        child: Text("3",style: TextStyle(color: Colors.white),),
                      ),)
                    ],
                  ),
                ),

                    Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),child:Icon(FontAwesome.heart,color: Color(0xffffe707),size: 25,)),
                Container(
                  child: Text("Add to cart"),
                  decoration: BoxDecoration(
                      color: Color(0xffffe707).withOpacity(0.4),
                    border: Border.all(
                      color: Color(0xffffe707)
                    ),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                ),
                Expanded(child: RaisedButton(
                  elevation: 0.0,
                  child: Text("Buy It Now"),
                  onPressed: () {},
                  color: Color(0xffffe707),
                  padding: EdgeInsets.all(5),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
