import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'Json/User.dart';


class SuperBase {
  String server = "http://165.22.82.105:8080/";
  String server0 = "http://172.20.10.13:8080/afri_shop/";
  String socket = "ws://172.20.10.13:8080/afri_shop/";
  String jwtKey = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsidGVzdGp3dHJlc291cmNlaWQiXSwidXNlcl9uYW1lIjoiV2hpc3BhIiwic2NvcGUiOlsicmVhZCIsIndyaXRlIl0sImV4cCI6MTU4NjgwNjM0OCwiYXV0aG9yaXRpZXMiOlsiU1RBTkRBUkRfVVNFUiJdLCJqdGkiOiJiOTI3ZTcwNi0yOGNiLTRmN2MtYWEwNS00N2JkNjYxZDg1ZDAiLCJjbGllbnRfaWQiOiJ3aGlzcGFqd3RjbGllbnRpZCJ9.cqBA3timG1yf8Q5wRVKyYlpwu2omdr2chgnLbzpyqh8';
  String idKeyUser = 'id-user-data-BASE64-key-123';
  String idKey = 'user-id-23';
  String jwt = '';

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  var platform = MethodChannel('app.channel.shared.data');
  ImageProvider def = AssetImage(
    'assets/boys.jpg',
  );
  Widget defImg = Image.asset(
    "assets/boys.jpg",
    fit: BoxFit.cover,
  );
  AssetBundleImageProvider asset = AssetImage("assets/back.jpg");
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  Color color = Color(0xffffe707);

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  String url(String url) {
    return this.server + url;
  }

  void reqFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<Database> getDatabase() async {
    return openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'messages-contact.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.db.
        return db.execute(
            "CREATE TABLE cart(id INTEGER NOT NULL UNIQUE,items int,count int,title TEXT,price double,url TEXT,color TEXT,size TEXT)");
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }


  String fmt(String test){
    return test.replaceAllMapped(reg, mathFunc);
  }

  String fmtNbr(num test){
    return fmt(test.toString());
  }


