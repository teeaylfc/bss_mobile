import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/auth_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/http_client.dart';
import 'package:bss_mobile/src/models/bloc_delegate.dart';
import 'package:bss_mobile/src/models/user_modal.dart';
import 'package:bss_mobile/src/pages/main.dart';
import 'package:bss_mobile/src/pages/profile_edit.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/notification_popup.dart';
import 'package:bss_mobile/src/widgets/raised_gradient_button.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationPage2 extends StatefulWidget {
  final String name;
  final String email;

  const RegistrationPage2({this.name, this.email});

  @override
  State<StatefulWidget> createState() {
    return _Registration2State();
  }
}

class _Registration2State extends State<RegistrationPage2> implements BlocDelegate<User> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DataService dataService = DataService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _autoValidate = false;
  bool loading = false;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc(delegate: this);

    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Scaffold(
          key: _scaffoldKey,
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
                )),
          ),
          body: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 49),
                    child: Text(
                      FlutterI18n.translate(context, 'registrationPage.createPassword'),
                      style: TextStyle(fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.bold),
                    ),
                  ),
                  _showPasswordInput(_passwordController,  FlutterI18n.translate(context, 'registrationPage.pass'),),
                  _showConfirmPasswordInput(_passwordConfirmController,  FlutterI18n.translate(context, 'registrationPage.rePass'),),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: _buildSignupButton(context, authBloc),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Text( FlutterI18n.translate(context, 'registrationPage.terms'),
                                style: TextStyle(color: Color(0xFFa9a9a9), fontSize: ScreenUtil().setSp(12)))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String validatePasswordConfirm(String val) {
    if (_passwordController.text != _passwordConfirmController.text && _passwordConfirmController.text.length >= 1) {
      return  FlutterI18n.translate(context, 'registrationPage.passNotMatch');
    } else if (_passwordConfirmController.text.length == 0) {
      return  FlutterI18n.translate(context, 'registrationPage.rePassRequire');
    }
    return null;
  }

  Widget _showPasswordInput(controller, text) {
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
                  semanticLabel: _obscureText ? 'show password' : 'hide password', color: CommonColor.textGrey, size: 15),
            ),
            labelText: text,
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0xFF9B9B9B), fontWeight: FontWeight.w500),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF9B9B9B)))),
        validator: validatePassword,
        onSaved: (value) => {},
      ),
    );
  }

  Widget _showConfirmPasswordInput(controller, text) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        obscureText: _obscureText,
        autofocus: false,
        style: new TextStyle(color: Color(0xFF9B9B9B), fontSize: ScreenUtil().setSp(18)),
        decoration: InputDecoration(
//            errorText: _validConfirm ? null : "Re-enter password is required",
            suffixIcon: GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                  semanticLabel: _obscureText ? 'show password' : 'hide password', color: CommonColor.textGrey, size: 15),
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

  _buildSignupButton(context, authBloc) {
    return RaisedGradientButton(
        child: Text(
          FlutterI18n.translate(context, 'registrationPage.done'),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
        ),
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFD90D0D), Color(0xFFD90D0D)],
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _validateInputs(authBloc);
        });
  }

  String validatePassword(String value) {
//    return value.length <8 ? 'Password must be at least 8 characters.' : null;
    if (value.length < 8 && value.length > 0) {
      return  FlutterI18n.translate(context, 'registrationPage.passLeast');
    } else if (value.length == 0) {
      return  FlutterI18n.translate(context, 'registrationPage.rePass');
    }
    return null;
  }

  void _validateInputs(authBloc) {
    if (_formKey.currentState.validate() && _passwordController.text.length >= 8 && _passwordConfirmController.text == _passwordController.text) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      _register(authBloc);
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _register(authBloc) {
    setState(() {
      loading = true;
    });
    try {
      authBloc.register(widget.email, widget.name, _passwordController.text);
    } catch (error) {
      setState(() {
        loading = false;
        Reusable.showSnackBar(
          _scaffoldKey,
          error,
        );
      });
    }
  }

  _showNotificationDialog() {
    containerForSheet<String>(
        context: context,
        child: MessagePopup(
          success: true,
          title1: FlutterI18n.translate(context, 'registrationPage.createSuccess'),
        ));
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // Navigator.pop(context);
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) => ProfileEditPage(
//                  )));
    });
  }

  @override
  error(HttpError error) {
    setState(() {
      loading = false;
    });
    Reusable.showSnackBar(
      _scaffoldKey,
      error.message,
    );
  }

  @override
  success(user) {
    setState(() {
      loading = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
    _showNotificationDialog();
    BlocProvider.of<ApplicationBloc>(context).changeCurrentUser(user);
    BlocProvider.of<ApplicationBloc>(context).changeOrderCount(user.walletCount);

    return null;
  }
}
