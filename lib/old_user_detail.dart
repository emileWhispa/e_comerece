import 'package:e_comerece/Coupon.dart';
import 'package:e_comerece/Json/User.dart';
import 'package:e_comerece/pending_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'SuperBase.dart';

class OldUserDetail extends StatefulWidget{
  final String email;

  const OldUserDetail({Key key, this.email}) : super(key: key);
  @override
  _OldUserDetailState createState() => _OldUserDetailState();
}

class _OldUserDetailState extends State<OldUserDetail> with SuperBase {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        leading: Image.asset("assets/afrishop_logo@3x.png",width: 70,),
        title: Text("Account",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
            child: Row(
              children: <Widget>[
                Expanded(child: Text( widget.email ?? "Email address")),
                IconButton(icon: Icon(Icons.edit), onPressed: (){})
              ],
            ),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context)=>PendingCart(user: User(1, "freb", "28/09/2000", "WHispa", "0787621709"))));
            },
            leading: Icon(Icons.reorder,color: color,),
            title: Text("My orders"),
          ),
          ListTile(
            leading: Icon(Icons.favorite,color: color,),
            title: Text("Favorites"),
          ),
          ListTile(
            leading: Icon(FontAwesome.address_book,color: color,),
            title: Text("Address"),
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>Coupon()));
            },
            leading: Icon(Icons.reorder,color: color,),
            title: Text("Coupons"),
          ),
          ListTile(
            leading: Icon(FontAwesome.support,color: color,),
            title: Text("Support"),
          ),
        ],
      ),
    );
  }
}