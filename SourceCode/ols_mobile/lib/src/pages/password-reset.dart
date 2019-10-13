import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/card_authentication.dart';
import 'package:ols_mobile/src/pages/password_reset_final.dart';
import 'package:ols_mobile/src/pages/phone_authentication.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/notification_popup.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PasswordResetState();
  }
}

class _PasswordResetState extends State<PasswordResetPage> {
  TextEditingController phoneController = TextEditingController();
  DataService dataService = DataService();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Color(0xffF76016),
            ),
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xffD60202),
                  size: ScreenUtil().setSp(24),
                ))),
        body: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
                child: Text(
                  'Đặt lại mật khẩu',
                  style: TextStyle(fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
                child: Text(
                  'Chúng tôi sẽ gửi mã xác minh vào số điện thoại của bạn!.',
                  style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                ),
              ),
              _showEmailInput(),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 35.0, 40.0, 30.0),
                child: _buildSignupButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 50.0, 40.0, 0.0),
      child: TextFormField(
        controller: phoneController,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        style: new TextStyle(
          color: Color(0xFF9B9B9B),
          fontSize: ScreenUtil().setSp(18),
        ),
        decoration: InputDecoration(
            labelText: 'Số điện thoại',
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF9B9B9B),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9B9B9B)),
            )),
//        validator: (value) => value.isEmpty && value.toString().contains(other) ? 'Invalid email format' : null,
//        onSaved: (value) => {},
      ),
    );
  }

  _buildSignupButton(context) {
    return RaisedGradientButton(
        child: Text(
          'Đặt lại mật khẩu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
        gradient: CommonColor.commonButtonColor,
        onPressed: () async {
          if (phoneController.text.length > 0) {
            try {
//              var res = await dataService.forgotPasswordInit(phoneController.text);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardAuthenticaton(),
                ),
              );
            } catch (error) {
              _showMessageDialog(false, "Số điện thoại không hợp lệ");
            }
          } else {
          }
        });
  }

  _showMessageDialog(success, text) {
    containerForSheet<String>(
        context: context,
        child: MessagePopup(
          success: success,
          title1: text,
        ));
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 4), () {
            Navigator.of(context).pop();
          });
          return child;
        }).then<void>((T value) {
      // Navigator.pop(context);
    });
  }
}
