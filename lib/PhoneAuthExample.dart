import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_comerece/Json/User.dart';
import 'package:e_comerece/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'SuperBase.dart';

class PhoneAuthExample extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool login;
  final void Function(User user) onLog;

  const PhoneAuthExample(
      {Key key, @required this.scaffoldKey, this.login: false, this.onLog})
      : super(key: key);

  @override
  _PhoneAuthExampleState createState() => _PhoneAuthExampleState();
}

class _PhoneAuthExampleState extends State<PhoneAuthExample> with SuperBase {
  var phoneNumController = new TextEditingController();
  var _passwordController = new TextEditingController();

  /// will get an AuthCredential object that will help with logging into Firebase.
  void _verificationComplete(AuthCredential authCredential) {
    FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((authResult) async {
      if (!widget.login) {
        setState(() {
          _loading = false;
        });
        var text = "Success!!! UUID is: " + authResult.user.uid;
        var user = await Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => UserProfile(
                  firebaseId: authResult.user.uid,
                  country: _selected?.name,
                  password: _passwordController.text,
                  mobile: phoneNumber
                )));
        if (user != null) {
          if( widget.onLog != null ) widget.onLog(user);
        }
        final snackBar = SnackBar(content: Text(text));
        showSnackBar(snackBar);
      } else {
        this.ajax(
            url: "signIn",
            method: "POST",
            server: true,
            data: FormData.from(
                {"mobile": phoneNumber, "firebase": authResult.user.uid}),
            onValue: (source, url) {
              User user = User.fromJson(json.decode(source));
              if (user != null) {
                this.auth(jwt, source, '${user.id}');
                if( widget.onLog != null ) widget.onLog(user);
              }
            },
            error: (s, v) {
              final snackBar =
                  SnackBar(content: Text("Wrong phone number or password"));
              showSnackBar(snackBar);
            },
            onEnd: () {
              setState(() {
                _loading = false;
              });
            });
      }
    }).catchError((v) {
      setState(() {
        _loading = false;
      });
    });
  }

  void _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    //openModal(verificationId);

    setState(() {
      _loading = false;
      _verify = true;
      _verificationId = verificationId;
      _count = 60;
    });
    showSnackBar(SnackBar(content: Text(verificationId)));

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted && _count <= 0) {
        setState(() {
          _verify = false;
        });
      } else if (mounted) {
        setState(() {
          _count = _count - 1;
        });
      } else if (_count <= 0) {
        timer.cancel();
      }
    });
  }

  void openModal(String verificationId) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return _VerificationWidget(
            verificationId: verificationId,
            callback: _verificationComplete,
          );
        });
  }

  void _verificationFailed(AuthException authException, BuildContext context) {
    var text = authException.message.toString();
    print("Exception");
    final snackBar = SnackBar(content: Text(text));
    showSnackBar(snackBar);
    print(text);
    setState(() {
      _loading = false;
      _verify = false;
    });
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user ins
    print("Exception");
    showSnackBar(SnackBar(content: Text('time out $verificationId')));
    setState(() {
      _loading = false;
      _verify = true;
    });
  }

  int _count = 0;

  var _loading = false;
  var _verify = false;
  var _code = "";

  String get phoneNumber =>
      "+${_selected.dialingCode}${phoneNumController.text}";

  var _verificationId;

  void _inputCode() {
    var _credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _code);
    setState(() {
      _loading = true;
    });
    _verificationComplete(_credential);
  }

  void _verifyPhoneNumber(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final FirebaseAuth _auth = FirebaseAuth.instance;
    setState(() {
      _loading = true;
    });
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 5),
        verificationCompleted: (authCredential) =>
            _verificationComplete(authCredential),
        verificationFailed: (authException) =>
            _verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code]));
  }

  void showSnackBar(SnackBar snackBar) {
    widget.scaffoldKey?.currentState?.showSnackBar(snackBar);
  }

  Country _selected = Country.RW;

  var _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 125),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/boys.jpg"),
                ),
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: phoneNumController,
                keyboardType: TextInputType.phone,
                validator: (str) =>
                    str.isEmpty ? "Phone number field required" : null,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    filled: true,
                    fillColor: Color(0xffefeeee),
                    hintText: "Phone Number",
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: CountryPicker(
                        dense: false,
                        showFlag: true,
                        showName: false,
                        //displays country name, true by default
                        onChanged: (Country country) =>
                            setState(() => _selected = country),
                        selectedCountry: _selected,
                      ),
                    ),
                    prefixText: '+${_selected.dialingCode}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    )),
              ),
              SizedBox(height: 15),
              _verify
                  ? Row(
                      children: <Widget>[
                        Expanded(
                            child: PinCodeTextField(
                          maxLength: 6,
                          pinBoxOuterPadding: EdgeInsets.all(4),
                          pinBoxColor: Colors.black12,
                          pinBoxRadius: 50,
                          pinBoxBorderWidth: 1.2,
                          defaultBorderColor: Colors.black12,
                          wrapAlignment: WrapAlignment.spaceBetween,
                          pinBoxHeight: 30,
                          pinBoxWidth: 30,
                          onTextChanged: (text) {
                            setState(() {
                              _code = text;
                            });
                          },
                        )),
                        _count > 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "$_count seconds",
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 15),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RaisedButton(
                      color: color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.all(15),
                      child: Text(widget.login
                          ? "SIGN IN"
                          : _verify ? "Verfiy" : "SEND CODE"),
                      onPressed: _verify
                          ? _inputCode
                          : () => _verifyPhoneNumber(context),
                    ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                      child: IconButton(
                          icon: Icon(AntDesign.facebook_square),
                          onPressed: () {})),
                  Expanded(
                      child: IconButton(
                          icon: Icon(AntDesign.google), onPressed: () {})),
                  Expanded(
                      child: IconButton(
                          icon: Icon(AntDesign.twitter), onPressed: () {})),
                  Expanded(
                      child: IconButton(
                          icon: Icon(AntDesign.linkedin_square),
                          onPressed: () {})),
                ],
              )
            ], // Widget
          ),
        ));
  }
}

class _VerificationWidget extends StatefulWidget {
  final String verificationId;
  final void Function(AuthCredential authCredential) callback;

  const _VerificationWidget(
      {Key key, @required this.verificationId, @required this.callback})
      : super(key: key);

  @override
  __VerificationWidgetState createState() => __VerificationWidgetState();
}

class __VerificationWidgetState extends State<_VerificationWidget> {
  var _controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void verify() {
    var smsCode = _controller.text.trim();
    var _credential = PhoneAuthProvider.getCredential(
        verificationId: widget.verificationId, smsCode: smsCode);
    Navigator.of(context).pop();
    widget.callback(_credential);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
                labelText: "Verify sent Code",
                prefixText: "code(6)",
                border: OutlineInputBorder()),
          ),
          SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: verify,
                child: Text("Verify"),
              )),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
