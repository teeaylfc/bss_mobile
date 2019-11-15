import 'package:flutter/material.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/models/address_model.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/merchant_image.dart';

class AddressCard extends StatelessWidget{
    Address address;
    AddressCard({this.address});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
            width: ScreenUtil().setWidth(345),
            constraints: BoxConstraints(minHeight: ScreenUtil().setSp(115)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      1.0, // horizontal, move right 10
                      1.0, // vertical, move down 10
                    ),
                  )
                ]),
            margin: EdgeInsets.only(
              top: ScreenUtil().setSp(15),
            ),
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(14),
              horizontal: ScreenUtil().setWidth(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset("assets/images/loyalty/stadium_logo.jpg",width: ScreenUtil().setSp(70),height: ScreenUtil().setSp(70),),
                SizedBox(
                  width: ScreenUtil().setSp(15),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Sân bóng Đông Đô',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        fontWeight: FontWeight.bold,
                        color: CommonColor.textBlack,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(6),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setWidth(230),
                        minHeight: ScreenUtil().setHeight(20),
                      ),
                      child: Text(
                       "Sân nhân tạo số 1 châu Á",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff696969),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(10),
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset("assets/images/loyalty/location_icon.png",width: 20,height: 25,),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                       constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setWidth(200),
                        minHeight: ScreenUtil().setHeight(18),
                      ),
                          child: Text(
                              "Số 1 Trung Kính, Cầu Giấy , Hà Nội",
                            style: TextStyle(
                                color: Color(0xffFD4435),
                                fontSize: ScreenUtil().setSp(14),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
  }

}