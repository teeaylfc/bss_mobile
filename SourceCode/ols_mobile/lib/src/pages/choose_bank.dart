import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/condition.dart';
import 'package:ols_mobile/src/widgets/header.dart';

class ChooseBank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      title: FlutterI18n.translate(context, "chooseBank.chooseBank"),
      body: ChooseBankContent(),
    );
  }
}

class ChooseBankContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChooseBankContentState();
  }
}

class ChooseBankContentState extends State<ChooseBankContent> {
  List listBank = [
    {
      "id": 1,
      "name": "HDBank",
      "image": "assets/images/ic_HDBank.png",
    },
    {
      "id": 2,
      "name": "ShinHanBank",
      "image": "assets/images/ic_shinhanbank.png",
    },
    {
      "id": 3,
      "name": "TechcomBank",
      "image": "assets/images/ic_techcombank.png",
    },
    {
      "id": 4,
      "name": "VietcomBank",
      "image": "assets/images/ic_vietcombank.png",
    },
    {
      "id": 5,
      "name": "HDBank",
      "image": "assets/images/ic_HDBank.png",
    },
    {
      "id": 6,
      "name": "TechComBank",
      "image": "assets/images/ic_techcombank.png",
    },
    {
      "id": 7,
      "name": "ShinHanBank",
      "image": "assets/images/ic_shinhanbank.png",
    },
    {
      "id": 8,
      "name": "VietcomBank",
      "image": "assets/images/ic_vietcombank.png",
    },
  ];
  List listPay = [
    {
      "id": 9,
      "name": "HDBank",
      "image": "assets/images/ic_HDBank.png",
    },
    {
      "id": 10,
      "name": "ShinHanBank",
      "image": "assets/images/ic_shinhanbank.png",
    },
    {
      "id": 11,
      "name": "TechComBank",
      "image": "assets/images/ic_techcombank.png",
    },
  ];
  var visibleBtn = false;
  var itemChoose;
  TextEditingController txtSearch = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        width: width,
        color: Colors.grey[100],
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // tìm kiếm
                Container(
                  width: width * 0.7,
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFE7E7E7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'assets/images/ic_search.png',
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                          color: Color(0xFF696969),
                        ),
                        margin: EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                        child: TextField(
                          controller: txtSearch,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF696969),
                          ),
                          decoration: InputDecoration(
                            hintText: FlutterI18n.translate(context, "chooseBank.searchBank"),
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                //ngân hàng liên kết
                Container(
                  width: width,
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setWidth(20)),
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(15),
                    bottom: ScreenUtil().setWidth(15),
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 3,
                            spreadRadius: 1,
                            offset: Offset(0, 0))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          FlutterI18n.translate(context, "chooseBank.bankLink"),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(15)),
                      ),
                      Container(
                        child: GridView.count(
                          crossAxisCount: 4,
                          crossAxisSpacing: ScreenUtil().setWidth(14),
                          mainAxisSpacing: ScreenUtil().setHeight(18),
                          shrinkWrap: true,
                          primary: false,
                          children: List<GestureDetector>.generate(
                              listBank.length, (index) {
                            return _renderItemBank(listBank[index]);
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // thẻ thanh toán quốc tế
                Container(
                  width: width,
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setWidth(20)),
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(15),
                    bottom: ScreenUtil().setWidth(15),
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 3,
                            spreadRadius: 1,
                            offset: Offset(0, 0))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          FlutterI18n.translate(context, "chooseBank.internationalPaymentCards"),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(15)),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(19),
                          right: ScreenUtil().setWidth(19),
                        ),
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: ScreenUtil().setWidth(26),
                          mainAxisSpacing: ScreenUtil().setHeight(18),
                          shrinkWrap: true,
                          primary: false,
                          children: List<GestureDetector>.generate(
                              listPay.length, (index) {
                            return _renderItemBank(listPay[index]);
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // button tiếp tục
                visibleBtn != false
                    ? GestureDetector(
                        onTap: () => _onNextScreens(context),
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
                              colors: [
                                const Color(0xFFFF483D),
                                const Color(0xFFF42E13)
                              ],
                              tileMode: TileMode
                                  .repeated, // repeats the gradient over the canvas
                            ),
                          ),
                          child: Text(
                            FlutterI18n.translate(context, "chooseBank.continue"),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onNextScreens(context) {
    var route = new MaterialPageRoute(
        builder: (context) => Condition(
              bank: itemChoose,
            ));
    Navigator.push(context, route);
  }

  _renderItemBank(item) {
    return GestureDetector(
        onTap: () => _onChooseItem(item),
        child: Opacity(
          opacity: (itemChoose != null &&
                  itemChoose['id'] != item['id'] &&
                  visibleBtn)
              ? 0.5
              : 1,
          child: Container(
            width: ScreenUtil().setWidth(64),
            height: ScreenUtil().setHeight(64),
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (itemChoose != null && itemChoose['id'] == item['id'])
                      ? Color(0xFF0A4DD0)
                      : Color(0xFFE7E7E7),
                  width: 1,
                )),
            child: new Image.asset(
              item['image'],
              fit: BoxFit.contain,
              width: ScreenUtil().setWidth(53),
              height: ScreenUtil().setHeight(50),
            ),
          ),
        ));
  }

  _onChooseItem(item) {
    setState(() {
      itemChoose = item;
      visibleBtn = true;
    });
    print('itemChoose: $itemChoose');
  }
}
