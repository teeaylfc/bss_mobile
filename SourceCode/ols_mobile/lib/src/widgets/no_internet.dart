import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';

class NoInternetConnection extends StatelessWidget {
  final Function callback;

  NoInternetConnection({
    this.callback,
  });

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
              'assets/images/no_internet.png',
              width: ScreenUtil().setSp(60),
            ),
          ),
          Center(
              child: Text(
            'No internet connection!',
            style: TextStyle(
              color: CommonColor.textBlack,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(16),
            ),
          )),
          _buildRetryButton(context, 'Tap to retry')
        ],
      ),
    );
  }

  _buildRetryButton(context, text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: RaisedGradientButton(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(16),
            ),
          ),
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)],
          ),
          width: MediaQuery.of(context).size.width / 2,
          height: ScreenUtil().setSp(40),
          onPressed: () {
            callback();
          }),
    );
  }
}
