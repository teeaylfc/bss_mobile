import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/models/shipping_address_model.dart';
import 'package:ols_mobile/src/pages/choose_city_district.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/widgets/header.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';

class AddressAccepGift extends StatefulWidget {
  List<String> listItemCode;

  AddressAccepGift({this.listItemCode});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddressAccepGiftState();
  }
}

class AddressAccepGiftState extends State<AddressAccepGift> {
  TextEditingController name = new TextEditingController();
  TextEditingController company = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();
  DataService dataService = DataService();

  String city = 'Tỉnh/Thành phố';
  String district = 'Quận/Huyện';
  String commune = 'Xã/Phường';
  bool enableDistrict = false;
    bool enableCommune = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      title: 'Địa chỉ nhận quà',
      body: content(context),
    );
  }

  Widget content(context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        width: width,
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Container(
              child: Expanded(
                child: ListView(
                  children: <Widget>[
                    _inputText(
                        context, name, TextInputType.text, 'Tên sân vận động'),
                    _inputChoose(city, TypeAddress.CITY),
                    _inputChoose(district, TypeAddress.DISTRICT),
                     _inputChoose(commune, TypeAddress.COMMUNE),
                    _inputText(context, address, TextInputType.text, 'Địa chỉ'),
                  ],
                ),
              ),
            ),
            _footer(context)
          ],
        ),
      ),
    );
  }

  Widget _inputChoose(text, type) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap:(){
        if(type == TypeAddress.DISTRICT){
        return _chooseAddress(context,type);
        }else if(type == TypeAddress.COMMUNE){
        return _chooseAddress(context,type);
        }else if(type == TypeAddress.CITY){
         return _chooseAddress(context,type);
        }else{
          return null;
        }
      },
      child: Container(
        width: width,
        margin: EdgeInsets.only(
          right: ScreenUtil().setWidth(15),
          left: ScreenUtil().setWidth(15),
          top: ScreenUtil().setWidth(15),
        ),
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(10),
          right: ScreenUtil().setWidth(10),
          top: ScreenUtil().setWidth(12),
          bottom: ScreenUtil().setWidth(12),
        ),
        decoration: BoxDecoration(
            color: (type == TypeAddress.DISTRICT && !enableDistrict || type == TypeAddress.COMMUNE && !enableCommune)? Colors.grey[350] : Colors.white ,
            border: Border.all(color: Color(0xFFE7E7E7), width: 1),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(text),
            Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF696969),
              size: ScreenUtil().setWidth(20),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputText(context, controller, keyboardType, label) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: EdgeInsets.only(
        right: ScreenUtil().setWidth(15),
        left: ScreenUtil().setWidth(15),
        top: ScreenUtil().setWidth(15),
      ),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(10),
        right: ScreenUtil().setWidth(10),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE7E7E7), width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 8, bottom: 8),
          labelText: label,
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _footer(context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          blurRadius: 3.0,
          spreadRadius: 1.0,
          offset: new Offset(0.0, -3.0),
        )
      ]),
      child: GestureDetector(
        onTap: (){
          checkOut(context);
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
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFFFF483D), const Color(0xFFF42E13)],
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          child: Text(
            'Tiếp tục',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  _chooseAddress(context, type) async {
    var route = new MaterialPageRoute(
        builder: (context) => ChooseCityDistrict(
              type: type,
            ));
    var item = await Navigator.push(context, route);
    setState(() {
      if(type == TypeAddress.CITY){
        city = item['name'];
        enableDistrict = true;
      }
      else if(type == TypeAddress.DISTRICT){
        district = item['name'];
        enableCommune = true;
      } else if(type == TypeAddress.COMMUNE){
        district = item['name'];
      }
    });
  }
  checkOut(context) async{
    
  }
}


