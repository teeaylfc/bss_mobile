import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:flutter/material.dart';

class MPoint extends StatelessWidget {
  final String point;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  final bool background;
  const MPoint({this.point, this.textColor, this.fontSize = 18, this.iconSize, this.background = true});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Image(
        height: iconSize != null ? ScreenUtil().setSp(iconSize) : ScreenUtil().setSp(14),
        width: iconSize != null ? ScreenUtil().setSp(iconSize) : ScreenUtil().setSp(14),
        image: background ? AssetImage('assets/images/loyalty/m_dollar.png') : AssetImage('assets/images/loyalty/m_dollar_no_backgr.png'),
      ),
      Text(
        ' ' + point,
        style: TextStyle(
          fontSize: fontSize != null ? ScreenUtil().setSp(fontSize) : ScreenUtil().setSp(14),
          fontWeight: FontWeight.bold,
          color: (textColor != null ? textColor : CommonColor.textBlack),
        ),
      ),
    ]);
  }
}
