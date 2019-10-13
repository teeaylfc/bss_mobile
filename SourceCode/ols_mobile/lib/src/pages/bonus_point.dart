import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/wallet_balance.dart';
import 'package:ols_mobile/src/widgets/header.dart';

class BonusPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(body: BonusPointContent(), title: FlutterI18n.translate(context, "bonusPoints.header"));
  }
}

class BonusPointContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BonusPointState();
  }
}

class BonusPointState extends State<BonusPointContent> {
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController bonusPoint = new TextEditingController();
  TextEditingController mess = new TextEditingController();
  bool disableBtn = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: Colors.grey[100],
          padding: EdgeInsets.only(top: 18),
          child: Column(children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _textInput(phoneNumber, FlutterI18n.translate(context, "bonusPoints.recipientPhoneNumber"),
                      TextInputType.number),
                  _textInput(
                      bonusPoint, FlutterI18n.translate(context, "bonusPoints.pointsDonate"), TextInputType.number),
                  _textInput(mess, FlutterI18n.translate(context, "bonusPoints.mess"), TextInputType.text),
                ],
              ),
            ),
            Container(
                width: width,
//                padding:
//                    EdgeInsets.only(left: 20, right: 20, top: 17, bottom: 17),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 3.0,
                    // has the effect of softening the shadow
                    spreadRadius: 1.0,
                    offset: new Offset(0.0, -3.0),
                  )
                ]),
                child: Opacity(
                  opacity: disableBtn ? 0.5 : 1,
                  child:
                  GestureDetector(
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
                          colors: [
                            const Color(0xFFFF483D),
                            const Color(0xFFF42E13)
                          ],
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      child: Text(
                        FlutterI18n.translate(context, "bonusPoints.next"),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                ))
          ]),
        ));
  }

  Widget _textInput(controller, hint, keyboardType) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400], width: 0.5),
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(bottom: 20, right: 18, left: 18),
      child: TextField(
        maxLines: keyboardType == TextInputType.text ? null : 1,
        keyboardType: keyboardType,
        controller: controller,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        onChanged: (txt) => _onChangeText(txt),
        decoration: InputDecoration(
          alignLabelWithHint: keyboardType == TextInputType.text ? true : false,
          contentPadding: EdgeInsets.only(
              top: 15,
              bottom: keyboardType == TextInputType.text ? 80 : 15,
              right: 10,
              left: 10),
          labelText: hint,
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  _onChangeText(txt) {
    if (phoneNumber.text != '' && bonusPoint.text != '' && mess.text != '') {
      setState(() {
        disableBtn = false;
      });
    } else {
      setState(() {
        disableBtn = true;
      });
    }
  }

  _onNextScreens(context) {
    var status = true;
//    var route = new MaterialPageRoute(builder: (context)=> WalletBalance());
//    Navigator.push(context, route);
    Navigator.pop(context, status);
  }
}
