import 'package:e_comerece/old_user_detail.dart';

import 'SuperBase.dart';
import 'old_authorization.dart';
import 'package:e_comerece/Partial/TouchableOpacity.dart';
import 'package:e_comerece/PhoneAuthExample.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SuperBase {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var string = (await prefs).getString("email-ad");
      setState(() {
        _email = string;
      });
    });
  }

  BoxDecoration get _dec => BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.black26),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: 1.0,
                blurRadius: 10.0,
                offset: Offset(10.5, 10.5))
          ]);

  String _email;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _email != null
        ? OldUserDetail(email: _email)
        : Scaffold(
            appBar: AppBar(
              backgroundColor: color,
              leading: Image.asset("assets/afrishop_logo@3x.png",width: 90,),
              title: Text("Cart",style: TextStyle(fontWeight: FontWeight.bold),),
              centerTitle: true,
              elevation: 0.6,
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: _dec,
                        child: Center(
                          child: Icon(
                            FontAwesome.exclamation,
                            size: 70,
                            color: Colors.black26,
                          ),
                        ),
                        height: 150,
                        width: 150,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: _dec,
                          height: 45,
                          width: 45,
                          child: Center(
                            child: Icon(
                              FontAwesome.user,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "You need to login first",
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                CupertinoButton(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Sign up with Phone or Email"),
                  onPressed: () async {
                    var str = await Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) => Authorization()));
                    setState(() {
                      _email = str;
                    });
                  },
                  color: Color(0xffffe707),
                ),
                SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Colors.black26))),
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.black26, fontSize: 19),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Colors.black26))),
                    )),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have account?",
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: InkWell(
                          onTap: () async {
                            var str = await Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (context) => Authorization()));
                            setState(() {
                              _email = str;
                            });
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
