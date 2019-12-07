import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/models/shift_model.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShiftDetailPage extends StatefulWidget {
  Shift shift;
  ShiftDetailPage(this.shift);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShiftState();
  }
}

class ShiftState extends State<ShiftDetailPage> {
  Shift shift;
  @override
  void initState() {
    shift = widget.shift;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Chi tiết ca",
          style:
              TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(16)),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: ScreenUtil().setSp(16),
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            _buildInfo("Trạng thái: ", _returnStatus(shift.status)),
            _buildInfo("Thời gian bắt đầu:", shift.shiftDTO.time_start),
             _buildInfo("Thời gian kết thúc:", shift.shiftDTO.time_end),
             _buildInfo("Giá thuê:", shift.shiftDTO.cash.toString()+" VNĐ"),
             _buildInfo("Người đặt", "Không có")
          ],
        ),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setSp(22), right: ScreenUtil().setSp(23)),
          width: MediaQuery.of(context).size.width,
          height: ScreenUtil().setSp(76),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: ScreenUtil().setSp(160),
                height: ScreenUtil().setSp(35),
                decoration: BoxDecoration(
                    color: Color(0xff595959),
                    borderRadius: BorderRadius.circular(40)),
                child: RaisedGradientButton(
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xff575757), Color(0xff575757)],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      stops: const <double>[0.0, 1],
                    ),
                    onPressed: () async {
                    },
                    child: Text(
                      "Hủy lịch",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(13)),
                    )),
              ),
              Container(
                width: ScreenUtil().setSp(160),
                height: ScreenUtil().setSp(35),
                decoration: BoxDecoration(
                    gradient: CommonColor.commonButtonColor,
                    borderRadius: BorderRadius.circular(40)),
                child: RaisedGradientButton(
                    onPressed: () async {

                    },
                    child: Text(
                      "Thêm lịch",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(13)),
                    )),
              ),
            ],
          ))
    );
  }

  _buildInfo(title, value) {
    return Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setSp(30),right: ScreenUtil().setSp(30),top: ScreenUtil().setSp(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title,style: TextStyle(fontSize: ScreenUtil().setSp(16),color: CommonColor.textBlack),),
          Text(value,style: TextStyle(fontSize: ScreenUtil().setSp(18),fontWeight : FontWeight.bold, color: CommonColor.textBlack),),
        ],
      ),
    );
  }
  _returnStatus(int status){
    switch (status) {
      case 0:
        return "Chưa được đặt";
         case 1:
        return "Chờ xác nhận";
         case 2:
        return "Đã xác nhận(Chưa thanh toán)";
         case 3:
        return "Đã xác nhận(Đã thanh toán)";
         case 4:
        return "Đã bị hủy";
        break;
      default: return "Chưa rõ";
    }
  }
}
