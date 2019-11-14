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
        body: SingleChildScrollView(
          child: Container(
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
                SizedBox(
                  height: ScreenUtil().setSp(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          _timeWidget("13h"),
                          _timeWidget("15h"),
                          _timeWidget("17h"),
                          _timeWidget("19h"),
                          _timeWidget("21h"),
                        ],
                      ),
                    ),
                 Expanded(
                  //  decoration: BoxDecoration(
                  //    color: Colors.white,
                  //  ),
                  //      width: ScreenUtil().setSp(300),
                  //      height: ScreenUtil().setSp(500),
                       child: Container(
                          height: ScreenUtil().setSp(500),
                         child: ListView.builder(
                           scrollDirection: Axis.horizontal,
                           itemCount: 6,
                           itemBuilder: (context,index){
                             return Column(
                               children: <Widget>[
                                 _buildItemStadium(index + 1),
                                  Expanded(
                                    child: Container(
                                      width: ScreenUtil().setSp(50),
                                      height: ScreenUtil().setSp(600),
                                      child: ListView.builder(
                                         itemCount: 7,
                                         itemBuilder: (context,index){
                                           return Container(
                                             decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                left:  BorderSide(
                                                  color: Colors.green
                                                ),
                                                top:  index == 0 ? BorderSide(
                                                  color: Colors.green
                                                ) : BorderSide(
                                                  width: 0,
                                                ),
                                                  bottom: BorderSide(
                                                  color: Colors.green
                                                ),
                                                right:  index == 6 ? BorderSide(
                                                  color: Colors.green
                                                ) : BorderSide(
                                                  width: 0,
                                                ),
                                              )
                                             ),
                                             width: ScreenUtil().setSp(50),
                                              height: ScreenUtil().setSp(40),
                                              child: index != 2 ? Center(
                                                child: Container(
                                                  width: ScreenUtil().setSp(25),
                                                  height: ScreenUtil().setSp(25),
                                                  decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(100)
                                                  ),
                                                ),
                                              ) : Container(
                                                 width: ScreenUtil().setSp(50),
                                              height: ScreenUtil().setSp(40),
                                              color: Colors.grey,
                                              ),
                                           );
                                         },
                                       ),
                                    ),
                                  ),
                               ],
                             );
                           },
                         ),
                       ),
                     )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _timeWidget(text) {
    return Container(
        height: ScreenUtil().setSp(40), child: Center(child: Text(text,style: TextStyle(fontSize: ScreenUtil().setSp(14)),)));
  }

  _buildItemStadium(int index){
    return Container(
             width: ScreenUtil().setSp(50),
            height: ScreenUtil().setSp(50),
            padding: EdgeInsets.all(17),
      child: Container(
            width: ScreenUtil().setSp(25),
            height: ScreenUtil().setSp(25),
            decoration: BoxDecoration(
               color: Colors.green,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(index.toString(),style: TextStyle(
                color: Colors.white,
                fontSize: 18
              ),),
            ),
          ),
    );
  }
}
