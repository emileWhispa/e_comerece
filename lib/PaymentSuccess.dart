import 'dart:async';

import 'package:e_comerece/PaymentScreen.dart';
import 'package:e_comerece/pending_cart.dart';
import 'package:e_comerece/pending_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Json/Cart.dart';
import 'Json/User.dart';

class PaymentSuccess extends StatefulWidget{
  final User user;
  final Cart cart;

  const PaymentSuccess({Key key,@required this.user,@required this.cart}) : super(key: key);
  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Timer(Duration(seconds: 5), (){
        Navigator.of(context).pushReplacement(CupertinoPageRoute(fullscreenDialog: true,builder: (context)=>PendingPayment(user: widget.user,cart: widget.cart,)));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check_circle,size: 70,color: Colors.green,),
            SizedBox(height: 15,),
            Text("Payment is successfully done",style: TextStyle(color: Colors.green),)
          ],
        ),
      ),
    );
  }
}