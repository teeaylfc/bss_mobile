import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/pages/main.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/notification_popup.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressAdd3Page extends StatefulWidget {
  String name;
  String cityId;
  String districtId;
  String communeId;
  String address;
  String description;
  List<dynamic> listStadium;

  AddressAdd3Page(
      {this.name,
      this.cityId,
      this.districtId,
      this.communeId,
      this.address,
      this.description,
      this.listStadium});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddressAdd3State();
  }
}

class AddressAdd3State extends State<AddressAdd3Page> {
  List<Object> listShiftFirst = List<Object>();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _cashController = TextEditingController();
  TimeOfDay pickedTime;

  DataService dataService = DataService();

  @override
  void dispose() {
    // TODO: implement dispose
    _startTimeController.dispose();
    _endTimeController.dispose();
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration:
            BoxDecoration(gradient: CommonColor.leftRightLinearGradient),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Thêm ca",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: true,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _buildAction(),
                SizedBox(
                  height: ScreenUtil().setSp(15),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listShiftFirst.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setSp(10),
                            right: ScreenUtil().setSp(10)),
                        child: _buildAddShiftCard(listShiftFirst[index], index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _footer(),
        ));
  }

  _footer() {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: ScreenUtil().setSp(80),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          blurRadius: 3.0,
          spreadRadius: 1.0,
          offset: new Offset(0.0, -3.0),
        )
      ]),
      child: GestureDetector(
        onTap: () async {
          List<dynamic> list = List<dynamic>();
          for (int i = 0; i < listShiftFirst.length; i++) {
            dynamic shift = listShiftFirst[i];
            dynamic object = {
              "name": i + 1,
              "time_start": "${shift['time_start']}",
              "time_end": "${shift['time_end']}",
              "cash": "${shift['cash']}",
            };
            list.add(object);
          }
          try {
            await dataService.creatAddress(
                widget.name,
                widget.address,
                widget.description,
                widget.cityId,
                widget.districtId,
                widget.communeId,
                widget.listStadium,
                list);
            showMessageDialog(
                true, "Thêm địa điểm thành công", context);
          } catch (error) {
            Reusable.showTotastError("Thêm địa điểm thất bại");
          }
        },
        child: Container(
          width: width,
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20),
            bottom: ScreenUtil().setHeight(17),
            top: ScreenUtil().setHeight(17),
          ),
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setHeight(12),
            top: ScreenUtil().setHeight(12),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF0A4DD0),
            borderRadius: BorderRadius.circular(25),
            gradient: CommonColor.leftRightLinearGradient,
          ),
          child: Text(
            'Tiếp tục',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  _buildAction() {
    return Container(
      padding: EdgeInsets.only(
          top: ScreenUtil().setSp(8),
          left: ScreenUtil().setSp(8),
          bottom: ScreenUtil().setSp(8)),
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: ScreenUtil().setSp(130),
      ),
      decoration: BoxDecoration(color: Colors.green, boxShadow: [
        BoxShadow(
            color: Colors.transparent,
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 0))
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setSp(5),
          ),
          Text(
            "Thời gian :",
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(16)),
          ),
          SizedBox(
            height: ScreenUtil().setSp(10),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: ScreenUtil().setSp(10),
              ),
              Text(
                "Bắt đầu",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(16)),
              ),
              SizedBox(
                width: ScreenUtil().setSp(7),
              ),
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay response = await showTimePicker(
                        context: context,
                        initialTime: pickedTime ?? TimeOfDay.now(),
                      );
                      if (response != null && response != pickedTime) {
                        setState(() {
                          pickedTime = response;
                          _startTimeController.text = response.hour.toString() +
                              ":" +
                              response.minute.toString();
                        });
                      } else {
                        setState(() {
                          _startTimeController.text = response.hour.toString() +
                              ":" +
                              response.minute.toString();
                        });
                      }
                    },
                    child: Container(
                      height: ScreenUtil().setSp(30),
                      padding: EdgeInsets.only(left: 7, right: 7),
                      width: ScreenUtil().setSp(90),
                      constraints:
                          BoxConstraints(minHeight: ScreenUtil().setSp(30)),
                      color: Colors.white,
                      child: TextField(
                        enabled: false,
                        controller: _startTimeController,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Image.asset(
                      "assets/images/time_start_icon.png",
                      width: ScreenUtil().setSp(23),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: ScreenUtil().setSp(7),
              ),
              Text(
                "Kết thúc",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(16)),
              ),
              SizedBox(
                width: ScreenUtil().setSp(7),
              ),
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay response = await showTimePicker(
                        context: context,
                        initialTime: pickedTime ?? TimeOfDay.now(),
                      );
                      if (response != null) {
                        setState(() {
                          pickedTime = response;
                          _endTimeController.text = response.hour.toString() +
                              ":" +
                              response.minute.toString();
                        });
                      } else {
                        setState(() {
                          _endTimeController.text = response.hour.toString() +
                              ":" +
                              response.minute.toString();
                        });
                      }
                    },
                    child: Container(
                      height: ScreenUtil().setSp(30),
                      padding: EdgeInsets.only(left: 7, right: 7),
                      width: ScreenUtil().setSp(90),
                      constraints:
                          BoxConstraints(minHeight: ScreenUtil().setSp(30)),
                      color: Colors.white,
                      child: TextField(
                        enabled: false,
                        controller: _endTimeController,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Image.asset(
                      "assets/images/time_icon_picker.png",
                      width: ScreenUtil().setSp(20),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Giá thuê:",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(16)),
              ),
              SizedBox(
                width: 5,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 7, right: 50),
                    width: ScreenUtil().setSp(180),
                    constraints:
                        BoxConstraints(minHeight: ScreenUtil().setSp(30)),
                    color: Colors.white,
                    child: TextField(
                      controller: _cashController,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Positioned(
                    top: ScreenUtil().setSp(9),
                    right: ScreenUtil().setSp(5),
                    child: Text(
                      "VND",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: ScreenUtil().setSp(15),
              ),
              Container(
                width: ScreenUtil().setSp(60),
                height: ScreenUtil().setSp(30),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _addShift(),
                    child: Text(
                      "Thêm",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: Colors.black),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _addShift() {
    if (_startTimeController.text != '' &&
        _endTimeController.text != '' &&
        _cashController.text != '') {
      dynamic object = {
        "time_start": "${_startTimeController.text}",
        "time_end": "${_endTimeController.text}",
        "cash": "${_cashController.text}",
      };
      setState(() {
        listShiftFirst.add(object);
      });
    }
  }

  _buildAddShiftCard(shift, index) {
    String start = shift['time_start'];
    String end = shift['time_end'];
    String cash = shift['cash'];
    return Container(
        margin: EdgeInsets.only(top: ScreenUtil().setSp(20)),
        padding: EdgeInsets.only(
            left: ScreenUtil().setSp(10), right: ScreenUtil().setSp(10)),
        width: MediaQuery.of(context).size.width,
        height: ScreenUtil().setSp(60),
        decoration: BoxDecoration(color: Color(0xffE7E7E7)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: ScreenUtil().setSp(60),
              width: ScreenUtil().setSp(60),
              color: Colors.green,
              child: Center(
                child: Text(
                  "Ca " + (index + 1).toString(),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(20), color: Colors.white),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(10),
                  right: ScreenUtil().setSp(10),
                  top: ScreenUtil().setSp(05)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Thời gian :",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: CommonColor.textBlack,
                        ),
                      ),
                      Text(
                        start + "-" + end,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.bold,
                          color: CommonColor.textOrange,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(7),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Giá : ",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color: CommonColor.textBlack,
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setSp(170),
                          child: Text(
                            cash.toString() + " VNĐ",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.bold,
                              color: CommonColor.textBlack,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  listShiftFirst.remove(shift);
                });
              },
              child: Container(
                color: Color(0xffE7E7E7),
                width: ScreenUtil().setSp(40),
                child:
                    Center(child: Image.asset("assets/images/remove_red.png")),
              ),
            )
          ],
        ));
  }

showMessageDialog(success,text,context) {
    containerForSheet<String>(
        context: context,
        child: Container(
          child: MessagePopup(success: success, title1: text),
        ),
    );
  }

containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
          return child;
        }).then<void>((T value) {
                      Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (Route<dynamic> route) => false,
              );
    });
  }
}
