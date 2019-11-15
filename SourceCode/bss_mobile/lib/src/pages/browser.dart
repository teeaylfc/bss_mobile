import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/util/internet_connectivity.dart';
import 'package:bss_mobile/src/models/category_model.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/coupon_card.dart';
import 'package:bss_mobile/src/widgets/error.dart';
import 'package:bss_mobile/src/widgets/no_internet.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:bss_mobile/src/widgets/search.dart';
import 'package:bss_mobile/src/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'loading-grid.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BrowserPageState();
  }
}

class _BrowserPageState extends State<BrowserPage> with AutomaticKeepAliveClientMixin<BrowserPage> {
  DataService dataService = DataService();
  RefreshController _refreshController = RefreshController();
  bool loading;
  String errorMessage;
  int countListView = 10;



  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
//      backgroundColor: CommonColor.backgroundColor,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Color(0xffF76016),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
//            gradient: CommonColor.commonLinearGradient
          color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(0xffE7E7E7),
                width: 1
              )
            )
          ),
        ),
        automaticallyImplyLeading: false,
        title: SearchField(bgColor: Color(0xffF4F4F4),),
        titleSpacing: 0.0,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () {
         
        },
        // header: CustomHeader(
        //     refreshStyle: RefreshStyle.Behind,
        //     builder: (c, m) {
        //       return Container(
        //         alignment: Alignment.bottomCenter,
        //         child: SpinKitFadingCircle(
        //           color: Colors.grey,
        //           size: ScreenUtil().setSp(20),
        //         ),
        //       );
        //     }),
        child: InternetConnectivity.internet
            ? ListView(
                children: <Widget>[
                ],
              )
            : Container()
              ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
