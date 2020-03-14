import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comerece/Partial/TouchableOpacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'detail_screen.dart';
import 'item.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  List<Item> get _list => [
        Item(30, "Woman in black dress",
            "https://www.urbasm.com/wp-content/uploads/2014/10/Diana-Retegan.jpg"),
        Item(121, "Woman in black dress",
            "https://d23gkft280ngn0.cloudfront.net/thumb550/2019/11/7/Sherri-Hill-Sherri-Hill-53448-pink-45390.jpg"),
        Item(67, "Woman in black dress",
            "https://pagani-co-nz.imgix.net/products/jersey-t-shirt-maxi-dress-navywhite-main-63156~1574999306.jpg?w=590&h=960&fit=crop&auto=format&bg=ffffff&s=c15e59309d37a69420f317dd27166841"),
        Item(31, "Woman in black dress",
            "https://is4.revolveassets.com/images/p4/n/c/AXIS-WD409_V1.jpg"),
        Item(90, "Woman in black dress",
            "https://s7d1.scene7.com/is/image/BHLDN/50827450_065_a?\$pdpmain\$"),
        Item(63, "Woman in black dress",
            "https://www.forevernew.com.au/media/wysiwyg/megamenu/_AU_NZ/March_2020/Mega-Nav-01_2.jpg"),];
  List<Item> get _list2 =>[
        Item(21, "Woman in black dress",
            "https://keimag.com.my/image/cache/cache/5001-6000/5302/main/bbf3-PYS_2306-2c-0-1-0-1-1-800x1200.jpg"),
        Item(45, "Woman in black dress",
            "https://www.theclosetlover.com/sites/files/theclosetlover/productimg/201908/4-dsc05237.jpg"),
        Item(30, "Woman in black dress",
            "https://photo.venus.com/im/18158145.jpg?preset=dept"),
        Item(06, "Woman in black dress",
            "https://images.dorothyperkins.com/i/DorothyPerkins/DP07279213_M_1.jpg?\$w700\$&qlt=80"),
        Item(17.6, "Woman in black dress",
            "https://media.thereformation.com/image/upload/q_auto:eco/c_scale,w_auto:breakpoints_100_1920_9_20:544/v1/prod/media/W1siZiIsIjIwMjAvMDEvMTMvMDAvMDkvNTgvNzQxNDk0MmItZDMxNy00Zjg0LTg0MTMtMGM0Yzk0NWM0MjJiL0NhcnJhd2F5LWRyZXNzLWl2b3J5LmpwZyJdXQ/Carraway-dress-ivory.jpg"),
        Item(23.2, "Woman in black dress",
            "https://cdn.shopify.com/s/files/1/0412/3817/products/0I2A2081_bc866ac5-e45f-44b5-887e-c3cedb42e9f9_500x.jpg?v=1583300504"),];
  List<Item> _list3 = [
        Item(34.78, "Woman in black dress",
            "https://xcdn.next.co.uk/COMMON/Items/Default/Default/Publications/G99/shotview/105/452-274s.jpg"),
        Item(24.789, "Woman in black dress",
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

  List<String> get _categories => [
        "Clothes",
        "Electronics",
        "Home & Office",
        "Phone",
        "Tablets",
        "Shoes",
        "Wedding",
        "Gifts",
        "Arts"
      ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height) / 1.50;
    final double itemWidth = size.width / 2;
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          title: Text("Category page"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: (){})
          ],
        ),
        body: Row(children: [
          Container(
            width: 110,
            child: ListView.builder(
                itemCount: _categories.length + 1,
                itemBuilder: (context, index) {
                  index = index - 1;
                  if (index < 0) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 17.5, horizontal: 5),
                      child: Text(
                        "Recommended",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    );
                  }
                  return Container(
                    color: const Color(0xffefeeee),
                    margin: EdgeInsets.symmetric(vertical: 1),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Text(
                      _categories[index],
                      style: TextStyle(color: Color(0xff9c9a9a)),
                    ),
                  );
                }),
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(15),child: Text("Recommended",
              style: Theme.of(context).textTheme.subtitle,),),
              _grid(_list),

              Padding(padding: EdgeInsets.all(15),child: Text("Hot items",
                style: Theme.of(context).textTheme.subtitle,),),
              _grid(_list2),

              Padding(padding: EdgeInsets.all(15),child: Text("Suggested",
                style: Theme.of(context).textTheme.subtitle,),),
              _grid(_list3)
            ],
          ))
        ]));
  }

  Widget _grid(List<Item> _list){
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(6),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3.3/4,
            crossAxisSpacing: 4.0,
            //childAspectRatio: (itemWidth / itemHeight),
            mainAxisSpacing: 4.0),
        itemCount: _list.length,
        itemBuilder: (context, index) {
          var item = _list[index];
          return TouchableOpacity(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => DetailScreen(
                    key: UniqueKey(),
                    item: item,
                  )));
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Container(
                  constraints: BoxConstraints(
                      minWidth: double.infinity),
                  child: CachedNetworkImage(
                    imageUrl: item.url,
                    fit: BoxFit.cover,
                    placeholder: (context, str) => Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                )),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      item.title,
                      style: TextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
              ],
            ),
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
