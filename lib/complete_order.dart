import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:e_comerece/Json/Cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'Json/Product.dart';
import 'Json/User.dart';
import 'PaymentSuccess.dart';
import 'SuperBase.dart';

class CompleteOrder extends StatefulWidget {
  final User user;
  final List<Product> list;

  const CompleteOrder({Key key, this.user, @required this.list})
      : super(key: key);

  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> with SuperBase {

  var _addingToCart = false;

  void addToCart() async {
    setState(() {
      _addingToCart = true;
    });
    this.ajax(
      url: "addToCart",
      method: "POST",
      data: FormData.from({
        "hash": "$unique${widget.user?.id ?? ""}",
        "user": widget.user?.id,
        "products": json.encode(widget.list.map((v)=>{
          "productId":v.id,
          "price":v.price ?? 0,
          "quantity":v.items,
          "color":v.color,
          "size":v.size,
        }).toList()),
      }),
      server: true,
      auth: false,
      onValue: (source, url) {
        Cart cart = Cart.fromJson(json.decode(source));
        Navigator.of(context).push(CupertinoPageRoute(builder: (ctx)=>PaymentSuccess(user: widget.user,cart: cart,)));
        print(source);
        platform.invokeMethod("toast","Products successfully paid");
      },
      onEnd: (){
        setState(() {
          _addingToCart = false;
        });
      },
      error: (source, url) {
        print(source);
        platform.invokeMethod("toast","$source");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check out",
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "${widget.user.username}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("${widget.user.phone}"),
                    )
                  ],
                ),
                Text("Kimironko")
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                var pro = widget.list[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        image: CachedNetworkImageProvider(pro.url),
                        height: 60,
                        width: 60,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${pro.name}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text("Gold bright"),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Color(0xffffe707),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      '\$${pro.total}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Spacer(),
                                  Text("x${pro.items}")
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            margin: EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap: () {},
                  title: Text("Merchandise Total"),
                  trailing: Text("\$141.11"),
                ),
                ListTile(
                  onTap: () {},
                  title: Text("Shipping Fee"),
                  trailing: Text("\$0"),
                ),
                ListTile(
                  onTap: () {},
                  title: Text("Handling Fee"),
                  trailing: Text("\$5.65"),
                ),
                ListTile(
                  onTap: () {},
                  title: Text("Duty Fee"),
                  trailing: Text("\$22.58"),
                ),
                ListTile(
                  onTap: () {},
                  title: Text("Coupon"),
                  trailing: Text("\$0.00"),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar:  Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(10),
        child: _addingToCart ? CupertinoActivityIndicator() : Row(
          children: <Widget>[
            Text("Subtotal:"),
            Text(
              "\$${widget.list.fold(0.0, (v, e) => v + e.total).toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            RaisedButton(
                color: color,
                padding: EdgeInsets.all(0),
                child: Text("Proceed to Checkout"),
                onPressed: () {
                  showModalBottomSheet(context: context,backgroundColor: Colors.transparent,builder: (context){
                    return _PopPage(addToCart: addToCart,price: widget.list.fold(0.0, (v,o)=>v+o.price),);
                  });
                })
          ],
        ),
      ),
    );
  }
}

class _PopPage extends StatefulWidget{
  final void Function() addToCart;
  final double price;

  const _PopPage({Key key,@required this.addToCart,@required this.price}) : super(key: key);
  @override
  __PopPageState createState() => __PopPageState();
}

class __PopPageState extends State<_PopPage> with SuperBase {
  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6))
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text("Payment method",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),),
              IconButton(icon: Icon(Icons.close),onPressed: (){
                Navigator.of(context).pop();
              },)
            ],
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300)
                )
            ),
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text("Subtotal : \$${widget.price}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
          ),
          ListTile(onTap: (){
            setState(() {
              _selected = 0;
            });
          },leading: CircleAvatar(
            backgroundImage: AssetImage("assets/dpo.jpg"),
          ),trailing: _selected == 0 ? Icon(Icons.check_circle,color: color,) : null,title: Text("DPO"),subtitle: Text("All card types"),),
          ListTile(contentPadding: EdgeInsets.all(8),onTap: (){
            setState(() {
              _selected = 1;
            });
          },trailing: _selected == 1 ? Icon(Icons.check_circle,color: color,) : null,leading: CircleAvatar(
            backgroundImage: AssetImage("assets/flutterwave.png"),
          ),title: Text("Flutterwave"),subtitle: Text("Local cards and mobile money payments",maxLines: 1,overflow: TextOverflow.ellipsis,),),
          Spacer(),
          Container(width: double.infinity,child: RaisedButton(onPressed: (){
            Navigator.of(context).pop();
            widget.addToCart();
          },color: color,child: Text("Pay",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)))
        ],
      ),
    );
  }
}
