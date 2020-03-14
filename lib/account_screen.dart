import 'package:e_comerece/Authorization.dart';
import 'package:e_comerece/Partial/TouchableOpacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
            child: Text("Sign up with Phone or Email"),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>Authorization(login: false,)));
            },
            color: Color(0xffffe707),
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black26))),
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
                    border: Border(top: BorderSide(color: Colors.black26))),
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
              TouchableOpacity(
                onTap: (){
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>Authorization()));
                },
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
