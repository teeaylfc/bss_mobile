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
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height
      ),
      decoration: BoxDecoration(gradient: CommonColor.leftRightLinearGradient),
      child: Scaffold(
//      backgroundColor: CommonColor.backgroundColor,
        backgroundColor: Colors.white,
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
           
          },

          child: InternetConnectivity.internet
              ? ListView(
                  children: <Widget>[
                    
                  ],
                )
              : Container()
                ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
