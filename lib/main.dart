import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'account_screen.dart';
import 'cart_page.dart';
import 'category_page.dart';
import 'homepage.dart';

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

  @override
  void initState(){
    super.initState();
  }

  List<Widget> get _list => [
        Homepage(
          callback: (item) {
            setState(() {
              _currentTabIndex = 1;
            });
          },
        ),
        CategoryScreen(),
        CartScreen(),
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
                icon: Icon(FontAwesome.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(FontAwesome.globe), title: Text("Discover")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text("Cart")),
            BottomNavigationBarItem(
                icon: Icon(AntDesign.user), title: Text("Account")),
          ]),
    );
  }
}
