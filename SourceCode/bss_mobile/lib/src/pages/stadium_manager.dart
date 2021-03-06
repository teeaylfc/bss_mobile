import 'package:bss_mobile/src/models/shift_model.dart';
import 'package:bss_mobile/src/pages/shift_detail.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/models/stadium_model.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StadiumManager extends StatefulWidget {
  int addressId;

  StadiumManager(this.addressId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StadiumManagerState();
  }
}

class StadiumManagerState extends State<StadiumManager> {
   RefreshController _refreshController = RefreshController();
  DataService dataService = DataService();
  String datePicker;
  String dateView;
  List<Stadium> listStadium = List<Stadium>();
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    dateView = "Hôm nay";
    datePicker = DateTime.now().toString().substring(0, 10);
    print(widget.addressId.toString());
    refreshData();
    super.initState();
  }
 void _onRefresh() async{
    // monitor network fetch
     await refreshData();
     await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
  refreshData() async {
    setState(() {
      loading =  true;
    });
    listStadium = [];
    dataService.getDetailAddress(widget.addressId, datePicker).then((data) {
      setState(() {
        listStadium.addAll(data.address);
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(gradient: CommonColor.leftRightLinearGradient),
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Center(child: Text("Sân bóng Đông Đô")),
            automaticallyImplyLeading: true,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  _showDatePicker();
                },
                child: Container(
                  child: Image.asset(
                    "assets/images/loyalty/calendar_icon.png",
                    width: ScreenUtil().setSp(40),
                  ),
                ),
              )
            ],
          ),
          body: SmartRefresher(
                          controller: _refreshController,
              onRefresh: () {
                  _onRefresh();
              },
            child: SingleChildScrollView(
              child: Container(
                constraints:
                    BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setSp(20),
                    ),
                    GestureDetector(
                      onTap: ()=>_showDatePicker(),
                      child: Text(
                        dateView,
                        style: TextStyle(
                            color: CommonColor.textBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(20)),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(20),
                    ),
                    listStadium.length != 0 ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setSp(70),
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  height: ScreenUtil().setSp(50),
                                  child: Center(
                                      child: Text(
                                    "Sân",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(15)),
                                  ))),
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      listStadium[0].statusShiftResponses.length,
                                  itemBuilder: (context, index) {
                                    Shift shift = listStadium[0]
                                            .statusShiftResponses[index] ??
                                        null;
                                    return Container(
                                      height: ScreenUtil().setSp(50),
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setSp(20)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(shift.shiftDTO.time_start ?? '',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: ScreenUtil().setSp(12),
                                                  fontWeight: FontWeight.bold)),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: ScreenUtil().setSp(4),
                                                left: ScreenUtil().setSp(5)),
                                            child: Text(
                                              ".....",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                          Text(shift.shiftDTO.time_end ?? '',
                                              style: TextStyle(
                                                 color: Colors.red,
                                                  fontSize: ScreenUtil().setSp(12),
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: ScreenUtil().setSp(500),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listStadium.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    _buildItemStadium(index + 1),
                                    Expanded(
                                      child: Container(
                                        width: ScreenUtil().setSp(50),
                                        height: ScreenUtil().setSp(600),
                                        child: ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: listStadium[index]
                                              .statusShiftResponses
                                              .length,
                                          itemBuilder: (context, index1) {
                                            return _buildShift(
                                                listStadium[index]
                                                    .statusShiftResponses[index1],
                                                index1,listStadium[index]
                                              .statusShiftResponses
                                              .length,);
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
                    ) : Container()
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(ScreenUtil().setSp(10)),
            height: ScreenUtil().setSp(80),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDes("Sân trống", 0),
                    _buildDes("Chờ xác nhận", 1),
                    _buildDes("Chưa thanh toán", 2),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setSp(5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                      _buildDes("Đã thanh toán", 3),
                      SizedBox(width: ScreenUtil().setSp(10),),
                    _buildDes("Bị hủy", 4)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  _showDatePicker(){
                     DatePicker.showDatePicker(context,
                    
                      minTime:DateTime(2019, 10, 30),
                      maxTime: DateTime(2020, 12, 30),
                       onConfirm: (date) {
                    setState(() {
                      datePicker = date.toString().substring(0, 10);
                      if (datePicker ==
                          DateTime.now().toString().toString().substring(0, 10)) {
                        dateView = "Hôm nay";
                      } else {
                        dateView = datePicker;
                      }
                      refreshData();
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }
  _buildDes(title,status){
    return Row(
      children: <Widget>[
        Image.asset("assets/images/${_stringImage(status)}",width: ScreenUtil().setSp(25),),
        SizedBox(width: ScreenUtil().setSp(8),),
        Text(title,style: TextStyle(
          color: CommonColor.textBlack,
          fontSize: ScreenUtil().setSp(12),
        ),)
      ],
    );
  }
  _buildShift(Shift shift, index, length) {
    return GestureDetector(
      onTap: ()async{
         Navigator.push(context, MaterialPageRoute(builder: (context)=> ShiftDetailPage(shift,datePicker))).then((data){
           refreshData();
         });
      } ,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: Colors.green),
                top: index == 0
                    ? BorderSide(color: Colors.green)
                    : BorderSide(
                        width: 0,
                      ),
                bottom: BorderSide(color: Colors.green),
                right: index == length
                    ? BorderSide(color: Colors.green)
                    : BorderSide(
                        width: 0,
                      ),
              )),
          width: ScreenUtil().setSp(50),
          height: ScreenUtil().setSp(50),
          child: Center(
            child: Container(
              width: ScreenUtil().setSp(25),
              height: ScreenUtil().setSp(25),
              color: Colors.white,
              // decoration: BoxDecoration(
              //     color: shift.status == 0 ? Colors.green : Colors.red , borderRadius: BorderRadius.circular(100)),
              child: Image.asset("assets/images/${_stringImage(shift.status)}",width: ScreenUtil().setSp(50),),
            ),
          )),
    );
  }

  String _stringImage (status){
    if(status == 0){
      return "ball_green.png";
    }else if(status == 1){
      return "ball_yellow.png";
    }else if(status == 2){
      return "ball_blue.png";
    }else if(status == 3){
      return "ball_red.png";
    }else{
      return "cancel_icon.jpg";
    }
  }
  _timeWidget(text) {
    return Container(
        height: ScreenUtil().setSp(40),
        child: Center(
            child: Text(
          text,
          style: TextStyle(fontSize: ScreenUtil().setSp(14)),
        )));
  }

  _buildItemStadium(int index) {
    return Container(
      width: ScreenUtil().setSp(50),
      height: ScreenUtil().setSp(50),
      padding: EdgeInsets.all(12),
      child: Container(
        width: ScreenUtil().setSp(25),
        height: ScreenUtil().setSp(25),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            index.toString(),
            style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      ),
    );
  }
}
