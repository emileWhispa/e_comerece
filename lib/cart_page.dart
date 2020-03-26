import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_comerece/description.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'SuperBase.dart';
import 'item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> with SuperBase {
  List<Item> _list = [];
  _SearchDelegate _delegate = new _SearchDelegate();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => this.loadItems());
  }

  var _control = new GlobalKey<RefreshIndicatorState>();
  bool _select = false;

  Future<void> loadItems() async {
    _control.currentState?.show(atTop: true);
    await open();
    _list = await Item.itemList(db);
    setState(() {});
    return Future.value();
  }



  Database db;

  Future<void> open() async {
    db = await getDatabase();
    return Future.value();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    db?.close();
  }


  void deleteModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext build) {
          var list = _list.where((f)=>f.selected).toList();
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Confirm to delete ${list.length} items(s) from cart ?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  list.map((f) => f.title).join(", "),
                  maxLines:
                  MediaQuery.of(build).orientation == Orientation.portrait
                      ? 20
                      : 10,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: FlatButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(build).pop()),
                    ),
                    RaisedButton(
                        child: Text('Delete'),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.of(build).pop();
                          this.deleter(list);
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  void deleter(List<Item> list)async{
    for(int i=0;i<list.length;i++) {
      await list[i].deleteItem(db);
    }
    setState(() {
      _list.removeWhere((f)=>f.selected);
      _select = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          elevation: 2.0,
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {
              showSearch(context: context, delegate: _delegate);
            }),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  if (!_select) {
                    setState(() {
                      _select = true;
                    });
                  } else {
                    // Delete here
                    deleteModal();
                  }
                })
          ],
        ),
        backgroundColor: Colors.black12,
        body: Column(
          children: <Widget>[
            Expanded(
                child: RefreshIndicator(
                    child: Scrollbar(
                        child: ListView.builder(
                      itemCount: _list.length,
                      itemBuilder: (context, index) {
                        var _item = _list[index];
                        var itx = Container(
                          margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3)),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>Description(item: _item)));
                              loadItems();
                            },
                            child: Row(
                              children: <Widget>[
                                Image(
                                  height: 90,
                                  width: 90,
                                  image: CachedNetworkImageProvider(_item.url),
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
                                Expanded(
                                    child: Container(
                                  height: 90,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                        _item.title,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      )),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Color(0xffffe707),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              '\$${_item.price}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(child: SizedBox.shrink()),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                child: new Icon(
                                                    Icons.remove_circle_outline),
                                                onTap: () => setState(() {
                                                  _item.dec();
                                                  _item.updateItem(db);
                                                }),
                                              ),
                                              Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: Text(
                                                '${_item.items}',
                                                textAlign: TextAlign.center,
                                              ),),
                                              GestureDetector(
                                                child: new Icon(
                                                    Icons.add_circle_outline),
                                                onTap: () {
                                                  setState(() {
                                                    _item.inc();
                                                    _item.updateItem(db);
                                                  });
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        );


                        return _select
                            ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Checkbox(
                                      value: _item.selected,
                                      onChanged: (v) {
                                        setState(() {
                                          _item.selected = v;
                                        });
                                      }),
                                  Expanded(child: itx)
                                ],
                              )
                            : itx;
                      },
                    )),
                    onRefresh: loadItems)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    "Sub total: \$${_list.fold(0.0, (v, e) => v + e.total).toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: SizedBox.shrink()),
                  RaisedButton(
                      color: Color(0xffffe707),
                      child: Text("Complete Order"),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      onPressed: () {})
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }
}

class _SearchDelegate extends SearchDelegate{
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [IconButton(
      tooltip: 'Voice Search',
      icon: const Icon(Icons.mic),
      onPressed: () {
        //query = 'TODO: implement voice input';
      },
    )];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(child: Text("To be implemented"),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return buildResults(context);
  }

}