import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';

class MemberCodePage extends StatefulWidget {
  final String csn;

  MemberCodePage({this.csn});

  @override
  State<StatefulWidget> createState() {
    return _MemberCodePageState();
  }
}

class _MemberCodePageState extends State<MemberCodePage> {
  DataService dataService = DataService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Container(
          padding: EdgeInsets.only(right: 36),
          child: Center(
              child: Text(
                FlutterI18n.translate(context, 'memberCodePage.memberCode'),
                style: TextStyle(color: Colors.black),
          )),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setSp(20), right: ScreenUtil().setSp(20), top: ScreenUtil().setSp(20)),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image(
                  height: ScreenUtil().setSp(215),
                  width: ScreenUtil().setSp(335),
                  image: AssetImage('assets/images/loyalty/member_card1.png'),
                ),
                Positioned(
                  bottom: ScreenUtil().setSp(20),
                  child: Container(
                    color: Colors.white,
                    height: ScreenUtil().setSp(109),
                    width: ScreenUtil().setSp(335),
                    child: Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                      child: Center(
                        child: BarCodeImage(
                          data: widget.csn ?? '', // Code string. (required)
                          codeType: BarCodeType.Code39, // Code type (required)
                          lineWidth: 2.0, // width for a single black/white bar (default: 2.0)
                          barHeight: 90.0, // height for the entire widget (default: 100.0)
                          hasText: true, // Render with text label or not (default: false)
                          onError: (error) {
                            // Error handler
                            print('error = $error');
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil().setSp(15),
            ),
            Text(
              FlutterI18n.translate(context, 'memberCodePage.text'),
              style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(14)),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setSp(60)),
              child: Image(
                height: ScreenUtil().setSp(154),
                width: ScreenUtil().setSp(195),
                image: AssetImage('assets/images/loyalty/member_card2.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
