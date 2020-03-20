import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sqflite/sqflite.dart';

import 'SuperBase.dart';
import 'item.dart';

class Description extends StatefulWidget {
  final Item item;

  const Description({Key key, @required this.item}) : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> with SuperBase {
  Widget _tit(bool has, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 17),
      decoration: has
          ? BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 4)))
          : null,
      child: Center(
        child: Text(
          title,
          maxLines: 1,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  int _index = 0;

  Database database;
  Item _item;
  int _value = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>this.open());
  }

  void open()async{
    database = await getDatabase();
    _item = await Item.byId(database, widget.item.itemId);
    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    database?.close();
  }
  
  void addToCart(){
    this.ajax(url: "item/cart",method: "POST",map: {
      "stationId":widget.item.itemId,
      "stationType":1,
      "itemId":widget.item.itemId,
      "itemTitle":widget.item.title,
      "itemNum":_item?.items ?? 0,
      "itemImg":widget.item.price,
      "itemSku":widget.item.itemSku,
      "shopName":"Shop name",
      "shopUrl":"https://www.afrieshop.com/products/zipper-pants",
      "itemSourceId":"093a0b105da0409ea6c2fe610eecd0a7",
    },server: true,auth: false,onValue: (source,url){
      print(source);
    },error: (source,url){
      print(source);
    },);
  }


  void openCart() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {

          return _DescState(value: _item?.items ?? 0,item: widget.item,onAdd: (value) async {
            if( _item == null ){
              _item = widget.item;
              await _item.insertItem(database);
            }
            if( value <= widget.item.count ) {
              _item.items = value;
              await _item.updateItem(database);
            }
            setState(() {
              addToCart();
              Navigator.of(context).pop();
            });
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffefeff1),
      appBar: AppBar(
        elevation: 2.0,
        title: Row(
          children: <Widget>[
            Expanded(child: _tit(_index == 0, "Product")),
            Expanded(child: _tit(_index == 1, "Details")),
            Expanded(child: _tit(_index == 2, "Reviews")),
          ],
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Feather.share), onPressed: () {})
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView(
            children: <Widget>[
              Container(height: 300,child: CachedNetworkImage(
                  height: 300,
                  width: double.infinity,
                  imageUrl: widget.item.url,
                  placeholder: (context,str)=>Center(child: CupertinoActivityIndicator(),),
                  fit: BoxFit.cover),),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '\$${widget.item.price}',
                            style: TextStyle(
                                color: Color(0xffFE8206),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '\$${widget.item.price}',
                              style: TextStyle(
                                  color: Color(0xffA9A9A9),
                                  fontSize: 17,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        '${widget.item.title}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Free delivery',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: List.generate(
                            5,
                            (index) => Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    index > 2 ? Icons.star_border : Icons.star,
                                    color: index > 2
                                        ? Colors.grey
                                        : Color(0xffFEE606),
                                  ),
                                )).toList(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Please Select",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            "Color, Size",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 20,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Coupons",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                          "Select",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 20,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      Text(
                        "Shipping To",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Text(
                        "Zambia",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ]),
                    SizedBox(
                      height: 40,
                    ),
                    Row(children: [
                      Text(
                        "Shipping Fee",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Text(
                        "\$0",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ]),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      Text(
                        "Reviews",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "(212)",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Spacer(),
                      Text(
                        "View all",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ]),
                    SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 15,
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "GIGk",
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                "2019/11/11 15:19",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              SizedBox(height: 15),
                              Text(
                                  "I buy an lipstick from afri-shop, the color is beautiful!, the color is beautiful! "),
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
                    ),
                    SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 15,
                        ),
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "GIGk",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(
                                    "2019/11/11 15:19",
                                    style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                      "I buy an lipstick from afri-shop, the color is beautiful!, the color is beautiful! "),
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
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(children: [
                      Text(
                        "Details",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      )
                    ]),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Size: S / M / L",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "S:",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Bust: Unlimited",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Sleeve length: 61cm",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Length: 56-37cm",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "M:",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Bust: Unlimited",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Sleeve length: 61cm",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Length: 56-37cm",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "L:",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Bust: Unlimited",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Sleeve length: 61cm",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Length: 56-37cm",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Image.asset("assets/imag9.png",
                  width: double.infinity,
                  fit: BoxFit.cover),
              Image.asset("assets/imag10.JPG",
                  width: double.infinity,
                  fit: BoxFit.fitWidth),
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
                      Icon(
                        FontAwesome.shopping_cart,
                        color: Color(0xffffe707),
                        size: 30,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(3),
                          child: Text(
                            "${_item?.items ?? 0}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      FontAwesome.heart,
                      color: Color(0xffffe707),
                      size: 25,
                    )),
                GestureDetector(
                  child: Container(
                    child: Text("Add to cart"),
                    decoration: BoxDecoration(
                        color: Color(0xffffe707).withOpacity(0.4),
                        border: Border.all(color: Color(0xffffe707)),
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 6),
                  ),
                  onTap: ()async{
                    openCart();
                  },
                ),
                Expanded(
                    child: RaisedButton(
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


class _DescState extends StatefulWidget{
  final Item item;
  final int value;
  final void Function(int value) onAdd;

  const _DescState({Key key,@required this.item, this.onAdd, this.value:0}) : super(key: key);
  @override
  __DescStateState createState() => __DescStateState();
}

class __DescStateState extends State<_DescState> with SuperBase {
  int _value = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CachedNetworkImage(
                  height: 60,
                  imageUrl: widget.item.url,
                  placeholder: (context,str)=>Center(child: CupertinoActivityIndicator(),),
                  fit: BoxFit.cover),
              Expanded(child: Padding(padding: EdgeInsets.only(left: 10),child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("\$${widget.item.price}",style: TextStyle(color: color,fontSize: 20),),
                  SizedBox(height: 10),
                  Text("Stock : ${widget.item.count}"),
                  Text("Selected size"),
                ],
              ),))
            ],
          ),
          SizedBox(height: 15),
          Text("Color",style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: color,
            ),
            child: Text("Blue"),
          ),
          SizedBox(height: 15),
          Text("Size",style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.transparent,
                    border: Border.all(
                        color: Colors.grey
                    )
                ),
                child: Text("L"),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.transparent,
                    border: Border.all(
                        color: Colors.grey
                    )
                ),
                child: Text("M"),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.transparent,
                    border: Border.all(
                        color: Colors.grey
                    )
                ),
                child: Text("S"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text("PCS.",style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              GestureDetector(
                child: new Icon(
                    Icons.remove_circle_outline),
                onTap: () async {
                  setState(() {
                    _value -= _value > 1 ? 1 : 0;
                  });
                },
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: Text(
                '$_value',
                textAlign: TextAlign.center,
              ),),
              GestureDetector(
                child: new Icon(
                    Icons.add_circle_outline),
                onTap: () async {
                  setState(() {
                    _value += _value <= widget.item.count ? 1 : 0;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(width: double.infinity,child: RaisedButton(onPressed: (){
            if( widget.onAdd != null ){
              widget.onAdd(_value);
            }
          },child: Text("Add to cart"),color: color,),),
        ],
      ),
    );
  }
}