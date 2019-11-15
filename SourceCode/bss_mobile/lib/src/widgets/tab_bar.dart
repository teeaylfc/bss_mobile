import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/style/color.dart';

import 'bubble_tab_indicator.dart';

class TabBarWidget extends StatelessWidget {
  List<Tab> tabs;
  TabController _tabController;
  double height;
  double width;

  TabBarWidget(this.tabs, this._tabController, {this.height = 38, this.width = 343});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ScreenUtil().setSp(0),
        right: ScreenUtil().setSp(0),
        top: ScreenUtil().setSp(10),
        bottom: ScreenUtil().setSp(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(width),
            height: ScreenUtil().setHeight(height),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFDCDCDC),
              ),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: TabBar(
              isScrollable: false,
              unselectedLabelColor: CommonColor.textGrey,
              labelColor: CommonColor.textGrey,
              labelStyle: TextStyle(
                color: CommonColor.textGrey,
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(14),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Color(0xFFDCDCDC),
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              indicator: BubbleTabIndicator(
                indicatorHeight: ScreenUtil().setHeight(38),
                indicatorColor: Color(0xFFDCDCDC),
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              tabs: tabs,
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}
