import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:e_comerece/Json/Cart.dart';
import 'package:e_comerece/Json/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Json/User.dart';
import 'PaymentScreen.dart';
import 'SuperBase.dart';
import 'description.dart';

class PendingPayment extends StatefulWidget {
  final User user;
  final Cart cart;

  const PendingPayment({Key key, @required this.user, @required this.cart})
      : super(key: key);

  @override
  _PendingPaymentState createState() => _PendingPaymentState();
}

class _PendingPaymentState extends State<PendingPayment> with SuperBase {
  List<Product> _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => this._loadItems());
  }

  var refreshKey = new GlobalKey<RefreshIndicatorState>();

  Future<void> _loadItems() {
    refreshKey.currentState?.show(atTop: true);
    return this.ajax(
        url: "listPendingPayments?cartId=${widget.cart?.id}",
        onValue: (source, url) {
          Iterable _map = json.decode(source);
          setState(() {
            _list = _map
                .map((f) => Product.fromJson(f['product'],
                    items: f['quantity'], color: f['color'], size: f['size']))
                .toList();
          });
        },
        onEnd: () {});
  }

  int _step = 0;



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE)
          ),
        ),
        Container(
          height: 155,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffd8c400),
                Color(0xfffdec4c),
                Color(0xfffdf287)
              ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 365),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 155,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xffd8c400),
                            Color(0xfffdec4c),
                            Color(0xfffdf287)
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
                    ),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Live Time left",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "15 MIN",
                              style: TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: ClipRRect(
                                child: LinearProgressIndicator(
                                  value: 0.7,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                  backgroundColor: Color(0xffff9800),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                height: 250,
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green),
                                            height: 24,
                                            width: 24,
                                            margin: EdgeInsets.only(right: 10),
                                            child: Center(
                                              child: Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "20:13",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                "Order accepted by vendor",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                      Expanded(
                                          child: Container(
                                        width: 2,
                                        color: Colors.green,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                      )),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green),
                                            height: 24,
                                            width: 24,
                                            margin: EdgeInsets.only(right: 10),
                                            child: Center(
                                                child: Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )),
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "20:13",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                "Order accepted by vendor",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                      Expanded(
                                          child: Container(
                                        width: 2,
                                        color: Colors.green,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 10),
                                      )),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green),
                                            height: 24,
                                            width: 24,
                                            margin: EdgeInsets.only(right: 10),
                                            child: Center(
                                                child: Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )),
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("20:13",
                                                  style: TextStyle(fontSize: 12)),
                                              Text(
                                                "Order accepted by vendor",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                      Expanded(
                                          child: Container(
                                        width: 2,
                                        color: Colors.grey,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 10),
                                      )),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey),
                                              height: 24,
                                              width: 24,
                                              margin: EdgeInsets.only(right: 10)),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("20:13",
                                                  style: TextStyle(fontSize: 12)),
                                              Text(
                                                "Order accepted by vendor",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      top: 15,
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 13),
                      child: Text("Order summary",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Text("Order number : #XT6YF",style: TextStyle(),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 5),
                      child: Text("Total price : \$${fmtNbr(_list.fold(0, (v,o)=>(v+o.total).toInt()))}",style: TextStyle(),),
                    ),
                    ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(15),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          var _pro = _list[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => Description(
                                    key: UniqueKey(),
                                    product: _pro,
                                  )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    height: 50,
                                    width: 50,
                                    imageUrl: '${_pro.url}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, i) => Center(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(child: Text(
                                                  _pro.name,
                                                  style: TextStyle(
                                                      color: Colors.grey, fontSize: 16),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                )),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(horizontal: 7),
                                                  child: Text(
                                                    '\$${_pro.total.toInt()}',
                                                    style:
                                                    Theme.of(context).textTheme.title.copyWith(fontSize: 15),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text("${_pro.items} pcs",style: TextStyle(color: Colors.grey),)
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
