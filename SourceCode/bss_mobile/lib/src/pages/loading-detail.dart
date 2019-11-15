import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/pages/loading-list.dart';
import 'package:flutter/material.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:shimmer/shimmer.dart';

class LoadingDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.backgroundColor,
      body: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: ScreenUtil().setSp(300),
            child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  color: Colors.white,
                )),
          ),
          LoadingListPage(
            itemCount: 4,
          )
        ],
      ),
    );
  }
}
