import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingGridPage extends StatelessWidget {
  final int itemCount;
  final double itemWidth;

  final double itemHeight;

  LoadingGridPage({this.itemCount = 2, this.itemWidth, this.itemHeight});

  @override
  Widget build(BuildContext context) {
    final array = Iterable<int>.generate(itemCount).toList();
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          child: Wrap(
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 10,
            children: array
                .map((_) => Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // width: MediaQuery.of(context).size.width / 4,
                            // height: MediaQuery.of(context).size.width / 4.5,
                            width: itemWidth,
                            height: itemHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: itemWidth,
                            height: ScreenUtil().setSp(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
