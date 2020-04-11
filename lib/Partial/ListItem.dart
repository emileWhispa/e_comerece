import '../Json/Post.dart';
import '../Json/User.dart';
import '../Profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../SuperBase.dart';

class ListItem extends StatefulWidget {
  final Post post;
  final User user;
  final void Function(Post post) func;
  final void Function(Post post) delete;

  const ListItem(
      {Key key, @required this.post, @required this.user, @required this.func, this.delete})
      : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> with SuperBase {
  int _current = 0;

  void likePic() {
    if (widget.post.liked) {
      widget.post.likes++;
    } else
      widget.post.likes--;
    widget.func(widget.post);
    this.ajax(
        url: "?likeder",
        server: true,
        method: "POST",
        data: FormData.from({
          "post_id": widget.post.id,
          "user_id": widget.user.id,
          "action": "like-pic"
        }),
        onValue: (s, v) {
          print(s);
        },
        onEnd: () {});
  }

  void deletePost(){
    if( widget.delete != null ) widget.delete(widget.post);

    this.ajax(url: "?ajax-deleter",server: true,method: "POST",data: FormData.from({"action":"delete-post","post_id":widget.post.id}));
  }

  @override
  Widget build(BuildContext context) {
    var im = AssetImage("assets/boys.jpg");
    var height = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: im,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          child: Text(
                            "Username",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (ctx) =>
                                        ProfileScreen(user: widget.post.user)));
                          }),
                      Text(
                        "Rwanda country",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              CupertinoButton(
                child: Icon(
                  Icons.more_horiz,
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
                           widget.user.id == widget.post.user.id ? CupertinoButton(
                                child: Text("Delete post"), onPressed: (){
                                  Navigator.pop(context);
                                  deletePost();
                           }) : SizedBox.shrink(),
                            CupertinoButton(
                                child: Text("Report post"), onPressed: () {}),
                          ],
                          cancelButton: CupertinoButton(child: Text("Cancel",style: TextStyle(color: Colors.red),), onPressed: ()=>Navigator.pop(context)),
                        );
                      });
                },
              )
            ],
          ),
        ),
        CarouselSlider(
            viewportFraction: 1.1,
            enableInfiniteScroll: false,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            height: height,
            items: widget.post.pictures.map((f) {
              return Container(
                height: 320,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider("https://exapps.rw/projects/AFRIFAM/api/afrikayi/${f.image}"),
                        fit: BoxFit.cover)),
              );
            }).toList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.post.pictures
              .asMap()
              .map((i, url) {
                return MapEntry(
                    i,
                    Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == i
                              ? Colors.blue
                              : Color.fromRGBO(0, 0, 0, 0.4)),
                    ));
              })
              .values
              .toList(),
        ),
        widget.post.caption.isEmpty
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  widget.post.caption,
                  style: TextStyle(fontSize: 15),
                ),
              ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: CupertinoButton(
                  child: Icon(
                    widget.post.liked
                        ? Ionicons.ios_heart
                        : Ionicons.ios_heart_empty,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.post.liked = !widget.post.liked;
                    });
                    this.likePic();
                  },
                  padding: EdgeInsets.zero,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: CupertinoButton(
                    child: Icon(
                      Ionicons.ios_chatboxes,
                      color: Colors.black,
                      size: 30,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: goComments),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                    child: Icon(
                      Ionicons.ios_send,
                      color: Colors.black,
                      size: 30,
                    ),
                    onTap: () {}),
              ),
              Expanded(child: SizedBox.shrink()),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                    child: Icon(
                      Ionicons.ios_bookmarks,
                      color: Colors.black,
                    ),
                    onTap: () {}),
              ),
            ],
          ),
        ),
        widget.post.likes > 0
            ? Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "${widget.post.likes} ${widget.post.likes > 1 ? 'people' : 'person'} liked this",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              )
            : SizedBox.shrink(),
        CupertinoButton(
            child: Text(
              "View all ${widget.post.comments} comments",
              style: TextStyle(color: Colors.black87),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5),
            onPressed: goComments),
      ],
    );
  }

  void goComments() async {

  }
}
