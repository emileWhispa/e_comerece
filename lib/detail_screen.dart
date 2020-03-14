import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Partial/TouchableOpacity.dart';
import 'description.dart';
import 'item.dart';

class DetailScreen extends StatefulWidget {
  final Item item;

  const DetailScreen({Key key, @required this.item}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<Item> get _list3 => [
        Item(34.78, "Woman in black dress",
            "https://xcdn.next.co.uk/COMMON/Items/Default/Default/Publications/G99/shotview/105/452-274s.jpg"),
        Item(
            24.789,
            "Woman in black dress looks fit and gorgeous and so i can marry her",
            "https://cdn-images.farfetch-contents.com/emilio-pucci-vahine-print-wrap-dress_14182344_25241451_480.jpg"),
        Item(45.32, "Woman in black dress",
            "https://media.nastygal.com/i/nastygal/agg88820_red_xl?\$product_image_category_page_horizontal_filters_desktop\$"),
        Item(21.90, "Woman in black dress",
            "https://s7d5.scene7.com/is/image/Anthropologie/4130647160022_009_b?\$an-category\$&qlt=80&fit=constrain"),
        Item(82, "Woman in black dress",
            "https://gloimg.zafcdn.com/zaful/pdm-product-pic/Clothing/2016/07/27/goods-first-img/1493770024277473218.JPG"),
        Item(76, "Woman in black dress",
            "https://cdn-images.farfetch-contents.com/emilio-pucci-heliconia-print-sequin-fringe-mini-dress_14182345_25241532_480.jpg"),
      ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.item.title),
          elevation: 2.0,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],
          bottom: PreferredSize(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("Best match"),
                  )),
                  IconButton(icon: Icon(Icons.dashboard), onPressed: () {}),
                  IconButton(icon: Icon(Icons.filter), onPressed: () {})
                ],
              ),
              preferredSize: Size.fromHeight(45)),
        ),
        body: ListView.builder(
            itemCount: _list3.length,
            itemBuilder: (context, index) {
              return TouchableOpacity(
                onTap: (){
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>Description(key: UniqueKey(),item: _list3[index],)));
                },
                child: Card(
                  elevation: 1.0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CachedNetworkImage(
                          height: 100,
                          width: 100,
                          imageUrl: _list3[index].url,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _list3[index].title,
                                    style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 7),
                                    child: Text(
                                      '\$${_list3[index].price}',
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(6, (index) {
                                      return index == 5
                                          ? Expanded(
                                          child: Text(
                                            "60 orders",
                                            textAlign: TextAlign.end,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ))
                                          : Icon(
                                        Icons.star_border,
                                        color: Colors.amber,
                                        size: 15,
                                      );
                                    }),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(20)),
                                        child: Text(
                                          "Free shipping",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(Icons.more_vert)
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
