import 'package:auto_size_text/auto_size_text.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CouponCount extends StatelessWidget {
  final int count;

  const CouponCount({this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setSp(40),
      width: ScreenUtil().setSp(40),
      decoration: BoxDecoration(
        color: Color(0xFF27AE60),
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(40.0),
          topRight: const Radius.circular(8.0),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Center(
            child: AutoSizeText(
          '  x' + count.toString(),
          style: TextStyle(fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500, color: Colors.white),
        )),
      ),
    );
  }
}
