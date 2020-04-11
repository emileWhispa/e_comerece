import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comerece/Json/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Partial/TouchableOpacity.dart';
import 'SuperBase.dart';
import 'description.dart';
import 'item.dart';

class InsideCategory extends StatefulWidget{
  @override
  _InsideCategoryState createState() => _InsideCategoryState();
}

class _InsideCategoryState extends State<InsideCategory> with SuperBase{

  int max;
  int current = 0;
  bool _loading = false;
  int _index = 0;
  List<String> _urls = [];
  List<Item> _items = [];
  ScrollController _controller = new ScrollController();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>this._loadItems(inc: true));
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadItems(inc: true);
        print("reached bottom ($current)");
      }
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300)
              )
            ),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                Spacer(),
                InkWell(onTap: (){
                  setState(() {
                    _index = 0;
                  });
                },child: Container(decoration: BoxDecoration(
                    border: _index == 0 ? Border(
                        bottom: BorderSide(color: Colors.grey,width: 2)
                    ) : null
                ),padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),child: Text("New In",textAlign: TextAlign.center,))),
                InkWell(onTap: (){
                  setState(() {
                    _index = 1;
                  });
                },child: Container( decoration: BoxDecoration(
                  border: _index == 1 ? Border(
                    bottom: BorderSide(color: Colors.grey,width: 2)
                  ) : null
                ), padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),child: Text("Price Up",textAlign: TextAlign.center,))),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: _controller,
              itemCount: _items.length,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.4 / 4,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0),
              itemBuilder: (context, index) {
                var _pro = _items[index];
                return TouchableOpacity(
                  padding: EdgeInsets.all(5),
                  onTap: () async{
              await Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => Description(
                      product: Product(_pro.title, _pro.price, _pro.url,_pro.count))));
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
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _loading ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoActivityIndicator(),
      ) : null,
    );
  }
}