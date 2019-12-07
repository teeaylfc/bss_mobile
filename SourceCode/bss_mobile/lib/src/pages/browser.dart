import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/util/internet_connectivity.dart';
import 'package:bss_mobile/src/models/category_model.dart';
import 'package:bss_mobile/src/models/shift_model.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/raised_gradient_button.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'loading-grid.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BrowserPageState();
  }
}

class _BrowserPageState extends State<BrowserPage>
    with AutomaticKeepAliveClientMixin<BrowserPage> {
  DataService dataService = DataService();
  RefreshController _refreshController = RefreshController();
  bool loading;
  String errorMessage;
  int countListView = 10;
  List<Shift> listConfirm = List<Shift>();
  @override
  void initState() {
    _getData();
    super.initState();
  }
  void _onRefresh() async{
    // monitor network fetch
     await _getData();
     await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
  _getData()async{
    listConfirm = [];
    try{
      await dataService.getConfirm().then((data){
        for(int i = 0; i<data.length ; i++){
          Shift shift = Shift.fromJson(data[i]);
          listConfirm.add(shift);
        }
        setState(() {
          listConfirm = listConfirm;
        });
      });
    }catch(error){
      Reusable.showTotastError(error);
    }
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var scaffold = Scaffold(
    //      backgroundColor: CommonColor.backgroundColor,
            backgroundColor: Color(0xffE7E7E7),
            appBar: AppBar(
              backgroundColor: Colors.green,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              title: Text("Danh sách chờ xác nhận"),
              centerTitle: true,
              titleSpacing: 0.0,
            ),
            body: SmartRefresher(
              controller: _refreshController,
              onRefresh: () {
                  _onRefresh();
              },
              child: listConfirm != [] ? Padding(
          padding: EdgeInsets.all(15),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: listConfirm.length,
            itemBuilder: (context, index) {
              Shift shift = listConfirm[index];
              return Container(
                padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                margin: EdgeInsets.only(
                    top: ScreenUtil().setSp(10),
                    bottom: ScreenUtil().setSp(20)),
                width: ScreenUtil().setSp(300),
                height: ScreenUtil().setSp(100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 16.0,
                      color: Colors.black12,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(shift.user.fullName ?? '',style: TextStyle(color: CommonColor.textBlack,fontSize: ScreenUtil().setSp(14)),),
                        Text(shift.user.phone ?? '',style: TextStyle(color: CommonColor.textBlack,fontSize: ScreenUtil().setSp(14)),),
                      ],
                    ),
                    SizedBox(
                      width: ScreenUtil().setSp(30),
                    ),
                     Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(shift.addressDTO.name ?? '',style: TextStyle(color: CommonColor.textBlack,fontSize: ScreenUtil().setSp(15)),),
                        Text(shift.stadiumDTO.name ?? '',style: TextStyle(color: CommonColor.textBlack,fontSize: ScreenUtil().setSp(15)),),
                        Text( shift.shiftDTO.time_start+ " - " +shift.shiftDTO.time_end,style: TextStyle(color: CommonColor.textBlack,fontSize: ScreenUtil().setSp(15),fontWeight: FontWeight.bold),),
                        Text( shift.date ?? '',style: TextStyle(color: CommonColor.textBlack,fontSize: ScreenUtil().setSp(15)),),
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                                      Container(
                width: ScreenUtil().setSp(80),
                height: ScreenUtil().setSp(25),
                decoration: BoxDecoration(
                    color: Color(0xff595959),
                    borderRadius: BorderRadius.circular(40)),
                child: RaisedGradientButton(
                    gradient: LinearGradient(
                      colors: <Color>[Colors.red, Colors.red],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      stops: const <double>[0.0, 1],
                    ),
                    onPressed: () async {
                                            try {
                        await dataService.updateStatus(shift.id,ConfigStatusShift.CANCEL,"Xin lỗi ca này không thể đặt");
                        Reusable.showMessageDialog(true, "Hủy lịch thành công", context);
                        _getData();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      "Hủy lịch",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(13)),
                    )),
              ),
              SizedBox(
                height: ScreenUtil().setSp(10),
              ),
              Container(
                width: ScreenUtil().setSp(80),
                height: ScreenUtil().setSp(25),
                decoration: BoxDecoration(
                    gradient: CommonColor.commonButtonColor,
                    borderRadius: BorderRadius.circular(40)),
                child: RaisedGradientButton(
                    onPressed: () async {
                      try {
                        await dataService.updateStatus(shift.id,ConfigStatusShift.CONFIRMED_NOPAY,"");
                        Reusable.showMessageDialog(true, "Xác nhận thành công", context);
                        _getData();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      "Xác nhận",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(13)),
                    )),
              ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ) : Container(
          child: Center(child: Text("Hiện không có lịch đặt nào cần phải xác nhận", style: TextStyle(
            color: CommonColor.textBlack,
            fontSize: ScreenUtil().setSp(16),
          ),)),
        ),
                    ),
          );
        return Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          decoration: BoxDecoration(gradient: CommonColor.leftRightLinearGradient),
          child: scaffold,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
