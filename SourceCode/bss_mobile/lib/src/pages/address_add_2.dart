import 'package:bss_mobile/src/pages/address_add_3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/style/color.dart';

class AddressAddPage2 extends StatefulWidget {
  String name;
  String cityId;
  String districtId;
  String comuneId;
  String address;
  String description;

  AddressAddPage2(
      {this.name,
      this.cityId,
      this.districtId,
      this.comuneId,
      this.address,
      this.description});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdddressAddPage2State();
  }
}

class _AdddressAddPage2State extends State<AddressAddPage2> {
  TextEditingController desController = TextEditingController();

  bool _eneble7 = false;
  bool _eneble9 = false;
  bool _eneble11 = false;

  int typeStadium;

  List<Object> listStadiumFirst = List<Object>();

  @override
  void dispose() {
    // TODO: implement dispose
    desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(gradient: CommonColor.leftRightLinearGradient),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "Thêm sân",
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
                  itemCount: listStadiumFirst.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setSp(10),
                          right: ScreenUtil().setSp(10)),
                      child:
                          _buildAddStadiumCard(listStadiumFirst[index], index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _footer(),
      ),
    );
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
        onTap: () {
          List<dynamic> list = List<dynamic>();
          for (int i = 0; i < listStadiumFirst.length; i++) {
            dynamic stadium = listStadiumFirst[i];
            dynamic object = {
              "name": "Sân ${i + 1}",
              "maType": stadium['type'],
              "description":"${stadium['des']}"
            };
            list.add(object);
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddressAdd3Page(
                        name: widget.name,
                        address: widget.address,
                        cityId: widget.cityId,
                        communeId: widget.comuneId,
                        description: widget.description,
                        districtId: widget.districtId,
                        listStadium: list,
                      )));
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
          Text(
            "Loại sân",
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(16)),
          ),
          SizedBox(
            height: ScreenUtil().setSp(5),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: ScreenUtil().setSp(40),
              ),
              _buildNumber(7, _eneble7),
              SizedBox(
                width: 10,
              ),
              _buildNumber(9, _eneble9),
              SizedBox(
                width: 10,
              ),
              _buildNumber(11, _eneble11),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Mô tả",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(16)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                padding: EdgeInsets.only(left: 7, right: 7),
                width: ScreenUtil().setSp(200),
                constraints: BoxConstraints(minHeight: ScreenUtil().setSp(30)),
                color: Colors.white,
                child: TextField(
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  controller: desController,
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                ),
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
                    onTap: () => _addStadium(),
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

  _addStadium() {
    if (_eneble7 ||
        _eneble9 ||
        _eneble11 == true && desController.text.length > 0) {
      Object object = {"type": typeStadium, "des": "${desController.text}"};
      setState(() {
        listStadiumFirst.add(object);
      });
    }
  }

  _buildNumber(n, enable) {
    return GestureDetector(
      onTap: () {
        if (n == 7) {
          setState(() {
            _eneble7 = true;
            _eneble9 = _eneble11 = false;
            typeStadium = TypeStadium.STADIUM_TYPE7;
          });
        } else if (n == 9) {
          setState(() {
            _eneble9 = true;
            _eneble7 = _eneble11 = false;
            typeStadium = TypeStadium.STADIUM_TYPE9;
          });
        } else if (n == 11) {
          setState(() {
            _eneble11 = true;
            _eneble7 = _eneble9 = false;
            typeStadium = TypeStadium.STADIUM_TYPE11;
          });
        }
      },
      child: Container(
        width: ScreenUtil().setSp(60),
        height: ScreenUtil().setSp(30),
        decoration: BoxDecoration(
            color: !enable ? Colors.white : Colors.blue,
            borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(
            n.toString(),
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }

  _buildAddStadiumCard(stadium, index) {
    int type = stadium['type'];
    String des = stadium['des'];
    int number;
    if (type == 0) {
      number = 7;
    } else if (type == 1) {
      number = 9;
    } else {
      number = 11;
    }
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
                  "Sân " + (index + 1).toString(),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(20), color: Colors.white),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setSp(10),right: ScreenUtil().setSp(10),top: ScreenUtil().setSp(05)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Loại sân :",style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        color: CommonColor.textBlack,
                      ),),
                      Text(number.toString(),style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.bold,
                        color: CommonColor.textOrange,
                      ),)
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Mô tả :",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: CommonColor.textBlack,
                        ),),
                        Container(
                          width: ScreenUtil().setSp(170),
                          child: Text(des,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.normal,
                            color: CommonColor.textBlack,
                          ),),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
             Spacer(),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      listStadiumFirst.remove(stadium);
                    });
                  },
                  child: Container(
                    color: Color(0xffE7E7E7),
                    width: ScreenUtil().setSp(40),
                    child: Center(child: Image.asset("assets/images/remove_red.png")),
                  ),
                )
          ],
        ));
  }
}
