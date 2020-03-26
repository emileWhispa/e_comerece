import 'package:e_comerece/Staggered.dart';
import 'package:e_comerece/second_homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_screen.dart';
import 'cart_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afrishop',
      theme: ThemeData(primaryColor: Color(0xffffe707)),
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  var _cartState = new GlobalKey<CartScreenState>();

  @override
  void initState(){
    super.initState();
  }

  List<Widget> get _list => [
        SecondHomepage(cartState: _cartState,),
    //    Center(child: Text("DEVELOPING...",style: TextStyle(fontWeight: FontWeight.bold),),),
    Staggered(),
    CartScreen(key: _cartState,),
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
          iconSize: 18,
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Image.asset("assets/home_logo.png",width: 19,height: 19), title: Text("HOME")),
            BottomNavigationBarItem(
                icon: Image.asset("assets/discover.png",width: 21,height: 21), title: Text("DISCOVER")),
            BottomNavigationBarItem(
                icon: Image.asset("assets/cart_logo.png",width: 19,height: 19), title: Text("CART")),
            BottomNavigationBarItem(
                icon: Image.asset("assets/account.png",width: 19,height: 19), title: Text("ACCOUNT")),
          ]),
    );
  }
}
