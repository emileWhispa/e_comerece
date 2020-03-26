import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Partial/TouchableOpacity.dart';
import 'SuperBase.dart';

class Authorization extends StatefulWidget {
  final bool login;

  const Authorization({Key key, this.login:true}) : super(key: key);
  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> with SuperBase {
  bool _isLogin = true;
  bool _checked = true;
  bool _signing = false;
  var _formKey = new GlobalKey<FormState>();
  var _phoneController = new TextEditingController();
  var _passwordController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLogin = widget.login;
  }

  void signUp(){
    if(_formKey.currentState?.validate() ?? false){
      setState(() {
        _signing = true;
      });
      this.ajax(url: "login/createUser",method: "POST",map: {
        "account":_phoneController.text,
        "captcha":12,
        "password":_passwordController.text
      },auth: false,server: true,onValue: (source,url){
        print(source);
      },onEnd:
      (){
        setState(() {
          _signing = false;
        });
      });
    }
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
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _phoneController,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Phone number",
                        filled: true,
                        fillColor: Colors.white),
                    validator: (str)=>str.isEmpty ? "Phone number required" : null,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (str)=>str.isEmpty ? "Password field required" : null,
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
                    validator: (str)=>str == _passwordController.text ? null : "Confirm password does not match",
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
                  _signing ? loadBox() : SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      child: Text("SIGN IN"),
                      onPressed: signUp,
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
