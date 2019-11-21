import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/common/http_client.dart';
import 'package:bss_mobile/src/pages/login.dart';
import 'package:bss_mobile/src/pages/sign_in.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'notification_popup.dart';

class Reusable {
  static get statusBarTopShadow {
    return Container(
      height: 90.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.0, 0.5),
          colors: [const Color(0x77000000), const Color(0x00000000)],
        ),
      ),
    );
  }

  static loadingProgress(orientation) {
    return Padding(padding: EdgeInsets.only(top: 100.0, right: 20.0, left: 20.0, bottom: 40.0), child: Center(child: CircularProgressIndicator()));
  }

  static Widget backArrow(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(padding: EdgeInsets.all(26.0), margin: EdgeInsets.only(top: 30.0), child: Icon(Icons.arrow_back, color: Colors.white)));
  }

  static void showTotastError(String errorMsg) {
    Fluttertoast.showToast(
        msg: errorMsg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: CommonColor.error,
        textColor: CommonColor.textWhite,
        fontSize: 16.0);
    throw (errorMsg);
  }

  static void showMessageDialog(success,text,context,{Function function}) {
    containerForSheet<String>(
        context: context,
        child: Container(
          child: MessagePopup(success: success, title1: text),
        ),
        function: function
    );
  }

  static void containerForSheet<T>({BuildContext context, Widget child, Function function}) {
    showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
          return child;
        }).then<void>((T value) {
          function ;
    });
  }

  static void showTotastSuccess(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: CommonColor.textWhite,
        fontSize: 16.0);
    throw (msg);
  }

  static showSnackBar(GlobalKey<ScaffoldState> _scaffoldKey, String text, {duration: 1400, String actionText, Function actionCallback}) {
    Future.delayed(Duration.zero, () {
      var snackBarAction;
      if (actionText != null && actionCallback != null) {
        snackBarAction = SnackBarAction(
            label: actionText,
            onPressed: () {
              actionCallback();
            });
      }

      var snackBar = SnackBar(
          action: snackBarAction,
          duration: Duration(milliseconds: duration),
          content: Text(text, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red);
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  static handleHttpError(context, error, [applicationBloc]) {
    if (error.action == HttpActionError.LOGIN) {
      // TODO 
      // applicationBloc.logout();
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SignInPage();
          },
          fullscreenDialog: true));
    } else {
      Reusable.showTotastError(error.message);
    }
  }
}
