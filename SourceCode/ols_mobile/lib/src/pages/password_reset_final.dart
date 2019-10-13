import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/sign_in.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/notification_popup.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PasswordResetFinish extends StatefulWidget {
  String email;
  PasswordResetFinish(this.email);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PasswordResetFinishState();
  }
}

class PasswordResetFinishState extends State<PasswordResetFinish> {
  TextEditingController _passwordNewController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  var _obscureText = true;
  var _emptyNewPassword = false;
  var email;
  bool _autoValid = false;
  DataService dataService = DataService();

  bool _validConfirm = true;
  @override
  void initState() {
    email = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
        body: Form(
          autovalidate: _autoValid,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(35)),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'Đặt lại mật khẩu',
                    style: TextStyle(fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.bold),
                  ),
                ),
                _showNewPasswordInput(_passwordNewController, 'Mật khẩu mới'),
                _showConfirmPasswordInput(_passwordConfirmController, 'Nhập lại mật khẩu'),
                _showCodeInput(_codeController, 'Mã xác nhận'),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setSp(35)),
                  child: _buildResetPasswordButton(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showNewPasswordInput(controller, text) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setSp(30)),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        obscureText: _obscureText,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
            errorText: _emptyNewPassword ? 'Mật khẩu tối thiểu 8 kí tự' : null,
            suffixIcon: GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, semanticLabel: _obscureText ? 'show password' : 'hide password', color: CommonColor.textGrey, size: ScreenUtil().setSp(15)),
            ),
            labelText: text,
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, ScreenUtil().setSp(15), 0, ScreenUtil().setSp(5)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B)))),
        validator: validatePassword,
        onSaved: (value) => {},
      ),
    );
  }

  _showConfirmPasswordInput(controller, text) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setSp(30)),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        obscureText: _obscureText,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
//            errorText: _validConfirm ? null : "Re-enter password required",
            suffixIcon: GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, semanticLabel: _obscureText ? 'show password' : 'hide password', color: CommonColor.textGrey, size: ScreenUtil().setSp(15)),
            ),
            labelText: text,
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B)))),
        validator: validatePasswordConfirm,
        onSaved: (value) => {},
      ),
    );
  }

  _showCodeInput(controller, text) {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setSp(30)),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
          contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
        ),
        validator: validateResetCode,
        onSaved: (value) => {},
      ),
    );
  }

  String validateResetCode(value) {
    if (_codeController.text.length == 0) {
      return 'Vui lòng nhập mã xác nhận';
    }
    return null;
  }

  _buildResetPasswordButton(context) {
    return RaisedGradientButton(
      child: Text(
        'Xác nhận',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: ScreenUtil().setSp(16),
        ),
      ),
      gradient: CommonColor.commonButtonColor,
      onPressed: () async {
        setState(() {
          _autoValid = true;
        });
        if (_passwordNewController.text == _passwordConfirmController.text && _passwordNewController.text.length >= 8) {
          try {
            var res = await dataService.forgotPasswordFinish(email, _codeController.text, _passwordNewController.text);
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
            _showMessageDialog(true, res.toString());
          } catch (error) {
            print(error.message);
            _showMessageDialog(false, error.message);
          }
        }
      },
    );
  }

  String validatePasswordConfirm(value) {
    if (_passwordNewController.text != _passwordConfirmController.text && _passwordConfirmController.text.length >= 4) {
      return 'Mật khẩu không trùng khớp, vui lòng thử lại';
    } else if (_passwordConfirmController.text.length == 0) {
      return 'Yêu cầu nhập lại mật khẩu !';
    }
    return null;
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
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
          return child;
        }).then<void>((T value) {
      // Navigator.pop(context);
    });
  }

  String validatePassword(String value) {
    if (_passwordNewController.text.length == 0) {
      return 'Yêu cầu nhập mật khẩu !';
    } else if (_passwordNewController.text != '' && _passwordNewController.text.length < 8) {
      return 'Mật khẩu tối thiểu 8 kí tự';
    }

    return null;
  }
}
