import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/widgets/header.dart';

// ignore: must_be_immutable
class ChooseCityDistrict extends StatefulWidget{
  String type;
  ChooseCityDistrict({this.type});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChooseCityDistrictState();
  }
}

class ChooseCityDistrictState extends State<ChooseCityDistrict>{
  List data = [
    {
      "id": "1",
      "name": "Hà Nội"
    },
    {
      "id": "2",
      "name": "Bắc Giang"
    },
    {
      "id": "3",
      "name": "Thái Nguyên"
    },
    {
      "id": "4",
      "name": "Nam Định"
    },
    {
      "id": "5",
      "name": "Thái Bình"
    },
    {
      "id": "6",
      "name": "Bắc Ninh"
    },
    {
      "id": "7",
      "name": "Hải Dương"
    },
    {
      "id": "8",
      "name": "Thanh Hóa"
    },

  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      title: widget.type == TypeAddress.CITY? 'Chọn Tỉnh/Thành phố' : 'Chọn Quận/Huyện',
      body: content(context),
    );
  }
  Widget content(context){
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      color: Colors.white,
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(5),
        bottom: ScreenUtil().setWidth(5),
      ),
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return renderItem(data[index], index);
          })
      );
  }
  renderItem(item,index){
    return GestureDetector(
      onTap: ()=> _chooseItem(item),
      child:  Container(
        color: index%2 != 0 ? Colors.grey[100] : Colors.white,
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(15),
          bottom: ScreenUtil().setWidth(15),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
        ),
        child: Text(item['name']),
      ),
    );
  }
  _chooseItem(item){
    Navigator.pop(context, item);
  }
}