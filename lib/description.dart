import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:e_comerece/Authorization.dart';
import 'package:e_comerece/Json/Product.dart';
import 'package:e_comerece/Partial/ReviewItem.dart';
import 'package:e_comerece/ReviewScreen.dart';
import 'package:e_comerece/cart_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

import 'Coupon.dart';
import 'Json/Colour.dart';
import 'Json/HexColor.dart';
import 'Json/Sku.dart';
import 'Json/User.dart';
import 'SuperBase.dart';

class Description extends StatefulWidget {
  final Product product;
  final User user;
  final void Function(User user) callback;

  const Description({Key key, @required this.product, this.user, this.callback})
      : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> with SuperBase {
  Widget _tit(int has, String title, GlobalKey key) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 17),
        decoration: has == _index
            ? BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.black, width: 4)))
            : null,
        child: Center(
          child: Text(
            title,
            maxLines: 1,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _index = has;
          if (key == null)
            _controller.animateTo(0,
                duration: Duration(seconds: 2), curve: Curves.easeInCubic);
          else
            Scrollable.ensureVisible(key?.currentContext ?? context,
                curve: Curves.easeInCubic, duration: Duration(seconds: 2));
        });
      },
    );
  }

  int _index = 0;

  Database database;
  Product _product;
  Product _newProduct;
  int _value = 1;
  int _current = 0;
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = widget.user;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.open();
      this.loadDetails();
    });
  }

  User _user;

  Future<void> loadDetails() {
    return this.ajax(
        url: "DetailsByProduct/${widget.product.id}",
        auth: false,
        onValue: (source, url) {
          var map = json.decode(source);
          setState(() {
            _newProduct = Product.fromJson(map);
          });
        },
        error: (source, url) {
          print(source);
        });
  }

  void open() async {
    database = await getDatabase();
    _product = await Product.byId(database, '${widget.product.id}');
    _product?.color = widget.product.color;
    _product?.size = widget.product.size;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    database?.close();
  }

  void addToCart() async {
    if (_user == null) {
      platform.invokeMethod("toast", "Not signed in, sign in to continue");
      User user = await Navigator.of(context)
          .push(CupertinoPageRoute(builder: (context) => Authorization()));
      if (widget.callback != null) {
        widget.callback(user);
      }
      if (user == null) {
        return;
      }
      _user = user;
      setState(() {});
    }
    this.ajax(
      url: "http://192.168.43.147:8080/addToCart",
      absolutePath: true,
      method: "POST",
      data: FormData.from({
        "product": widget.product?.id,
        "user": _user?.id,
        "quantity": _product.items ?? 1,
      }),
      server: true,
      auth: false,
      onValue: (source, url) {
        print(source);
        platform.invokeMethod("toast", "Product added to cart");
      },
      onEnd: () {},
      error: (source, url) {
        platform.invokeMethod("toast", "$source");
      },
    );
  }

  void openCart() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return _DescState(
              value: _product?.items ?? 0,
              color: _product?.color,
              size: _product?.size,
              product: widget.product,
              skus: _newProduct?.sku ?? [],
              colors: _newProduct?.colors ?? [],
              onAdd: (value, [color, size]) async {
                if (_product == null) {
                  _product = widget.product;
                  await _product.insertItem(database);
                }
                if (value <= widget.product.count) {
                  _product.items = value;
                  _product.size = size;
                  _product.color = color;
                  _product.updateItem(database);
                }
                setState(() {
                  Navigator.of(context).pop();
                  // addToCart();
                });
              });
        });
  }

  void selectColorAndSize() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return _ColorAndSize(
              skus: _newProduct?.sku ?? [], colors: _newProduct?.colors ?? []);
        });
  }

  var _productKey = new GlobalKey();
  var _detailKey = new GlobalKey();
  var _reviewKey = new GlobalKey();

  final double _appBarHeight = 356.0;

  Widget appBar() {
    return SliverAppBar(
      expandedHeight: _appBarHeight - 25,
      pinned: true,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.create),
          tooltip: 'Edit',
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          onSelected: (String value) {},
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[],
        ),
      ],
      onStretchTrigger: () {
        print("Stretch triggered");
        return Future.value();
      },
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Row(
          children: <Widget>[
            Expanded(child: _tit(0, "Product", null)),
            Expanded(child: _tit(1, "Details", _detailKey)),
            Expanded(child: _tit(2, "Reviews", _reviewKey)),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              key: _productKey,
              height: _appBarHeight,
              child: _newProduct == null || _newProduct.images.isEmpty
                  ? CachedNetworkImage(
                      height: _appBarHeight,
                      width: double.infinity,
                      imageUrl: widget.product.url,
                      placeholder: (context, str) => Center(
                            child: CupertinoActivityIndicator(),
                          ),
                      fit: BoxFit.cover)
                  : Stack(children: <Widget>[
                      CarouselSlider.builder(
                          height: _appBarHeight,
                          autoPlay: true,
                          itemCount: _newProduct.images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _current = index;
                            });
                          },
                          viewportFraction: 1.1,
                          itemBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              color: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)],
                              child: Image(
                                  image: CachedNetworkImageProvider(
                                      _newProduct.images[index]),
                                  fit: BoxFit.cover,
                                  frameBuilder: (context, child, frame, was) =>
                                      frame == null
                                          ? Container(
                                              height: double.infinity,
                                              child: Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              ),
                                            )
                                          : child),
                            );
                          }),
                      Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_newProduct.images.length,
                                (index) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? Color.fromRGBO(0, 0, 0, 0.9)
                                        : Color.fromRGBO(0, 0, 0, 0.4)),
                              );
                            }),
                          ))
                    ]),
            ),
            // This gradient ensures that the toolbar icons are distinct
            // against the background image.
