import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_comerece/Json/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

import 'SuperBase.dart';

class UserProfile extends StatefulWidget {
  final String firebaseId;
  final String password;
  final String country;
  final String mobile;
  final User user;
  final VoidCallback callback;

  const UserProfile(
      {Key key, @required this.firebaseId, this.password, this.country, this.mobile, this.user, this.callback})
      : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with SuperBase {
  String _mobile;
  String _email;
  String _nickname;
  String _gender;
  String _date;
  bool _saving = false;

  @override
  void initState(){
    super.initState();
    var _user = widget.user;
    if( _user != null ){
      _mobile = _user.phone;
      _gender = _user.gender;
      _nickname = _user.username;
      _email = _user.email;
      _date = _user.birthDay;
    }else{
      _mobile = widget.mobile;
    }
  }

  void saveUser() {
    setState(() {
      _saving = true;
    });
    this.ajax(
        url: "registerUser",
        method: "POST",
        server: true,
        data: FormData.from({
          "email": _email,
          "gender": _gender,
          "birthDate": _date == null ? null : DateFormat("MM/dd/yyyy").format(DateTime.parse(_date)),
          "firebase": widget.firebaseId,
          "username": _nickname,
          "country": widget.country,
          "mobile": _mobile,
          "password": widget.password
        }),
        onValue: (source, url) {
          User user = User.fromJson(json.decode(source));
          this.auth(jwt, source, '${user.id}');
          Navigator.of(context).pop(user);
        },
        onEnd: () {
          setState(() {
            _saving = false;
          });
        });
  }

  Future<String> showValueChoose(
      {String hint, Widget Function(BuildContext context) widget}) async {
    return showModalBottomSheet<String>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return _ValueChoose(
            hint: hint,
            widget: widget,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var style = TextStyle(fontSize: 15);
    var decoration = BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.39))));
    var padding = EdgeInsets.all(10);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2.0,
        actions: <Widget>[
          widget.callback == null ? SizedBox.shrink() : IconButton(icon: Icon(AntDesign.logout), onPressed: (){
            Navigator.pop(context);
            widget.callback();
          }) ,
          _saving
              ? IconButton(icon: loadBox(), onPressed: null)
              : FlatButton(onPressed: saveUser, child: Text("Save"))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 15),
        children: <Widget>[
          Container(
            padding: padding,
            decoration: decoration,
            child: Row(
              children: <Widget>[
                Text(
                  "Avatar",
                  style: style,
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: CircleAvatar(
                    radius: 18,
                  ),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
          Container(
            padding: padding,
            decoration: decoration,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Account",
                    style: style,
                  ),
                ),
                Spacer(),
                Text(
                  "$_mobile",
                  style: style,
                ),
              ],
            ),
          ),
          Container(
            padding: padding,
            decoration: decoration,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Country",
                    style: style,
                  ),
                ),
                Spacer(),
                Text(
                  "RWANDA",
                  style: style,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
            },
            child: Container(
              padding: padding,
              decoration: decoration,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Mobile",
                      style: style,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _mobile ?? "Set mobile",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              String string =
                  await showValueChoose(hint: "Enter email address");
              setState(() {
                _email = string ?? _email;
              });
            },
            child: Container(
              padding: padding,
              decoration: decoration,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Email",
                      style: style,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _email ?? "Set email",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          InkWell(
            onTap: () async {
              String string = await showValueChoose(hint: "Enter Nickname");
              setState(() {
                _nickname = string ?? _nickname;
              });
            },
            child: Container(
              padding: padding,
              decoration: decoration,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Nickname",
                      style: style,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _nickname ?? "Set nickname",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              String string = await showValueChoose(widget: (context) {
                return Column(
                  children: <Widget>[
                    RadioListTile<String>(
                      value: "male",
                      groupValue: _gender,
                      onChanged: (v) {
                        Navigator.of(context).pop(v);
                      },
                      title: Text("Male"),
                      subtitle: Text("Select"),
                    ),
                    RadioListTile<String>(
                      value: "female",
                      groupValue: _gender,
                      onChanged: (v) {
                        Navigator.of(context).pop(v);
                      },
                      title: Text("Female"),
                      subtitle: Text("Select"),
                    ),
                  ],
                );
              });
              setState(() {
                _gender = string ?? _gender;
              });
            },
            child: Container(
              padding: padding,
              decoration: decoration,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Gender",
                      style: style,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _gender ?? "Select",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950, 8),
                lastDate: DateTime.now(),
              );
              setState(() {
                _date = picked?.toString() ?? _date;
              });
            },
            child: Container(
              padding: padding,
              decoration: decoration,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Birthday",
                      style: style,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _date ?? "Select",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: padding,
            decoration: decoration,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Friend's code",
                    style: style,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: padding,
            decoration: decoration,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Settings",
                    style: style,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueChoose extends StatefulWidget {
  final String hint;
  final Widget Function(BuildContext context) widget;

  const _ValueChoose({Key key, this.hint, this.widget}) : super(key: key);

  @override
  __ValueChooseState createState() => __ValueChooseState();
}

class __ValueChooseState extends State<_ValueChoose> {
  var _controller = new TextEditingController();

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
      child: widget.widget == null
          ? Column(
              children: <Widget>[
                TextFormField(
                  controller: _controller,
                  decoration:
                      InputDecoration(hintText: widget.hint ?? "Enter text"),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_controller.text);
                  },
                  child: Text("Confirm"),
                )
              ],
            )
          : widget.widget(context),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  Widget _date(BuildContext context, TextStyle valueStyle) => _InputDropdown(
        labelText: labelText,
        valueText: DateFormat.yMMMd().format(selectedDate),
        valueStyle: valueStyle,
        onPressed: () {
          _selectDate(context);
        },
      );

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return selectedTime == null
        ? _date(context, valueStyle)
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: _date(context, valueStyle),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                flex: 3,
                child: _InputDropdown(
                  valueText: selectedTime.format(context),
                  valueStyle: valueStyle,
                  onPressed: () {
                    _selectTime(context);
                  },
                ),
              ),
            ],
          );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
