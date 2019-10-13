import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/blocs/information_card_bloc.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/card_authentication.dart';
import 'package:ols_mobile/src/widgets/header.dart';

class InfomationCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InfomationCardState();
  }
}

class InfomationCardState extends State<InfomationCard> {
  TextEditingController cardNumber = new TextEditingController();
  TextEditingController deadline = new TextEditingController();
  TextEditingController username = new TextEditingController();

  bool statusCardNumber = false;
  bool statusDeadline = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      title: FlutterI18n.translate(context,'infoCard.infoCard'),
      body: content(context),
    );
  }

  Widget content(context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        width: width,
        color: Colors.grey[100],
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: width,
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(23),
                    bottom: ScreenUtil().setHeight(23),
                  ),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(40),
                    top: ScreenUtil().setHeight(17),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 0))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      textInput(context, 1, cardNumber, TextInputType.number,
                          'XXXX XXXX XXXX XXXX', FlutterI18n.translate(context, 'infoCard.numberCard')),
                      textInput(context, 2, deadline, TextInputType.datetime,
                          'MM / YY', FlutterI18n.translate(context, 'infoCard.deadlineCard')),
                      textInput(context, 3, username, TextInputType.text,
                          'NGUYEN MINH', FlutterI18n.translate(context, 'infoCard.nameCard')),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: ()=> _onLinkCard(),
                  child: Container(
                    width: width,
                    margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setHeight(23),
                    ),
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(12),
                      top: ScreenUtil().setHeight(12),
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color((statusCardNumber && statusDeadline)
                          ? 0xFF0A4DD0
                          : 0xFF696969),
//                      color: Color(0xFF696969) ,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      FlutterI18n.translate(context, 'infoCard.linkCard'),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textInput(context, type, controller, keyboardType, hint, title) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
          TextField(
            keyboardType: keyboardType,
            controller: controller,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            onChanged: (txt) => _onChangeText(type),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, bottom: 10),
              labelStyle: TextStyle(color: Color(0xFFBDBDBD)),
              hintText: hint,
              errorText: _checkErrInput(type),
              hintStyle: TextStyle(color: Color(0xFF9B9B9B)),
            ),
          ),
        ],
      ),
    );
  }

  _checkErrInput(type) {
    if (type == 1 && !statusCardNumber && cardNumber.text.length !=0) return 'Số thẻ không hơp lệ';
    if (type == 2 && !statusDeadline && deadline.text.length != 0) return 'Ngày hết hạn không hợp lệ';
    return null;
  }

  _onLinkCard() {
    var route = new MaterialPageRoute(builder: (context)=> CardAuthenticaton());
    Navigator.push(context, route);
  }

  _onChangeText(type) {
    if (type == 1) {
      setState(() {
        if (cardNumber.text.length != 16) {
          statusCardNumber = false;
        } else {
          statusCardNumber = true;
        }
      });
    } else if (type == 2) {
      setState(() {
        if (deadline.text.length != 5) {
          statusDeadline = false;
        } else {
          statusDeadline = true;
        }
      });
    }
  }
}
