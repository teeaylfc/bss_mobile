import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/pages/infomation_card.dart';
import 'package:bss_mobile/src/widgets/header.dart';

// ignore: must_be_immutable
class Condition extends StatefulWidget {
  Condition({this.bank});

  var bank;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ConditionContent();
  }
}

class ConditionContent extends State<Condition> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      body: content(context),
      title: FlutterI18n.translate(context, "associateCondition.associateCondition"),
    );
  }

  Widget content(context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Container(
            width: width,
            margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(25),
              right: ScreenUtil().setWidth(25),
              top: ScreenUtil().setHeight(10),
              bottom: ScreenUtil().setWidth(50),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Colors.grey[300],
                      offset: Offset(0, 0))
                ]),
            child: Column(
              children: <Widget>[
                Image.asset(
                  widget.bank['image'],
                  width: ScreenUtil().setWidth(90),
                  height: ScreenUtil().setHeight(71),
                  fit: BoxFit.contain,
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(10),
                      bottom: ScreenUtil().setHeight(10)),
                  child: Text(
                    FlutterI18n.translate(context, "associateCondition.header"),
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                rowContent(
                    FlutterI18n.translate(context, "associateCondition.condition_1", {"name": widget.bank['name']})),
                rowContent(
                    FlutterI18n.translate(context, "associateCondition.condition_2", {"name": widget.bank['name']})),
              ],
            ),
          ),
          Spacer(),
          _footer(context)
        ],
      ),
    );
  }

  Widget rowContent(text) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(10),
        bottom: ScreenUtil().setWidth(10),
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: Image.asset(
              'assets/images/ic_correct2.png',
              width: ScreenUtil().setWidth(22),
              height: ScreenUtil().setHeight(22),
              fit: BoxFit.contain,
            ),
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(10),
            ),
          ),
          Expanded(child: Text(text))
        ],
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
            // has the effect of softening the shadow
            spreadRadius: 1.0,
            offset: new Offset(0.0, -3.0),
          )
        ]),
        child: GestureDetector(
          onTap: () => _onNextScreens(context),
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
              FlutterI18n.translate(context, "associateCondition.linkNow"),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ));
  }

  _onNextScreens(context) {
    var route = new MaterialPageRoute(builder: (context) => InfomationCard());
    Navigator.push(context, route);
  }
}
