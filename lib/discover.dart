import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class Discover extends StatefulWidget{
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        leading: Icon(AntDesign.user),
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Expanded(child: Text("Following",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
            Expanded(child: Text("Recommended",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
          ],
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){})
        ],
      ),
    );
  }
}