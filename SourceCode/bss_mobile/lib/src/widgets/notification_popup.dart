import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagePopup extends StatelessWidget {
  final bool success;
  final String title1;
  final String title2;
  final String ogbjectId;

  const MessagePopup({this.success, this.title1, this.title2, this.ogbjectId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: CupertinoActionSheet(actions: <Widget>[
        CupertinoActionSheetAction(
          child: Row(children: <Widget>[
            success
                ? Icon(
                    Icons.check_circle,
                    color: Color(0xFF6FCF97),
                  )
                : Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
            SizedBox(
              width: ScreenUtil().setSp(5),
            ),
            Container(
              width: MediaQuery.of(context).size.width/1.6,
              child: Text(
                title1 ?? '',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: ScreenUtil().setSp(14), color: success ? CommonColor.textBlack : Colors.red),
              ),
            ),
            Text(
              ' ',
            ),
            Text(
              title2 ?? '',
              style: TextStyle(color: CommonColor.textRed, fontSize: ScreenUtil().setSp(14)),
            )
          ]),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(ogbjectId);
          },
        )
      ]),
    );
  }
}
