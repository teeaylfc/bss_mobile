import 'dart:io';

import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final bool avatarPreview;
  final File avatarFile;
  final String image;
  final String headline;
  final String title;
  final Function callbackConfirm;
  final Function callbackDone;
  final double width;
  final double height;

  const ConfirmDialog({this.avatarPreview = false , this.avatarFile , this.width, this.height, this.image, this.title, this.headline, this.callbackConfirm, this.callbackDone});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13.0))),
      content: Container(
        height: ScreenUtil().setSp(height),
        width: ScreenUtil().setSp(width),
        child: Column(
          children: <Widget>[
            image != null
                ? Image(
                    width: ScreenUtil().setSp(80),
                    height: ScreenUtil().setSp(113),
                    image:AssetImage(
                      image,
                    )
                  )
                : avatarPreview && avatarFile != null ? CircleAvatar(
                                        radius: 40,
                                        backgroundImage: FileImage(avatarFile)
                                    )
                                  : Container(),
            SizedBox(
              height: ScreenUtil().setSp(25),
            ),
            headline != null
                ? Container(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setSp(20)),
                    child: Text(
                      headline,
                      style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
            title != null
                ? Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: CommonColor.textGrey,
                        fontSize: ScreenUtil().setSp(15),
                      ),
                    ),
                  )
                : Text(''),
            Expanded(
              child: this.callbackConfirm != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildCancelButton(context),
                        _buildYesButton(context, 'CONFIRM'),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildYesButton(context, 'DONE'),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  _buildYesButton(context, type) {
    return RaisedGradientButton(
        child: Text(
          type == 'DONE' ? 'Xong' : 'Đồng ý',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w600,
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
        borderRadius: 20,
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFF42E13), Color(0xFFF42E13)],
        ),
        width: ScreenUtil().setSp(115),
        height: ScreenUtil().setSp(40),
        onPressed: () {
          Navigator.of(context).pop(ConfirmAction.ACCEPT);
          type == 'DONE' ? callbackDone() : callbackConfirm();
        });
  }

  _buildCancelButton(context) {
    return RaisedGradientButton(
        child: Text(
          'Hủy',
          style: TextStyle(
            color: CommonColor.textGrey,
            fontWeight: FontWeight.w600,
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
        borderRadius: 20,
        color: Color(0xFFEAEAEA),
        width: ScreenUtil().setSp(115),
        height: ScreenUtil().setSp(40),
        onPressed: () {
          Navigator.of(context).pop(ConfirmAction.CANCEL);
        });
  }
}
