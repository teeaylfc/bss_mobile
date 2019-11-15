import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:flutter/material.dart';
class SectionTitle extends StatelessWidget {
  final String title ;
  final dynamic textLeft ;
  final EdgeInsets padding;

  const SectionTitle(this.title , [this.textLeft, this.padding]);

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: padding == null ? EdgeInsets.fromLTRB(18, 30, 20, 0) : padding,
        child: Row(
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.bold,
                  color: CommonColor.textBlack),
            ),
            Spacer(),
            textLeft != null ? textLeft : Container()
          ],
        ));
  }
}