  final scope = const <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/drive',
  ];

  final contactScope = const <String>[];

  void fetchPermImage({@required Function fn}) async {
    PermissionStatus status =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    if (status == PermissionStatus.granted)
      fn();
    else {
      await requestPermissionImage();
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.photos);
      if (status == PermissionStatus.granted) fn();
    }
  }


  Future<File> writeToGallery(File file) async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory.path}/AFRIX';
    final myImgDir = await new Directory(myImagePath).create();
    var _file = new File("${myImgDir.path}/$unique${getName(file)}");
    _file.writeAsBytesSync(file.readAsBytesSync());
    return _file;
  }

  String getName(File file) {
    return getBaseName(file.path);
  }

  String getBaseName(String path){
    return basename(path);
  }

  String get unique => "${DateTime
      .now()
      .millisecondsSinceEpoch}${Uuid().v4()}";



  double log10(num x) => log(x) / ln10;

  String readableFileSize(int size) {
    if (size <= 0) return "0";
    final List<String> units = ["B", "kB", "MB", "GB", "TB"];
    int digitGroups = (log10(size) ~/ log10(1024)).toInt();
    return new NumberFormat("#,##0.#").format(size / pow(1024, digitGroups)) +
        " " + units[digitGroups];
  }



  void signedIn(void Function(String token, User user) function,void Function() not) {
    prefs.then((SharedPreferences prf) {
      String b = prf.get(jwtKey);
      String v = prf.get(idKeyUser);

      if (v != null) {
        Map<String, dynamic> _map = json.decode(v);
        function(b, User.fromJson(_map));
      } else
        not();
    });
  }

  void auth(String jwt, String user, String id) {
    prefs.then((SharedPreferences prf) {
      if (jwt != null) prf.setString(jwtKey, jwt);
      if (user != null) prf.setString(idKeyUser, user);
      if (id != null) prf.setString(idKey, id);
    });
  }

  void showSnack({@required String s,
    @required BuildContext context,
    MaterialColor color}) {
    print("$s");
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(s),
      backgroundColor: color != null ? color : Colors.blue,
    ));
  }

  void clear(Function() fn) {
    prefs.then((SharedPreferences prf) {
      prf.clear().then((bool v) {
        if (v) fn();
      });
    });
  }

  Map<String, String> map(String jwt, String id) {
    Map<String, String> headers = new Map<String, String>();
    //headers['secret'] = widget.keyCode;
    headers['tokenKey'] = jwt;
    headers['userId'] = id;

    return headers;
  }

  Widget icon({Color color: Colors.blue, bool deliver: true, bool sent: true}) {
    return Icon(
      deliver
          ? Icons.done_all
          : sent ? Icons.done : MaterialCommunityIcons.progress_clock,
      size: 14,
      color: color,
    );
  }

  Future<Map<PermissionGroup, PermissionStatus>> requestPermission() async {
    return await PermissionHandler()
        .requestPermissions([PermissionGroup.contacts]);
  }


  Future<
      Map<PermissionGroup, PermissionStatus>> requestPermissionImage() async {
    return await PermissionHandler()
        .requestPermissions([PermissionGroup.photos]);
  }

  fetchPerm({@required Function fn}) async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (status == PermissionStatus.granted)
      await fn();
    else {
      await requestPermission();
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.contacts);
      if (status == PermissionStatus.granted) await fn();
    }
  }

  Widget loader({String text}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(text != null ? text : "Loading response ..."),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Center(
            child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(strokeWidth: 3)),
          ),
        )
      ],
    );
  }

  Widget record({Color color: Colors.green}) {
    return Text(
      "recording audio ...",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontStyle: FontStyle.italic),
    );
  }

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> localFile(String name) async {
    final path = await localPath;
    return File('$path/$name');
  }

  Widget typing(TickerProvider ticker, {Color color: Colors.green}) {
    return Text(
      "typing ...",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontStyle: FontStyle.italic),
    );
  }

  String printDuration(Duration duration) {
    if (duration == null) return "";
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String get registered => "get/numbers/";
  String get statusListQ => "save/statues/data/list/";


  Widget loadBox({Color color: Colors.red, Color bColor: Colors
      .white, double size: 20, double width: 3}) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        backgroundColor: bColor,
        strokeWidth: width,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  void save(String key, dynamic val) async {
    this.saveVal(key, jsonEncode(val));
  }



  bool canDecode(String jsonString) {
    var decodeSucceeded = false;
    try {
      json.decode(jsonString);
      decodeSucceeded = true;
    } on FormatException {}
    return decodeSucceeded;
  }

  Future<void> ajax({@required String url,
    String method: "GET",
    FormData data,
    Map<String,dynamic> map,
    bool server: false,
    bool auth: true,
    bool local: false,
    bool json: true,
    bool absolutePath: false,
    bool localSave: false,
    void Function(String response, String url) onValue,
    void Function() onEnd,
    void Function(String response, String url) error}) async {
    url = absolutePath ? url : this.url(url);

    Map<String, String> headers = new Map<String, String>();

    var prf = await prefs;
    if (auth) {
      headers['Authorization'] = jwtKey;
    }

    Options opt = Options(
        responseType: ResponseType.plain,
        headers: headers,
        receiveDataWhenStatusError: true,
        sendTimeout: 30000,
        receiveTimeout: 30000);

    if (!server) {
      String val = prf.get(url);
      bool t = onValue != null && val != null;
      local = local && t;
      localSave = localSave && t;
      var c = (t && json && canDecode(val)) || !json;
      t = t && c;
      if (t) onValue(val, url);
    }

    if (local) {
      if (onEnd != null) onEnd();
      return Future.value();
    }

    Future<Response> future = method.toUpperCase() == "POST"
        ? Dio().post(url, data: map ?? data, options: opt)
        : Dio().get(url, options: opt);

    try {
      Response response = await future;
      String data = response.data.toString();
      if (response.statusCode == 200) {
        var cond = (json && canDecode(data)) || !json;
        if (cond) this.saveVal(url, data);

        if (onValue != null && !localSave && cond)
          onValue(response.data.toString(), url);
        else if (error != null) error(data, url);
      } else if (error != null) {
        error(data, url);
      }
    } on DioError catch (e) {
      //if (e.response != null) {
      String resp = e.response != null ? e.response.data.toString() : e.message;
      if (error != null) error(resp, url);
      //}
    }

    if (onEnd != null) onEnd();
    return Future.value();
  }

  saveVal(String key, String value) {
    prefs.then((SharedPreferences val) => val.setString(key, value));
  }
}
