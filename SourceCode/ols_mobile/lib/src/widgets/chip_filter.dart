import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:flutter/material.dart';
import 'package:ols_mobile/src/blocs/bottom_navbar_bloc.dart';

class ChipFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      height: ScreenUtil().setSp(40),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          FilterChip(
            avatar: Image.asset(
              'assets/images/list_view.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            backgroundColor: Color(0xFFF1F3F4),
            label: Text(
              "All categories",
              style: TextStyle(color: CommonColor.textGrey),
            ),
            onSelected: (bool value) {
                     bottomNavBarBloc.pickItem(PageIndex.CATEGORY_LIST);
            },
          ),
          SizedBox(
            width: ScreenUtil().setSp(10),
          ),
          FilterChip(
            avatar: Image.asset(
              'assets/images/calendar_grey.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            backgroundColor: Color(0xFFF1F3F4),
            label: Text(
              "Booking services",
              style: TextStyle(color: CommonColor.textGrey),
            ),
            onSelected: (bool value) {
              print("selected");
            },
          ),
          SizedBox(
            width: ScreenUtil().setSp(10),
          ),
          FilterChip(
            backgroundColor: Color(0xFFF1F3F4),
            label: Text(
              "Merchant",
              style: TextStyle(color: CommonColor.textGrey),
            ),
            onSelected: (bool value) {
              print("selected");
            },
          ),
        ],
      ),
    );
    // End List Chips;
  }
}