//            const DecoratedBox(
//              decoration: BoxDecoration(
//                gradient: LinearGradient(
//                  begin: Alignment(0.0, -1.0),
//                  end: Alignment(0.0, -0.4),
//                  colors: <Color>[Color(0x60000000), Color(0x00000000)],
//                ),
//              ),
//            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Feather.share),
                      onPressed: () {
                        Share.share(
                            'Product title : ${widget.product.name} , price : \$${fmtNbr(widget.product.price)}, Image : ${widget.product.url}');
                      })
                ],
                expandedHeight: _appBarHeight - 30,
                floating: false,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                title:
                    innerBoxIsScrolled ? Text("${widget.product.name}") : null,
                bottom: innerBoxIsScrolled
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(50),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: _tit(0, "Product", null)),
                            Expanded(child: _tit(1, "Details", _detailKey)),
                            Expanded(child: _tit(2, "Reviews", _reviewKey)),
                          ],
                        ),
                      )
                    : null,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  // print('constraints=' + constraints.toString());
                  var top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                      centerTitle: true,
                      background: _newProduct != null &&
                              _newProduct.images.isNotEmpty
                          ? Stack(children: <Widget>[
                              CarouselSlider.builder(
                                  height: _appBarHeight + 10,
                                  autoPlay: false,
                                  itemCount: _newProduct.images.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                  viewportFraction: 1.1,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: double.infinity,
                                      height: _appBarHeight,
                                      color: Colors.primaries[Random()
                                          .nextInt(Colors.primaries.length)],
                                      child: Image(
                                          height: _appBarHeight,
                                          image: CachedNetworkImageProvider(
                                              _newProduct.images[index]),
                                          fit: BoxFit.cover,
                                          frameBuilder: (context, child, frame,
                                                  was) =>
                                              frame == null
                                                  ? Container(
                                                      height: double.infinity,
                                                      child: Center(
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      ),
                                                    )
                                                  : child),
                                    );
                                  }),
                              Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        _newProduct.images.length, (index) {
                                      return Container(
                                        width: 20.0,
                                        height: 3.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                            color: _current == index
                                                ? color
                                                : Color.fromRGBO(0, 0, 0, 0.4)),
                                      );
                                    }),
                                  ))
                            ])
                          : CachedNetworkImage(
                              height: 300,
                              width: double.infinity,
                              imageUrl: widget.product.url,
                              placeholder: (context, str) => Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                              fit: BoxFit.cover));
                })),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                            '\$${widget.product.price}',
                            style: TextStyle(
                                color: Color(0xffFE8206),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '\$${widget.product.price}',
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
                        '${widget.product.name}',
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
                    InkWell(
                      child: Row(
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
                      onTap: selectColorAndSize,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            CupertinoPageRoute(builder: (context) => Coupon()));
                      },
                      child: Row(
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
                key: _reviewKey,
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: Row(children: [
                        Text(
                          "Reviews",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "(${_newProduct?.reviews?.length ?? 0})",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Spacer(),
                        Text(
                          "View all",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ]),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => ReviewScreen(
                                list: _newProduct?.reviews ?? [])));
                      },
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: _newProduct?.subReviews
                              ?.map((f) => ReviewItem(review: f))
                              ?.toList() ??
                          [],
                    )
                  ],
                ),
              ),
              Container(
                key: _detailKey,
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
              Column(
                children: _newProduct?.images
                        ?.map((f) => Image(
                              image: CachedNetworkImageProvider(f),
                              frameBuilder: (context, child, frame, was) =>
                                  frame == null
                                      ? Container(
                                          height: 300,
                                          child: Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        )
                                      : child,
                            ))
                        ?.toList() ??
                    [],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => CartScreen(
                          user: _user,
                          callback: widget.callback,
                        )));
              },
              child: Container(
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
                          "${_product?.items ?? 0}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  FontAwesome.heart,
                  color: Color(0xffffe707),
                  size: 25,
                )),
            InkWell(
              child: Container(
                child: Text("Add to cart"),
                decoration: BoxDecoration(
                    color: Color(0xffffe707).withOpacity(0.4),
                    border: Border.all(color: Color(0xffffe707)),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 6),
              ),
              onTap: () async {
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
      ),
    );
  }
}

