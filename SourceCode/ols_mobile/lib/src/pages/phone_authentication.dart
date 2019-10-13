import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/bankCard_link.dart';
import 'package:ols_mobile/src/widgets/header.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class PhoneAuthenticaton extends StatefulWidget {
  String phoneNumber;
  PhoneAuthenticaton({this.phoneNumber});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PhoneAuthenticatonState();
  }
}

class PhoneAuthenticatonState extends State<PhoneAuthenticaton> {
  TextEditingController inputOTP = new TextEditingController();
  int count = 10;
  Timer timer;
  bool statusOTP = true;
  String phoneNumber;

  void initState() {
    super.initState();
    inputOTP.addListener(_onChangeValue);
    phoneNumber = widget.phoneNumber;
    _interval();
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    inputOTP.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }
  Widget content(context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      color: Colors.grey[100],
      padding: EdgeInsets.only(
        left: ScreenUtil().setSp(28),
        right: ScreenUtil().setSp(28),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Vui lòng nhập mật khẩu một lần (OTP) đã được gửi tới số điện thoại $phoneNumber',
            style: TextStyle(color: Color(0xff696969)),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setSp(40),
              bottom: ScreenUtil().setSp(20),
            ),
            child: Text(
              'Nhập mã OTP',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff696969)),
            ),
          ),
          Container(
            height: ScreenUtil().setSp(40),
            padding: EdgeInsets.only(
                left: ScreenUtil().setSp(22), right: ScreenUtil().setSp(22)),
            child: PinInputTextField(
              pinLength: 6,
              controller: inputOTP,
              decoration: BoxLooseDecoration(
                textStyle: TextStyle(color: Colors.black),
                gapSpace: 11,
                strokeWidth: 2,
                solidColor: Colors.white,
                enteredColor: Color(0xffE7E7E7),
                strokeColor: Color(0xffFD4435),
              ),
              autoFocus: true,
              textInputAction: TextInputAction.go,
            ),
          ),
          statusOTP == false
              ? Container(
            margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Color(0xFFFD4435),
                  size: 18,
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setSp(5)),
                  child: Text(
                    'OTP không chính xác',
                    style: TextStyle(color: Color(0xFFFD4435)),
                  ),
                )
              ],
            ),
          )
              : Container(),
          GestureDetector(
            onTap: count == 0 ? () => _sendAgain() : null,
            child: Container(
              margin: EdgeInsets.only(top: ScreenUtil().setSp(40)),
              alignment: Alignment.center,
              child: count == 0
                  ? Text('Gửi lại mã',
                  style: TextStyle(
                      color: Color(0xff0A4DD0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline))
                  : Text("Bạn có thể yêu cầu mã mới sau $count"),
            ),
          )
        ],
      ),
    );
  }

  _sendAgain() {
    print('send again');
    setState(() {
      count = 10;
    });
    _interval();
  }

  _interval() {
    timer = Timer.periodic(
        new Duration(seconds: 1),
            (Timer time) => setState(() {
          if (count < 1) {
            time.cancel();
          } else {
            count = count - 1;
          }
        }));
  }

  _onChangeValue() {
    if (inputOTP.text.length == 6) {
      if (inputOTP.text == "000000") {
        setState(() {
          statusOTP = false;
        });
      } else {
        Navigator.popUntil(
            context, ModalRoute.withName('bankcard'));
      }
    }
  }
}
