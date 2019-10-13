import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/models/item_model.dart';
import 'package:ols_mobile/src/models/list_transaction_model.dart';
import 'package:ols_mobile/src/models/redeem_history_model.dart';
import 'package:ols_mobile/src/pages/page_state.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/bubble_tab_indicator.dart';
import 'package:ols_mobile/src/widgets/merchant_image.dart';
import 'package:ols_mobile/src/widgets/refresh_footer.dart';
import 'package:ols_mobile/src/widgets/refresh_header.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:ols_mobile/src/widgets/tab_bar.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage();

  @override
  State<StatefulWidget> createState() {
    return _TransactionHistoryPageState();
  }
}

class _TransactionHistoryPageState extends PageState<TransactionHistoryPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<EasyRefreshState> _easyRefreshKey2 =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshHeaderState> _headerKey2 =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshFooterState> _footerKey2 =
      new GlobalKey<RefreshFooterState>();

  final List<Tab> tabs = <Tab>[
    Tab(text: "Lịch sử đổi quà"),
    Tab(text: "Lịch sử điểm")
  ];
  TabController _tabController;

  final formatCurrency = NumberFormat.simpleCurrency();
  DataService dataService = DataService();
  List<Transaction> transactionList = List<Transaction>();
  List<RedeemHistory> redeemHistoryList = List<RedeemHistory>();
  String fromDate;
  String toDate;
  String selectedStatus;
  List<DateTime> pickedDay;

  @override
  void initState() {
    super.initState();

    final currentDate = DateTime.now();
    _tabController = new TabController(vsync: this, length: tabs.length);

    var month = currentDate.month.toString();
    if (month.length == 1) {
      month = '0$month';
    }
    dataService.getListRedeemHistory(0, '', '').then((data){
      redeemHistoryList.addAll(data.content);
      last = data.last;
    });
    selectedStatus = TransactionStatus.GIFTHISTORY;
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          selectedStatus = TransactionStatus.GIFTHISTORY;
        } else if (_tabController.index == 1) {
          selectedStatus = TransactionStatus.POINTHISTORY;
        }
      }
      refreshData();
    });
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            FlutterI18n.translate(
                context, 'transactionHistoryPage.transactionHistory'),
            style: TextStyle(
                color: Color(0xff343434), fontSize: ScreenUtil().setSp(16)),
          ),
        ),
        elevation: 0.7,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff343434),
            size: ScreenUtil().setSp(20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
              icon: Image.asset(
                "assets/images/filter_ic.png",
                width: ScreenUtil().setSp(16),
              ),
              onPressed: () async {
                _showTimePicker();
              })
        ],
      ),
      body: Container(
        color: Color(0xffF7F7F7),
        child: Column(
          children: <Widget>[
            TabBarWidget(tabs, _tabController),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setSp(15), right: ScreenUtil().setSp(15)),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _buildListTransaction(),
                  _buildListTransaction2()
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  _showTimePicker() async {
    if (pickedDay == null || pickedDay.length == 1) {
      pickedDay = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: (DateTime.now()).subtract(Duration(days: 7)),
        initialLastDate: DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020),
      );
    } else {
      pickedDay = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: pickedDay[0],
        initialLastDate: pickedDay[1],
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020),
      );
    }

    if (pickedDay != null && pickedDay.length == 2) {
      fromDate = pickedDay[0].toString().substring(0, 10);
      toDate = pickedDay[1].toString().substring(0, 10);
      refreshData();
    }
  }

  Widget _buildListTransaction() {
    return EasyRefresh(
      autoLoad: false,
      key: _easyRefreshKey,
      refreshHeader: CustomRefreshHeader(
        color: CommonColor.backgroundColor,
        key: _headerKey,
      ),
      refreshFooter: CustomRefreshFooter(
        key: _footerKey,
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          _selectTime(),
          checkList()
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var item;
                      item = transactionList[index];
                         return _buildItemList(item);
                    },
                    childCount:
                        transactionList.length
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                      child: GestureDetector(
                        child: Text(
                          FlutterI18n.translate(
                              context, 'transactionHistoryPage.noTransaction'),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: CommonColor.textBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      onRefresh: () async {
        refreshData();
      },
      loadMore: () async {
        loadMoreData();
      },
    );
  }

  Widget _buildListTransaction2() {
    return EasyRefresh(
      autoLoad: false,
      key: _easyRefreshKey2,
      refreshHeader: CustomRefreshHeader(
        color: CommonColor.backgroundColor,
        key: _headerKey2,
      ),
      refreshFooter: CustomRefreshFooter(
        key: _footerKey2,
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          _selectTime(),
          checkList()
              ? SliverList(
            delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  var item;
                  item = redeemHistoryList[index];
                  return _buildPointList(item);
                },
                childCount:
                redeemHistoryList.length
            ),
          )
              : SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(top: 100),
              child: Center(
                child: GestureDetector(
                  child: Text(
                    FlutterI18n.translate(
                        context, 'transactionHistoryPage.noTransaction'),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      color: CommonColor.textBlack,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      onRefresh: () async {
        refreshData();
      },
      loadMore: () async {
        loadMoreData();
      },
    );
  }

  _selectTime() {
    if (pickedDay != null && pickedDay.length == 2) {
      return SliverAppBar(
          pinned: true,
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          elevation: 0.6,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: InkWell(
              onTap: () => _showTimePicker(),
              child: Center(
                child: Text(
                  FlutterI18n.translate(
                          context, 'transactionHistoryPage.time') +
                      ': $fromDate  '+ FlutterI18n.translate(
                    context, 'transactionHistoryPage.to')+ ' $toDate ',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: CommonColor.textBlack,
                  ),
                ),
              ),
            ),
          ));
    } else {
      return SliverToBoxAdapter(
        child: Container(),
      );
    }
  }

  _buildPointList(RedeemHistory item) {
    return Container(
      width: ScreenUtil().setSp(345),
      constraints: BoxConstraints(
        minHeight: ScreenUtil().setSp(122),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1.0,
              spreadRadius: 1.0,
              offset: Offset(
                1.0, // horizontal, move right 10
                1.0, // vertical, move down 10
              ),
            )
          ]),
      margin: EdgeInsets.only(top: ScreenUtil().setSp(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setSp(10), 0, ScreenUtil().setSp(10), 0),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: Colors.black12,
              ),
            )),
            height: ScreenUtil().setSp(35),
            child: Row(
              children: <Widget>[
                Text(
                  item.item.itemName,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    fontWeight: FontWeight.bold,
                    color: Color(0xff343434),
                  ),
                ),
                Spacer(),
                Text(
                  item.pointRedeem > 0 ? "+" + item.pointRedeem.toString() : item.pointRedeem.toString(),
                  style: TextStyle(
                      color: Color(0xffFD4435),
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setSp(10),
                ScreenUtil().setSp(8),
                ScreenUtil().setSp(10),
                ScreenUtil().setSp(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                      maxWidth: ScreenUtil().setSp(306),
                      minHeight: ScreenUtil().setSp(48)),
                  child: Text(
                    "Nội dung: " + (item.item.description ?? ''),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w500,
                      color: Color(0xff343434),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(6),
                ),
                Text(
                  dateFormat(item.redeemDate) ?? '',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF696969),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildItemList(Transaction item) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(345),
            constraints: BoxConstraints(minHeight: ScreenUtil().setSp(115)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      1.0, // horizontal, move right 10
                      1.0, // vertical, move down 10
                    ),
                  )
                ]),
            margin: EdgeInsets.only(
              top: ScreenUtil().setSp(15),
            ),
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(14),
              horizontal: ScreenUtil().setWidth(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MerchantImage(
                  imageId: item.storeImage,
                  height: ScreenUtil().setWidth(69),
                  width: ScreenUtil().setHeight(69),
                  radius: 4,
                ),
                SizedBox(
                  width: ScreenUtil().setSp(15),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      dateFormat(item.txnDatetime) ?? '',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF696969),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(6),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setWidth(230),
                        minHeight: ScreenUtil().setHeight(35),
                      ),
                      child: Text(
                        item.description ?? "",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff343434),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(10),
                    ),
                    Text(
                      item.point > 0 ? "+" + item.point.toString() : item.point.toString(),
                      style: TextStyle(
                          color: Color(0xffFD4435),
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: ScreenUtil().setHeight(15),
            child: Container(
              height: ScreenUtil().setHeight(32),
              width: ScreenUtil().setWidth(32),
              decoration: BoxDecoration(
                color: Color(0xFF27AE60),
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(8.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Center(
                    child: AutoSizeText(
                  '  x' + '2',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Future loadMoreData() async {
    if (!last) {
      page = page + 1;
      getTransactionList();
    } else {
      print('last page..........');
    }
  }

  @override
  Future refreshData() async {
    page = 0;
    getTransactionList();
  }

  getTransactionList() {
    if (selectedStatus == TransactionStatus.GIFTHISTORY) {
      dataService
          .getTransactionHistory(page, fromDate ?? '', toDate ?? '')
          .then((data) {
        setState(() {
          if (page == 0) {
            transactionList = [];
          }
          transactionList.addAll(data.content);
          last = data.last;
        });
      }).catchError((error) {
        Reusable.handleHttpError(context, error, "");
      });
    } else {
      dataService
          .getListRedeemHistory(page, fromDate ?? '', toDate ?? '')
          .then((data) {
        setState(() {
          if (page == 0) {
            redeemHistoryList = [];
          }
          redeemHistoryList.addAll(data.content);
          last = data.last;
        });
      }).catchError((error) {
        Reusable.handleHttpError(context, error, "");
      });
    }
  }

  String dateFormat(text) {
    String s;
    DateTime d = DateFormat("yyyy-MM-ddTHH:mm:ss", "en_US").parse(text);
    s = DateFormat("dd/MM/yyyy").format(d).toString();
    return s;
  }

  @override
  Future initData() {
    return null;
  }

  bool checkList() {
    if (selectedStatus == TransactionStatus.GIFTHISTORY) {
      if (transactionList != null && transactionList.length > 0) {
        return true;
      } else {
        return false;
      }
    } else {
      if (redeemHistoryList != null && redeemHistoryList.length > 0) {
        return true;
      } else {
        return false;
      }
    }
  }
}
