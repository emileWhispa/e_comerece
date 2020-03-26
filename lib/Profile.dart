import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Json/Post.dart';
import 'Json/User.dart';
import 'SuperBase.dart';
import 'main.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final User object;

  const ProfileScreen({Key key, @required this.user, this.object}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SuperBase {
  List<Post> _list = <Post>[];
  String requestUrl;

  void loadPost() {}

  Future<void> requestImages() {
    return this.ajax(
        url: requestUrl,
        method: "POST",
        data: FormData.from({"user_id": widget.user.id}),
        onValue: (s, v) {
          Iterable map = json.decode(s);
          if (mounted)
            setState(() {
              _list = map.map((f) => Post.fromJson(f)).toList();
            });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    requestUrl = "listImages.php?duo_never=rtrit" + widget.user.id;
    WidgetsBinding.instance.addPostFrameCallback((_) => this.requestImages());

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
        backgroundColor: Color(0xFFf9f9f9),
        navigationBar: CupertinoNavigationBar(
          middle: Text("Username"),
          trailing: CupertinoButton(
              child: Icon(
                Icons.dehaze,
                color: Colors.black,
              ),
              padding: EdgeInsets.zero,
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        title: Text("Options"),
                        actions: <Widget>[
                          CupertinoButton(
                              child: Text("Sign Out"),
                              onPressed: () {
                                this.clear(() {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (ctx) => MyHomePage()));
                                });
                              }),
                        ],
                        cancelButton: CupertinoButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      );
                    });
              }),
        ),
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverRefreshControl(
                onRefresh: () {
                  return this.requestImages();
                },
                builder: (_, __, ___, ____, _____) {
                  return Container(
                      padding: EdgeInsets.only(top: 90),
                      child: const CupertinoActivityIndicator(
                        radius: 12.0,
                      ));
                },
              ),
              SliverPadding(padding: EdgeInsets.symmetric(vertical: 33)),
              SliverToBoxAdapter(
                  child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 55,
                                  backgroundImage:AssetImage("assets/avatar04.png"),
                                ),
                                Positioned(
                                  child: Container(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle),
                                  ),
                                  right: 5,
                                  bottom: 5,
                                )
                              ],
                            ),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Text(
                                  "${_list.length}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Posts",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Text(
                                  "${_list.fold(0, (a, b) => a + b.likes)}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Likes",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Text(
                                  "${_list.fold(0, (a, b) => a + b.comments)}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Comments",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Username",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        widget.object == null ? SizedBox.shrink() : GestureDetector(child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Edit Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                        ),onTap: (){},)
                      ],
                    ),
                  ),
                  GridView.builder(
                      itemCount: _list.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 3.0,
                          crossAxisSpacing: 3.0,
                          crossAxisCount: 3),
                      itemBuilder: (ctx, i) => GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        url(_list[i].image)),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            onTap: (){},
                          ))
                ],
              ))
            ],
          ),
        ));
  }
}
