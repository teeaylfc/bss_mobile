import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String error;
  final String text;
  final Function callback;

  ErrorPage(this.text, this.callback, [this.error]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Image.asset(
              'assets/images/error.png',
              width: ScreenUtil().setSp(60),
            ),
          ),
          Center(
              child: Text(
            error ?? '',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ScreenUtil().setSp(16),
            ),
          )),
          _buildRetryButton(context, text)
        ],
      ),
    );
  }

  _buildRetryButton(context, text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: RaisedGradientButton(
          child: Text(
            text ?? '',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
          ),
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)],
          ),
          width: MediaQuery.of(context).size.width / 2,
          height: ScreenUtil().setSp(40),
          onPressed: () {
            callback();
            // Navigator.pop(context);
          }),
    );
  }
}