class _ColorAndSize extends StatefulWidget {
  final List<Sku> skus;
  final List<Colour> colors;

  const _ColorAndSize({Key key, @required this.skus, @required this.colors})
      : super(key: key);

  @override
  __ColorAndSizeState createState() => __ColorAndSizeState();
}

class __ColorAndSizeState extends State<_ColorAndSize> {
  Colour _colour;
  Sku _sku;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: widget.colors.length,
                  itemBuilder: (context, index) {
                    var colour = widget.colors[index];
                    var c = HexColor.fromHex(colour.code);
                    return RadioListTile<Colour>(
                      value: colour,
                      groupValue: _colour,
                      onChanged: (colour) {
                        setState(() {
                          _colour = colour;
                        });
                      },
                      title: Text('${colour.name}'),
                      subtitle: Text(
                        "#${colour.code}",
                        style: TextStyle(color: c),
                      ),
                      activeColor: c,
                    );
                  })),
          Expanded(
              child: ListView.builder(
                  itemCount: widget.skus.length,
                  itemBuilder: (context, index) {
                    var sku = widget.skus[index];
                    return RadioListTile<Sku>(
                      value: sku,
                      groupValue: _sku,
                      onChanged: (sku) {
                        setState(() {
                          _sku = sku;
                        });
                      },
                      title: Text(
                        '${sku.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text("${sku.description}"),
                    );
                  })),
        ],
      ),
    );
  }
}

class _DescState extends StatefulWidget {
  final Product product;
  final int value;
  final String size;
  final String color;
  final List<Sku> skus;
  final List<Colour> colors;
  final void Function(int value, [String color, String size]) onAdd;

  const _DescState(
      {Key key,
      @required this.product,
      this.onAdd,
      this.value: 0,
      @required this.skus,
      @required this.colors,
      this.size,
      this.color})
      : super(key: key);

  @override
  __DescStateState createState() => __DescStateState();
}

class __DescStateState extends State<_DescState> with SuperBase {
  int _value = 1;
  String _color;
  String _size;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = widget.value;
    _color = widget.color;
    _size = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                  imageUrl: widget.product.url,
                  placeholder: (context, str) => Center(
                        child: CupertinoActivityIndicator(),
                      ),
                  fit: BoxFit.cover),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "\$${widget.product.price}",
                      style: TextStyle(color: color, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text("Stock : ${widget.product.count}"),
                    Text("Selected size"),
                  ],
                ),
              ))
            ],
          ),
          SizedBox(height: 15),
          Text("Color", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: widget.colors
                .map((f) => InkWell(
                      onTap: () {
                        setState(() {
                          _color = f.name;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: HexColor.fromHex(f.code),
                            border: _color == f.name
                                ? Border.all(width: 2, color: color)
                                : null),
                        child: Text("${f.name}"),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 15),
          Text("Size", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
              children: widget.skus
                  .map((f) => InkWell(
                        onTap: () {
                          setState(() {
                            _size = f.name;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.transparent,
                              border: Border.all(
                                  width: _size == f.name ? 2 : 1,
                                  color:
                                      _size == f.name ? color : Colors.grey)),
                          child: Text('${f.description}'),
                        ),
                      ))
                  .toList()),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text("PCS.", style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              GestureDetector(
                child: new Icon(Icons.remove_circle_outline),
                onTap: () async {
                  setState(() {
                    _value -= _value > 1 ? 1 : 0;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  '$_value',
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                child: new Icon(Icons.add_circle_outline),
                onTap: () async {
                  setState(() {
                    _value += _value <= widget.product.count ? 1 : 0;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                if (widget.onAdd != null) {
                  widget.onAdd(_value, _color, _size);
                }
              },
              child: Text("Add to cart"),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
