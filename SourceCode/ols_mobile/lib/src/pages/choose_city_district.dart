import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/widgets/header.dart';

// ignore: must_be_immutable
class ChooseCityDistrict extends StatefulWidget {
  String type;
  var list;
  ChooseCityDistrict({this.type, this.list});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChooseCityDistrictState();
  }
}

class ChooseCityDistrictState extends State<ChooseCityDistrict> {
  List<Object> data;
  @override
  void initState() {
    // TODO: implement initState
    data = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Header(
      title: widget.type == TypeAddress.CITY
          ? 'Chọn Tỉnh/Thành phố'
          : widget.type == TypeAddress.DISTRICT
              ? 'Chọn Quận/Huyện'
              : 'Chọn Xã/Phường',
      body: content(context),
    );
  }

  Widget content(context) {
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
            }));
  }

  renderItem(item, index) {
    return GestureDetector(
      onTap: () => _chooseItem(item),
      child: Container(
        color: index % 2 != 0 ? Colors.grey[100] : Colors.white,
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

  _chooseItem(item) {
    Navigator.pop(context, item);
  }
}
