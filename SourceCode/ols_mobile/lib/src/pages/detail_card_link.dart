import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/widgets/header.dart';

class DetailCardLink extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailCardLinkState();
  }
}

class DetailCardLinkState extends State<DetailCardLink> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(title: FlutterI18n.translate(context, "detailCardLink.header"), body: content(context));
  }

  Widget content(context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setSp(20),
              left: ScreenUtil().setSp(20),
              right: ScreenUtil().setSp(20),
              bottom: ScreenUtil().setSp(15),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 0),
                  )
                ]),
            child: Column(
              children: <Widget>[
                Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
//                    top: ScreenUtil().setSp(5),
                    left: ScreenUtil().setSp(18),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Color(0xFFE7E7E7),
                    width: 1,
                  ))),
                  child: Image.asset(
                    'assets/images/ic_techcombank.png',
                    width: ScreenUtil().setSp(55),
                    height: ScreenUtil().setSp(55),
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setSp(27),
                    left: ScreenUtil().setSp(18),
                    right: ScreenUtil().setSp(18),
                    bottom: ScreenUtil().setSp(17),
                  ),
                  child: Column(
                    children: <Widget>[
                      rowItem(FlutterI18n.translate(context, 'detailCardLink.cardType'), 'ATM'),
                      rowItem(FlutterI18n.translate(context, 'detailCardLink.numberCard'), '**** **** **** **95'),
                      rowItem(FlutterI18n.translate(context, 'detailCardLink.status'), 'Đã liên kết'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          footer()
        ],
      ),
    );
  }

  Widget rowItem(left, right) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setSp(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(left),
            margin: EdgeInsets.only(right: ScreenUtil().setSp(50)),
          ),
          Expanded(
              child: Text(
            right,
            maxLines: 2,
            textAlign: TextAlign.end,
          )),
        ],
      ),
    );
  }

  Widget footer() {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => _showMaterialDialog(),
      child: Container(
        width: width,
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          bottom: ScreenUtil().setHeight(17),
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
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: Text(
          FlutterI18n.translate(context, 'detailCardLink.unLink'),
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _showMaterialDialog() {
    final width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
            ),
            child: Wrap(
              children: <Widget>[
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
                  ),
                  padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                  child: Column(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(context, 'detailCardLink.headerModal'),
                        style: TextStyle(
                            color: Color(0xFF343434),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setSp(20),
                            bottom: ScreenUtil().setSp(20),
                          ),
                          child: Text(
                            FlutterI18n.translate(context, 'detailCardLink.titleModal'),
                            style: TextStyle(color: Color(0xff696969)),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          raiseButton(
                              FlutterI18n.translate(context, 'detailCardLink.no'), Color(0xffEAEAEA), Color(0xFF696969)),
                          raiseButton(
                              FlutterI18n.translate(context, 'detailCardLink.yes'), Color(0xFFFD4435), Colors.white),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget raiseButton(text, backgroundColor, textColor) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // To close the dialog
      },
      child: Container(
        padding: EdgeInsets.only(
          top: ScreenUtil().setSp(10),
          bottom: ScreenUtil().setSp(10),
          left: ScreenUtil().setSp(15),
          right: ScreenUtil().setSp(15),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
            color: backgroundColor),
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
