import 'package:e_comerece/inside_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OldCategory extends StatefulWidget{
  @override
  _OldCategoryState createState() => _OldCategoryState();
}

class _OldCategoryState extends State<OldCategory> {
  List<String> get _categories => [
    "Afri Home",
    "Kitchen",
    "Afrishop Accessories",
    "Daily supplies",
    "Personal care",
    "Afri home accessories",
    "Livingroom",
    "Bedroom",
    "Boxes"
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Afrihome",style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(itemCount: _categories.length,itemBuilder: (context,index){
        return InkWell(
          onTap: (){
            Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>InsideCategory()));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 3),
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: Text("${_categories[index]}",style: TextStyle(fontWeight: FontWeight.bold),)),
                Container(height: 100,width: 100,child: Stack(
                  children: <Widget>[
                    Image(image: AssetImage("assets/imag1.jpg"),height: 100,width: 100,fit: BoxFit.cover,),
                    Positioned(child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.transparent,
                            Colors.transparent
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      ),
                    ))
                  ],
                ))
              ],
            ),
          ),
        );
      }),
    );
  }
}