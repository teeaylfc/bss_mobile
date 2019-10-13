import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckOutFinalPage extends StatefulWidget {
  String qrCode;
  String storeName;
  CheckOutFinalPage(this.qrCode, this.storeName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CheckOutFinalPageState();
  }
}

class _CheckOutFinalPageState extends State<CheckOutFinalPage> {
  String qrCode;
  QrImage _qrImage;
  String storeName;
  @override
  void initState() {
    qrCode = widget.qrCode;
    storeName = widget.storeName;
    _generateQR();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Color(0xffF42E13),
              height: ScreenUtil().setSp(190),
            ),
            Positioned(
              top: ScreenUtil().setHeight(90),
              left: ScreenUtil().setWidth(28),
              right: ScreenUtil().setWidth(28),
              child: Container(
                padding: EdgeInsets.only(top: ScreenUtil().setSp(45), bottom: ScreenUtil().setSp(58)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.12).withOpacity(0.12),
                        offset: new Offset(0.0, 0.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0)
                  ],
                ),
                width: ScreenUtil().setWidth(319),
                height: ScreenUtil().setHeight(403),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Mã ưu đãi tại",
                            style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w500, color: Color(0xff343434)),
                          ),
                          Text(
                            storeName != null ? storeName : "",
                            style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w500, color: Color(0xffF42E13)),
                          ),
                          SizedBox(
                            height: ScreenUtil().setSp(14),
                          ),
                          Container(
                              width: ScreenUtil().setWidth(240),
                              height: ScreenUtil().setHeight(32),
                              child: Text(
                                "Vui lòng cung cấp mã này cho nhân viên cửa hàng để được áp dụng ưu đãi",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: ScreenUtil().setSp(12), color: Color(0xff696969)),
                              )),
                          SizedBox(
                            height: ScreenUtil().setSp(31),
                          ),
                          Container(width: ScreenUtil().setSp(146), height: ScreenUtil().setSp(146), child: _qrImage),
                          SizedBox(
                            height: ScreenUtil().setSp(0),
                          ),
                          Text(
                            qrCode ?? "",
                            style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w500, color: Color(0xff696969)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: ScreenUtil().setSp(75),
        width: ScreenUtil().setSp(375),
        padding: EdgeInsets.all(ScreenUtil().setSp(14)),
        child: RaisedGradientButton(
            width: ScreenUtil().setSp(345),
            height: ScreenUtil().setSp(44),
            child: Text(
              'Hoàn thành',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(16)),
            ),
            gradient: CommonColor.commonButtonColor,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }

  void _generateQR() async {
    QrImage image;
    if (qrCode == null || qrCode == '') {
      image = null;
    } else {
      try {
        image = await QrImage(
          data: qrCode,
          size: 200,
          gapless: false,
          foregroundColor: const Color(0xFF111111),
        );
      } on PlatformException {
        image = null;
      }
    }

    setState(() {
      _qrImage = image;
    });
  }
}
