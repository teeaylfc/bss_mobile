import 'dart:convert';

import 'package:ols_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/models/item_model.dart';
import 'package:ols_mobile/src/pages/main.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/coupon_card.dart';
import 'package:ols_mobile/src/widgets/coupon_count.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:intl/intl.dart';

class RedeemSuccessPage extends StatefulWidget {
  final List rewardItems;
  final String type;
  final double awardAmount;
  RedeemSuccessPage({this.type, this.rewardItems, this.awardAmount}) {}

  @override
  State<StatefulWidget> createState() {
    return _RedeemSuccessState();
  }
}

class _RedeemSuccessState extends State<RedeemSuccessPage> {
  List rewardItems = [];
  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  void initState() {
    super.initState();
    if (widget.rewardItems != null && widget.rewardItems.length > 0) {
      rewardItems = widget.rewardItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    double middlePadding = 60;
    if (rewardItems.length > 0) {
      middlePadding = 40;
    }
    // FlutterStatusbarcolor.setNavigationBarColor(Colors.orange[200]);
    // if (useWhiteForeground(Colors.green[400])) {
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    // } else {
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // }
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/redeem_success_bg.png"), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                bottomNavBarBloc.pickItem(PageIndex.DISCOVER);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
              },
              child: Icon(
                Icons.clear,
                size: 30,
              ),
            ),
            iconTheme: IconThemeData(color: CommonColor.textRed),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(top: rewardItems.length > 0 ? 20 : 70),
                      child: Column(
                        children: <Widget>[
                          Image(
                            height: rewardItems.length > 0 ? 50 : 70,
                            image: AssetImage('assets/images/check_icon.png'),
                          ),
                          SizedBox(
                            height: ScreenUtil().setSp(10),
                          ),
                          Text(
                            'Thank You!',
                            style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      'Payment made successfully',
                      style: TextStyle(color: Color(0xFFA9A9A9), fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                widget.awardAmount != null && widget.awardAmount != 0
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: middlePadding),
                            child: Center(
                              child: Text(
                                'Congratulation!\nYou have earned',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(22), fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: middlePadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/star.png',
                                    width: ScreenUtil().setSp(40),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setSp(10),
                                  ),
                                  Text(
                                    widget.awardAmount != null ? formatCurrency.format(widget.awardAmount) : '0.00',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setSp(10),
                                  ),
                                  Text(
                                    CYW_DOLLAR,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )),
                        ],
                      )
                    : Container(),
                _buildRewardCoupon()
              ],
            ),
          ),
          bottomNavigationBar: Container(
            child: Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0), child: _buildDoneButton(context)),
          )),
    );
  }

  _buildRewardCoupon() {
    return rewardItems != null && rewardItems.length > 0
        ? Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 18.0),
            child: SizedBox(
                height: ScreenUtil().setSp(200),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: rewardItems.length,
                    itemBuilder: (context, int index) {
                      var item = rewardItems[index];
                      // Item c = Item(id: item['offerId'], name: item['offerName'], image: item['image'], redemptionEndDate: item['redemptionEndDate']);

                      return Stack(
                        children: <Widget>[
                          ItemCard(
                            item: null,
                            showLocation: false,
                            width: ScreenUtil().setSp(168),
                            height: ScreenUtil().setSp(200),
                            imageHeight: ScreenUtil().setSp(112),
                            middleHeight: ScreenUtil().setSp(50),
                            footerHeight: ScreenUtil().setSp(30),
                            paddingRight: 8,
                            paddingBottom: 0,
                            pageContext: 'REWARD',
                          ),
                          Positioned(
                            right: 8,
                            child: CouponCount(count: item['quantity']),
                          )
                        ],
                      );
                    })),
          )
        : Container();
  }

  _buildDoneButton(context) {
    return Container(
      width: ScreenUtil().setSp(60),
      padding: const EdgeInsets.all(22.0),
      child: RaisedGradientButton(
          child: Text(
            'Done',
            style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
          ),
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)],
          ),
          height: ScreenUtil().setSp(40),
          onPressed: () {
            bottomNavBarBloc.pickItem(PageIndex.DISCOVER);
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
          }),
    );
  }
}
