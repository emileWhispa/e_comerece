import 'package:e_comerece/Staggered.dart';
import 'package:e_comerece/second_account_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Json/User.dart';
import 'SuperBase.dart';
import 'account_screen.dart';
import 'archive/second_homepage.dart';
import 'cart_page.dart';
import 'discover.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Afrishop',
      theme: ThemeData(primaryColor: Color(0xffffe707), fontFamily: 'Karla'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, SuperBase {
  int _currentTabIndex = 0;
  var _cartState = new GlobalKey<CartScreenState>();
  User _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.signedIn((token, user) => this._addUser(user), () {});
    });
  }

  void _addUser(User user) {
    setState(() {
      _user = user;
      _accountKey.currentState?.populate(user);
    });
  }

  var _accountKey = new GlobalKey<SecondAccountScreenState>();

  List<Widget> get _list => [
        SecondHomepage(cartState: _cartState),
//        Center(
//          child: Text(
//            "DEVELOPING...",
//            style: TextStyle(fontWeight: FontWeight.bold),
//          ),
//        ),
    Discover(),
        CartScreen(user: _user),
        AccountScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: IndexedStack(children: _list,index: _currentTabIndex,),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          iconSize: 18,
          unselectedFontSize: 11,
          selectedFontSize: 11,
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Container(
                    margin: EdgeInsets.only(bottom: 6, top: 3),
                    child: Image.asset(
                        "assets/home${_currentTabIndex == 0 ? "_" : ""}.png",
                        width: 23,
                        fit: BoxFit.fitHeight,
                        height: 23)),
                title: Text("HOME",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            BottomNavigationBarItem(
                icon: Container(
                    margin: EdgeInsets.only(bottom: 6, top: 3),
                    child: Image.asset(
                        "assets/discover${_currentTabIndex == 1 ? "_" : ""}.png",
                        width: 31,
                        fit: BoxFit.fitHeight,
                        height: 23)),
                title: Text(
                  "DISCOVER",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            BottomNavigationBarItem(
                icon: Container(
                    margin: EdgeInsets.only(bottom: 6, top: 3),
                    child: Image.asset(
                        "assets/cart${_currentTabIndex == 2 ? "_" : ""}.png",
                        width: 24,
                        fit: BoxFit.fitHeight,
                        height: 23)),
                title: Text("CART",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            BottomNavigationBarItem(
                icon: Container(
                    margin: EdgeInsets.only(bottom: 6, top: 3),
                    child: Image.asset(
                        "assets/account${_currentTabIndex == 3 ? "_" : ""}.png",
                        width: 23,
                        height: 23)),
                title: Text(
                  "ACCOUNT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ]),
    );
  }
}
