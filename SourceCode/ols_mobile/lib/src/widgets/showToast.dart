import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Toast {
  Toast({this.title, this.context });
  final context;
  String title;

  showToast(){
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5.0,
                // has the effect of softening the shadow
                spreadRadius: 5.0,
                offset: new Offset(0.0, 0.0),
              )
            ]),
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/ic_correct.png', width: 24, height: 24),
            Container(
              child: Text(title, style: TextStyle(color: Colors.black)),
              margin: EdgeInsets.only(left: 15),
            )
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    ));
  }
}
