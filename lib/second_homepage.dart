import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comerece/Json/Product.dart';
import 'package:e_comerece/Json/SubCategory.dart';
import 'package:e_comerece/Partial/TouchableOpacity.dart';
import 'package:e_comerece/description.dart';
import 'package:e_comerece/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Json/Brand.dart';
import 'SuperBase.dart';
import 'item.dart';
import 'cart_page.dart';

class SecondHomepage extends StatefulWidget {
  final GlobalKey<CartScreenState> cartState;

  const SecondHomepage({Key key,@required this.cartState}) : super(key: key);
  @override
  _SecondHomepageState createState() => _SecondHomepageState();
}

class _SecondHomepageState extends State<SecondHomepage> with SuperBase {
  Widget _brand(String title) {
    return Container(
      margin: EdgeInsets.only(top: 60, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("#", style: TextStyle(fontSize: 22, color: Color(0xfffbd858))),
          Text(
            title,
            style: TextStyle(fontSize: 25, color: Color(0xff4d4d4d)),
          ),
          Text("#", style: TextStyle(fontSize: 22, color: Color(0xfffbd858))),
        ],
      ),
    );
  }

  var _control = new GlobalKey<RefreshIndicatorState>();

  List<Item> _items = [];
  List<String> _urls = [];


  int max;
  int current = 0;
  bool _loading = false;
  ScrollController _controller = new ScrollController();

  Widget _row(String title, String title2) {
    final style = TextStyle(
        color: Color(0xffe8c854), fontSize: 18, fontStyle: FontStyle.italic);
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            padding: EdgeInsets.all(20),
            color: Color(0xff333333),
            child: Center(
                child: Text(
              title,
              style: style,
            )),
          )),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(left: 3),
            color: Color(0xff333333),
            child: Center(
              child: Text(
                title2,
                style: style,
              ),
            ),
          )),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._loadBrands();
      this._refreshList(inc: true);
    });

    _controller.addListener(() {
        if (_controller.position.pixels == _controller.position.maxScrollExtent) {
          _refreshList(inc: true);
          print("reached bottom ($current)");
        }
    });
  }

  Future<void> _loadBrands() {
    return this.ajax(
        url: "brands/list",
        onValue: (source, url) {
          Iterable _map = json.decode(source);
          setState(() {
            //_brands = _map.map((f) => Brand.fromJson(f)).toList();
          });
        },
        error: (s, v) {
          print(s);
        });
  }

  Future<void> _loadItems({bool inc: false}) {
    if (max != null && current > max ) {
      return Future.value();
    }
    current += inc ? 1 : 0;
    setState(() {
      _loading = true;
    });
    return this.ajax(
        url:
            "https://dev.diaosaas.com/zion/itemStation/queryAll?pageNum=$current&pageSize=6",
        absolutePath: true,
        auth: false,
        server: true,
        onValue: (source, url) {
          if( _urls.contains(url) ){
            return;
          }
          _urls.add(url);
          //print("Whispa sent requests ($current): $url");
          Map<String, dynamic> _data = json.decode(source);
          Iterable _map = _data['data']['list'];
          max = _data['pages'];
          setState(() {
            _items.addAll(_map.map((f) => Item.fromJson(f)).toList());
          });
        },
        onEnd: (){
          setState(() {
            _loading = false;
          });
        },
        error: (s, v) {

        });
  }

  List<Brand> get _brands => [
        Brand("H&M", "assets/imag4.JPG"),
        Brand("NIKE", "assets/imag5.JPG"),
        Brand("ZARA", "assets/imag6.JPG"),
        Brand("ADIDAS", "assets/imag7.JPG"),
      ];

  Future<void> _refreshList({bool inc: false}) {
    _control.currentState?.show(atTop: true);
    _loadBrands();
    _loadItems(inc: inc);

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var _len = _items.length + (_loading ? 13 : 12);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
              key: _control,
              displacement: 80,
              child: Scrollbar(
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: _len,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Image.asset("assets/home_banner@3x.png");
                        }

                        if (index == 1) {
                          return _row("MEN", "WOMEN");
                        }

                        if (index == 2) {
                          return _row("CHILDREN", "AFRIHOME");
                        }

                        if (index == 3) {
                          return _row("COSMETICS", "ELECTRONICS");
                        }

                        if (index == 4) {
                          return _row("HAIR", "SPORTSWEAR");
                        }

                        if (index == 5) {
                          return _brand("NEW ARRIVALS");
                        }

                        if (index == 6) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Image.asset("assets/imag1.JPG"),
                          );
                        }

                        if (index == 7) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Image.asset("assets/imag2.JPG"),
                          );
                        }

                        if (index == 8) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Image.asset("assets/imag3.JPG"),
                          );
                        }

                        if (index == 9) {
                          return _brand("OTHER BRANDS");
                        }

                        if (index == 10) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Color(0xffffe707),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: <Widget>[
                                GridView.builder(
                                  itemCount:
                                      _brands.length > 4 ? 4 : _brands.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 2.4 / 4,
                                          mainAxisSpacing: 4.0,
                                          crossAxisSpacing: 4.0),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                            constraints:
                                                BoxConstraints(minHeight: 150),
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            child: Image.asset(
                                              _brands[index].url,
                                              fit: BoxFit.cover,
                                            )),
                                        SizedBox(height: 5),
                                        Expanded(
                                            child: Text(
                                          _brands[index].name,
                                          textAlign: TextAlign.center,
                                          style:
                                              Theme.of(context).textTheme.title,
                                        )),
                                      ],
                                    );
                                  },
                                ),
                                TouchableOpacity(
                                    child: Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  child: Center(
                                    child: Text("VIEW MORE"),
                                  ),
                                ))
                              ],
                            ),
                          );
                        }

                        if (index == 11) {
                          return _brand("HOT SALES");
                        }

                        if( index == _len - 1  && _loading){
                          return Center(child:SizedBox(
                            height: 40,
                            width: 40,
                            child:  CircularProgressIndicator()),
                          );
                        }

                        index = index - 12;

                        if (_items.length ~/ 3 < index) return Container();

                        return Row(
                          children: <Widget>[
                            Expanded(
                                child: _gridItem(
                                    "FASHION PLEATED TOP FRIEND",
                                    "https://images-na.ssl-images-amazon.com/images/I/51iYRa329DL._SL1024_.jpg",
                                    200,
                                    index: index,
                                    count: 0)),
                            Expanded(
                                child: _gridItem(
                                    "FASHION PLEATED TOP FRIEND",
                                    "https://s7d5.scene7.com/is/image/UrbanOutfitters/55958102_069_b?\$medium\$&qlt=80&fit=constrain",
                                    178,
                                    index: index,
                                    count: 1)),
                            Expanded(
                                child: _gridItem(
                                    "FASHION PLEATED TOP FRIEND",
                                    "https://lp2.hm.com/hmgoepprod?set=width[800],quality[80],options[limit]&source=url[https://www2.hm.com/content/dam/campaign-ladies-s01/februari-2020/1301a/1301-3x2-weekend-style-forerver.jpg]&scale=width[global.width],height[15000],options[global.options]&sink=format[jpg],quality[global.quality]",
                                    187,
                                    index: index,
                                    count: 2)),
                          ],
                        );
                      })),
              onRefresh: _refreshList),
          Positioned(
              child: Container(
            margin: EdgeInsets.only(top: 25),
            width: double.infinity,
            height: 58,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/afrishop_logo@3x.png",
                    width: 75,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        hintText: "I'm shopping for...",
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        fillColor: Color(0xfff5f5f5),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ))
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _gridItem(String title, String url, double price,
      {int count: 0, int index: 0}) {
    index = (index * 3) + count;
    return _items.length <= index
        ? Container()
        : TouchableOpacity(
            padding: EdgeInsets.all(5),
            onTap: () async{
              await Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => Description(
                      item: _items[index])));
              widget.cartState.currentState?.loadItems();
            },
            child: Container(
              height: 170,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Image(
                      image: CachedNetworkImageProvider('${_items[index].url}'),
                      fit: BoxFit.cover,
                        loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null ?
                              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                    ),
                  )),
                  SizedBox(height: 5),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '${_items[index].title}',
                        style: TextStyle(
                            color: Color(0xff4d4d4d),
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        '\$${_items[index].price}',
                        style: TextStyle(color: Color(0xffCDCDCD)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))
                ],
              ),
            ),
          );
  }
}
