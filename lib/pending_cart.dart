import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comerece/Json/Cart.dart';
import 'package:e_comerece/pending_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Json/User.dart';
import 'SuperBase.dart';

class PendingCart extends StatefulWidget {
  final User user;

  const PendingCart({Key key, @required this.user}) : super(key: key);

  @override
  _PendingCartState createState() => _PendingCartState();
}

class _PendingCartState extends State<PendingCart> with SuperBase {
  List<Cart> _list = [];

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
        url:
        "listPendingCarts?userId=${widget.user?.id}",
        onValue: (source, url) {
          Iterable _map = json.decode(source);
          setState(() {
            _list = _map.map((f)=>Cart.fromJson(f)).toList();
          });
        },
        onEnd: (){

        }
    );
  }

  int _index = 0;

  List<String> get _menus =>[
    "ALL",
    "Pending payment",
    "Purchased",
    "Sending",
    "Finished"
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("My orders",style: TextStyle(fontSize: 17)),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 40,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              children: List.generate(_menus.length, (index) {
                return InkWell(
                  child: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: _index == index
                          ? BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: color, width: 2.5)))
                          : null,
                      child: Text(
                        "${_menus[index]}",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                  onTap: () {
                    setState(() {
                      _index = index;
                    });
                  },
                );
              }),
            ),
          ),
          Expanded(
            child: RefreshIndicator(key: refreshKey,child: Scrollbar(child: ListView.builder(
              padding: EdgeInsets.all(15),
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  var _pro = _list[index];
                  return Card(
                    elevation: 1.0,
                    child:InkWell(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          fullscreenDialog: true,
                            builder: (context) => PendingPayment(
                              key: UniqueKey(),
                              cart: _pro,
                              user: widget.user,
                            )));
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 6,bottom: 12),
                              child: Row(
                                children: <Widget>[
                                  Text(_pro.time),
                                  Spacer(),
                                  Text("pending payment"),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(12.0),
                              color: Colors.grey.shade50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    height: 60,
                                    width: 60,
                                    imageUrl: 'https://cdn3.vectorstock.com/i/1000x1000/62/87/flat-design-shopping-cart-vector-13576287.jpg',
                                    fit: BoxFit.cover,
                                    placeholder: (context, i) => Center(
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${_pro.size} orders(\$${fmtNbr(_pro.price)})',
                                              style: TextStyle( fontSize: 16),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsets.symmetric(vertical: 4),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Afrishop',
                                                    style: TextStyle(fontSize: 13,color: Colors.grey),
                                                  ),
                                                  Spacer(),
                                                  Text("pink",style: TextStyle(fontSize: 13,color: Colors.grey))
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: color,
                                                    borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  padding: EdgeInsets.all(5),
                                                  child: Text("\$${_pro.price}"),
                                                ),
                                                Spacer(),
                                                Text("Finished",style: TextStyle(color: Colors.red))
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),onRefresh: _loadItems,),
          ),
        ],
      ),
    );
  }
}
