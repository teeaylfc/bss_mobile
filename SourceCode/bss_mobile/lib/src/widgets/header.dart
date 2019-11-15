import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  Header({this.body, this.title, this.btnRight});

  Widget body;
  String title;
  final btnRight;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: width,
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context)),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          btnRight != null
              ? GestureDetector(
                  onTap: () => btnRight(),
                  child: Container(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(12),
                        bottom: ScreenUtil().setHeight(12),
                        right: ScreenUtil().setWidth(10)),
                    child: Container(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                        right: ScreenUtil().setWidth(10),
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(18)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFFF483D),
                            const Color(0xFFF42E13)
                          ],
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 14,
                          ),
                          Text(
                            FlutterI18n.translate(context, 'accountLinked.add'),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ))
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ), onPressed: () {},
                )
        ],
        title: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: body,
    );
  }
}
