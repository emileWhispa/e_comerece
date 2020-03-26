import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_comerece/Json/User.dart';
import 'package:e_comerece/SuperBase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'Json/Post.dart';
import 'Partial/ListItem.dart';
import 'item.dart';

class Staggered extends StatefulWidget {
  @override
  _StaggeredState createState() => _StaggeredState();
}

class _StaggeredState extends State<Staggered> with SuperBase {
  List<Item> _items = [];
  List<String> _urls = [];


  Future<void> loadMore(){
    return this.ajax(url: requestUrl,absolutePath: true,method: "POST",data: FormData.from({"user_id":"2","parameter":"other"}),onValue: (s,v){
      Iterable map = json.decode(s);
      if(mounted) setState(() {
        _loading = false;
        _list = map.map((f)=>Post.fromJson(f)).toList();
      });
    },onEnd: (){
      setState(() {
        _loading = false;
      });
    });
  }

  int max;
  int current = 0;
  bool _loading = false;
  GlobalKey<RefreshIndicatorState> _refreshKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<void> _loadItems({bool inc: false}) {
    if (max != null && current > max) {
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
          if (_urls.contains(url)) {
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
        onEnd: () {
          setState(() {
            _loading = false;
          });
        },
        error: (s, v) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadMore());
  }

  Future<void> _refresh() {
    _refreshKey.currentState?.show(atTop: true);
    return loadMore();
  }


  List<Post> _list = <Post>[];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffefefef),
      appBar: AppBar(title: Text("Discover",style: TextStyle(fontSize: 17),),centerTitle: true,),
      body: RefreshIndicator(
          key: _refreshKey,
          child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (ctx, i) => ListItem(
                post: _list[i],
                func: (Post p){
                  _list[i] = p;
                  this.save(url(requestUrl), _list);
                },
                delete: (p){
                  setState(() {
                    _list.removeAt(i);
                  });
                  this.save(url(requestUrl), _list);
                },
                user: User("12", "Wgusoa", "Emile", "Username whispa", "077621709", "345", "Status", "[arty", "Admin"),
              )),
          onRefresh: _refresh),
    );
  }


  String get requestUrl => "https://exapps.rw/projects/AFRIFAM/api/afrikayi/listImages.php?go-request";
}
