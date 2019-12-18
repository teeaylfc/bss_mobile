import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/models/account_info_model.dart';
import 'package:bss_mobile/src/models/balance_detail_model.dart';
import 'package:bss_mobile/src/pages/bonus_point.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/widgets/header.dart';
import 'package:bss_mobile/src/widgets/showToast.dart';

class WalletBalance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BonusPointState();
  }
}

class BonusPointState extends State<WalletBalance> {
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController bonusPoint = new TextEditingController();
  TextEditingController mess = new TextEditingController();
  var statusBonus = false;
  bool disableBtn = true;
  DataService dataService = DataService();
  BalanceDetail balanceDetail;
  double soonExpiryBalance;

  @override
  void initState() {
    super.initState();
    getAccountInfo();
  }

  getAccountInfo() async {
    dataService.getBalanceDetail().then((data) {
      setState(() {
        balanceDetail = data;
        soonExpiryBalance = balanceDetail.soonExpiredBalance.soonExpiryBalance;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Header(
        body: Container(
          width: width,
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              !statusBonus
                  ? Expanded(child: _content(context))
                  : _content(context),
              // !statusBonus
              //     ? Container(
              //         width: width,
              //         decoration:
              //             BoxDecoration(color: Colors.white, boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey[300],
              //             blurRadius: 3.0,
              //             spreadRadius: 1.0,
              //             offset: new Offset(0.0, -3.0),
              //           )
              //         ]),
              //         child: _footer(context),
              //       )
              //     : _footer(context)
            ],
          ),
        ),
        title: FlutterI18n.translate(context, "wallet_balance.header"));
  }

  Widget _content(context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          width: width,
          margin: EdgeInsets.only(left: 18, top: 18, right: 18, bottom: 18),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                  offset: new Offset(0.0, 0.0),
                )
              ]),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/ic_point.png',
                          width: 42,
                          height: 42,
                        ),
                        Container(
                          child: Text(
                            balanceDetail != null
                                ? balanceDetail.balance.toString()
                                : "0",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                          margin: EdgeInsets.only(left: 10),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/ic_crown.png',
                      width: 42,
                      height: 42,
                    ),
                  ],
                ),
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 17, bottom: 17),
              ),
              Container(
                width: width,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 17, bottom: 17),
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(
                      color: Colors.grey[350],
                      width: 0.5,
                      style: BorderStyle.solid),
                  bottom: BorderSide(
                      color: Colors.grey[350],
                      width: 0.5,
                      style: BorderStyle.solid),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(context, "wallet_balance.goldClass"),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      child: Text(
                          FlutterI18n.translate(context, "wallet_balance.title", {"points": "245"})),
                      margin: EdgeInsets.only(top: 6),
                    )
                  ],
                ),
              ),
              Container(
                width: width,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 17, bottom: 17),
                child: Text(soonExpiryBalance != null
                    ? FlutterI18n.translate(context, "wallet_balance.footer", {"points": soonExpiryBalance.toString()})
                    : ""),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _footer(context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => _onPressBonusPoint(context),
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
          gradient: statusBonus
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFFF483D), const Color(0xFFF42E13)],
                  tileMode:
                      TileMode.repeated, // repeats the gradient over the canvas
                ),
        ),
        child: Text(
          FlutterI18n.translate(context, "wallet_balance.bonusPoints"),
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _onPressBonusPoint(context) async {
    var route = MaterialPageRoute(builder: (context) => BonusPoint());
    var status = await Navigator.push(context, route);
    if (status != null) {
      setState(() {
        statusBonus = true;
      });
      Toast(context: context, title: 'Tặng điểm thành công').showToast();
    }
  }
}
