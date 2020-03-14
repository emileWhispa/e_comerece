import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Partial/TouchableOpacity.dart';

class Authorization extends StatefulWidget {
  final bool login;

  const Authorization({Key key, this.login:true}) : super(key: key);
  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  bool _isLogin = true;
  bool _checked = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLogin = widget.login;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffefeeee),
      body: ListView(
        children: <Widget>[
          Container(
            height: 270,
            width: double.infinity,
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                Navigator.pop(context);
              }),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage("assets/image.jpg"))),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Spacer(),
              FlatButton(onPressed: () {
                setState(() {
                  _isLogin = true;
                });
              }, child: Text("SIGN IN"),color: _isLogin ? Color(0xffffe707) : null,),
              FlatButton(onPressed: () {
                setState(() {
                  _isLogin = false;
                });
              }, child: Text("SIGN UP"),color: !_isLogin ? Color(0xffffe707) : null,),
              Spacer(),
            ],
          ),
          _isLogin ? Form(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: Icon(Icons.remove_red_eye)),
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
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Login with mobile number",
                      ),
                      TouchableOpacity(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Continue",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ))
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      child: Text("SIGN IN"),
                      onPressed: () {},
                      color: Color(0xffffe707),
                    ),
                  )
                ],
              ),
            ),
          ) :
          Form(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Phone number",
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Username",
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: Icon(Icons.remove_red_eye)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Confirm password",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: Icon(Icons.remove_red_eye)),
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
                          "Terms and conditions",
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
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(value: _checked, onChanged: (v){
                        setState(() {
                          _checked = v;
                        });
                      },),
                      Expanded(child: Text(
                        "Terms of service are the legal agreements between a service provider and a person who wants to use that service. The person must agree to abide by the terms of service in order to use the offered service.",
                      )),
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      child: Text("SIGN IN"),
                      onPressed: () {},
                      color: Color(0xffffe707),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
