import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Partial/TouchableOpacity.dart';
import 'detail_screen.dart';
import 'item.dart';

class Homepage extends StatefulWidget {
  final void Function(Item item) callback;

  const Homepage({Key key, this.callback}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: CustomScrollView(
        slivers: _list,
      ),
    );
  }

  final double _appBarHeight = 256.0;

  Widget get appBar {
    return SliverAppBar(
      expandedHeight: _appBarHeight,
      pinned: true,
      elevation: 1.0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Edit',
          onPressed: () {},
        ),
        PopupMenuButton<Item>(
          onSelected: (Item value) {},
          itemBuilder: (BuildContext context) => <PopupMenuItem<Item>>[],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text("Afrishop"),
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CachedNetworkImage(
              fit: BoxFit.cover,
              height: _appBarHeight,
              imageUrl:
                  "https://s7d1.scene7.com/is/image/BHLDN/50827450_065_a?\$pdpmain\$",
              placeholder: (BuildContext context, String s) =>
                  CupertinoActivityIndicator(),
            ),
            // This gradient ensures that the toolbar icons are distinct
            // against the background image.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, -0.4),
                  colors: <Color>[Color(0x60000000), Color(0x00000000)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _list {
    List<Widget> list = <Widget>[
      appBar,
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 35,
                    child: Icon(
                      Icons.phone_android,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Phones",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 35,
                    child: Icon(
                      Icons.headset,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Headsets",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
              Expanded(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.purple,
                      child: Icon(
                        Icons.watch,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Watches",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.computer,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Computers",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.deepOrange,
                      child: Icon(
                        Icons.beach_access,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Umbrellas",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.motorcycle,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Bikes",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.pink,
                      child: Icon(
                        Icons.directions_car,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Cars",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.teal,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Clothers",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "#",
                  style: TextStyle(color: Color(0xffffe707), fontSize: 21),
                ),
                Text(
                  "BRANDS",
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  "#",
                  style: TextStyle(color: Color(0xffffe707), fontSize: 21),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffffe707),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                            color: Colors.white),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                             child: CachedNetworkImage(imageUrl:"https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vg5lxencvl4eybsbyqla/dri-fit-trophy-older-10cm-training-shorts-GlLJVJ.jpg",fit: BoxFit.cover,
                                placeholder: (context,str)=>Center(
                                  child: CupertinoActivityIndicator(),
                                ),)
                      )),
                      Expanded(
                          child: Container(
                        height: 250,
                        decoration: BoxDecoration(color: Colors.white),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                            child: CachedNetworkImage(imageUrl: "https://i.pinimg.com/originals/21/c9/d8/21c9d88ae12712fb16822f26f0087443.jpg",fit: BoxFit.cover,
                            placeholder: (context,str)=>Center(
                              child: CupertinoActivityIndicator(),
                            ),),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        "H&M",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      )),
                      Expanded(
                          child: Text(
                        "NIKE",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                            color: Colors.white),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                             child: CachedNetworkImage(imageUrl:"https://img.alicdn.com/imgextra/i1/2228361831/O1CN01EoJSjv1POdlnO16Db_!!2228361831.jpg",fit: BoxFit.cover,
                                placeholder: (context,str)=>Center(
                                  child: CupertinoActivityIndicator(),
                                ),)
                      )),
                      Expanded(
                          child: Container(
                        height: 250,
                        decoration: BoxDecoration(color: Colors.white),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                            child: CachedNetworkImage(imageUrl: "https://lh3.googleusercontent.com/proxy/5mgLePZkm8WtRURAMzymxzRlVnEqZGUktlD_ifRB-Vif_GJIMyG3akppHQIvSiUfQmK7J4zcJFHGSK4XuFj5tIUJGohhMSZiqoKU2LMGlA8mqxwjm2kLNSOApsko6N-nCDVHkiI5QBktieUoRQ",fit: BoxFit.cover,
                            placeholder: (context,str)=>Center(
                              child: CupertinoActivityIndicator(),
                            ),),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        "ZARA",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      )),
                      Expanded(
                          child: Text(
                        "ADIDAS",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      SliverToBoxAdapter(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0,
              childAspectRatio: 3.0/4,),
            itemCount: _list1.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {

              var item = _list1[index];
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '\$${item.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))
                  ],
                ),
              );
            }),
      )
    ];
    return list;
  }


  List<Item> get _list1 => [
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
        "https://www.forevernew.com.au/media/wysiwyg/megamenu/_AU_NZ/March_2020/Mega-Nav-01_2.jpg"),
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


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
