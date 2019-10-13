import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/widgets/header.dart';

class AddAccountLink extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddAccountLinkState();
  }
}

class AddAccountLinkState extends State<AddAccountLink> {
  TextEditingController id = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      title: FlutterI18n.translate(context, "addAccountLinked.header"),
      body: content(context),
    );
  }

  Widget content(context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        color: Colors.grey[100],
        width: width,
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(13),
                  right: ScreenUtil().setWidth(10),
                  top: ScreenUtil().setHeight(15),
                  bottom: ScreenUtil().setHeight(15),
                ),
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(15),
                  top: ScreenUtil().setHeight(20),
                  left: ScreenUtil().setHeight(15),
                  right: ScreenUtil().setHeight(15),
                ),
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFE7E7E7), width: 1),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: Text(FlutterI18n.translate(context, "addAccountLinked.selectPartner"))),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 30,
                      color: Color(0xff9B9B9B),
                    )
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(13),
                  right: ScreenUtil().setWidth(10),
                ),
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(15),
                  left: ScreenUtil().setHeight(15),
                  right: ScreenUtil().setHeight(15),
                ),
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFE7E7E7), width: 1),
                    borderRadius: BorderRadius.circular(4)),
                child: TextField(
                  controller: id,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: ScreenUtil().setHeight(15),
                          bottom: ScreenUtil().setHeight(15)),
                      labelText: FlutterI18n.translate(context, "addAccountLinked.enterId"),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: InputBorder.none),
                )),
            Spacer(),
            _footer(context)
          ],
        ),
      ),
    );
  }

  Widget _footer(context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          blurRadius: 3.0,
          spreadRadius: 1.0,
          offset: new Offset(0.0, -3.0),
        )
      ]),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: width,
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20),
            bottom: ScreenUtil().setHeight(17),
            top: ScreenUtil().setHeight(17),
          ),
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setHeight(12),
            top: ScreenUtil().setHeight(12),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF0A4DD0),
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFFFF483D), const Color(0xFFF42E13)],
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          child: Text(
            FlutterI18n.translate(context, "addAccountLinked.continue"),
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
