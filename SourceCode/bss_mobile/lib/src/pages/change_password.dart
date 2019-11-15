import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/pages/profile_edit.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/notification_popup.dart';
import 'package:bss_mobile/src/widgets/raised_gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class ChangePassword extends StatefulWidget{
  final bool _isFirstPassword;

  ChangePassword(this._isFirstPassword);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChangePasswordState();
  }
}
class ChangePasswordState extends State<ChangePassword>{
  TextEditingController _passwordCurrentController = TextEditingController();
  TextEditingController _passwordNewController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  DataService dataService = DataService();
  bool _obscureText = true;
  bool  _isFirstPassword;
  bool _autoValid = false;
  @override
  void initState() {
    _isFirstPassword = widget._isFirstPassword;
    print(_isFirstPassword);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ModalProgressHUD(
      inAsyncCall: false,
      child: Container(
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
            automaticallyImplyLeading: true,
          ),
          body: Form(
            autovalidate: _autoValid,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      !_isFirstPassword
                      ?'Change password'
                      : 'Init password',
                      style: TextStyle(fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.bold),
                    ),
                  ),
                  !_isFirstPassword ? _showCurrentPasswordInput(_passwordCurrentController,"Current password") : Container(),
                  _showNewPasswordInput(_passwordNewController, 'New password'),
                  _showConfirmPasswordInput(_passwordConfirmController, 'Re-enter password'),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: _buildChangePasswordButton(context),
                  ),
                      ],
                    ),
                  ),
              ),
            ),
          ),
        );
  }

  _showNewPasswordInput(controller, text) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        obscureText: _obscureText,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                  semanticLabel: _obscureText ? 'show password' : 'hide password',
                  color: CommonColor.textGrey, size: ScreenUtil().setSp(15)),
            ),
            labelText: text,
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(15), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B)))),
        validator: validateNewPassword,
        onSaved: (value) => {},
      ),
    );
  }


   String validatePassword(value) {
     return value.isEmpty ? 'Password requied' : null;
  }

  _showCurrentPasswordInput(controller, text) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        obscureText: _obscureText,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                  semanticLabel: _obscureText ? 'show password' : 'hide password', color: CommonColor.textGrey, size: ScreenUtil().setSp(15)),
            ),
            labelText: text,
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(15), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B)))),
        validator: validatePassword,
        onSaved: (value) => {},
      ),
    );
  }

  _showConfirmPasswordInput(controller, text) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        obscureText: _obscureText,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                  semanticLabel: _obscureText ? 'show password' : 'hide password', color: CommonColor.textGrey, size: ScreenUtil().setSp(15)),
            ),
            labelText: text,
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(15), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B)))),
        validator: validatePasswordConfirm,
        onSaved: (value) => {},
      ),
    );
  }

  String validatePasswordConfirm(value) {
    if (_passwordNewController.text != _passwordConfirmController.text && _passwordConfirmController.text.length >= 1) {
      return 'Passwords do not match. Please try again !';
    }else if(_passwordConfirmController.text.length == 0){
      return 'Re-enter password required';
    }
    return null;
  }
  _buildChangePasswordButton(BuildContext context) {
    return RaisedGradientButton(
        child: Text(
          'Confirm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18)),
        ),
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)],
        ),
        onPressed: () async {
              setState(() {
                _autoValid = true;
              });
             if (_passwordNewController.text == _passwordConfirmController.text
                && _passwordCurrentController.text.length >= 8 &&
                _passwordNewController.text.length >= 8) {
              try {
                var res = await dataService.changePassword(
                    _passwordCurrentController.text,
                    _passwordNewController.text);
                Navigator.of(context).pop();
                _showMessageDialog(true, res.toString());
              } catch (error) {
                print(error.message);
                _showMessageDialog(false,error.message);
              }
            }
        }
        );
  }
  _showMessageDialog(success, text) {
    containerForSheet<String>(
        context: context,
        child: MessagePopup(
          success: success,
          title1: text,
          title2: success ? "Edit profile" : null,
        ),
    success: success);
  }
  void containerForSheet<T>({BuildContext context, Widget child, bool success}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context){
        Future.delayed(Duration(seconds: 5), () {
          Navigator.of(context).pop();
        });
        return child;
      }
    ).then<void>((T value) {
      if(success == true) {
        return;
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => ProfileEditPage()));
      }else{
        return;
      }
    });
  }

  String validateNewPassword(String value) {
    if(value.length < 8 && value.length >0 ){
      return 'Password must be at least 8 characters';
    }else if(value.length == 0){
      return 'Password required';
    }
    return null;
  }
}