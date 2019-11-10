import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/models/stadium_model.dart';
import 'package:ols_mobile/src/style/color.dart';

class StadiumManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StadiumManagerState();
  }
}

class StadiumManagerState extends State<StadiumManager> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(gradient: CommonColor.leftRightLinearGradient),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(child: Text("Sân bóng Đông Đô")),
          automaticallyImplyLeading: true,
          actions: <Widget>[
            Image.asset(
              "assets/images/loyalty/calendar_icon.png",
              width: ScreenUtil().setSp(40),
            )
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: ScreenUtil().setSp(20),
              ),
              Text(
                "Hôm nay",
                style: TextStyle(
                    color: CommonColor.textBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(20)),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setSp(70),
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: ScreenUtil().setSp(30),
                            child: Center(child: Text("Sân",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(15)
                            ),))),
                        _timeWidget("7h"),
                        _timeWidget("9h"),
                        _timeWidget("11h"),
                        Container(
                          height: ScreenUtil().setSp(30),
                          color: Colors.grey,
                        ),
                        _timeWidget("13h"),
                        _timeWidget("15h"),
                        _timeWidget("17h"),
                        _timeWidget("19h"),
                        _timeWidget("21h"),
                      ],
                    ),
                  ),
                 Expanded(
                   child: Column(
                        children: <Widget>[
                          // _buildListStadium(5),
                        ],
                      ),
                 ),
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _timeWidget(text) {
    return Container(
        height: ScreenUtil().setSp(40), child: Center(child: Text(text,style: TextStyle(fontSize: ScreenUtil().setSp(14)),)));
  }

  _buildListStadium(int count){
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: count,
      itemBuilder: (context,index) {
        return Container(
          color: Colors.green,
          width: ScreenUtil().setSp(40),
          height: ScreenUtil().setSp(40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
        );
      },
    );
  }
}
