import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/exception/http_code.dart';
import 'package:ols_mobile/src/common/exception/http_error_event.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/util/internet_connectivity.dart';
import 'package:ols_mobile/src/models/item_model.dart';
import 'package:ols_mobile/src/models/list_item_model.dart';
import 'package:ols_mobile/src/models/user_modal.dart';
import 'package:ols_mobile/src/pages/page_state.dart';
import 'package:ols_mobile/src/pages/sign_in.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/service/stellar_data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/bubble_tab_indicator.dart';
import 'package:ols_mobile/src/widgets/coupon_card.dart';
import 'package:ols_mobile/src/widgets/no_internet.dart';
import 'package:ols_mobile/src/widgets/refresh_footer.dart';
import 'package:ols_mobile/src/widgets/refresh_header.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:ols_mobile/src/widgets/shopping_cart.dart';
import 'package:ols_mobile/src/widgets/tab_bar.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class StadiumManagerPage extends StatefulWidget {
  StadiumManagerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WalletPageState();
  }
}

class _WalletPageState extends PageState<StadiumManagerPage> with AutomaticKeepAliveClientMixin<StadiumManagerPage>, SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<EasyRefreshState> _easyRefreshKey2 = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshHeaderState> _headerKey2 = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshFooterState> _footerKey2 = new GlobalKey<RefreshFooterState>();

  final formatCurrency = NumberFormat.simpleCurrency();

  DataService dataService = DataService();
  StellarDataService stellarDataService = StellarDataService();

  ApplicationBloc applicationBloc;
  List<Item> listFavoriteItem = List<Item>();
  List<MyReward> listMyReward = List<MyReward>();

  User currentUser;
  EventBus eventBus = EventBus();

  String balance;

  String selectedStatus;

  bool isLoadingBalance = false;

  var imageUrl;

  var top = 0.0;

  final List<Tab> tabs = <Tab>[Tab(text: "Ưu đãi của tôi"), Tab(text: "Ưu đãi yêu thích")];
  TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
//
//    _tabController = new TabController(vsync: this, length: tabs.length);
//
//    InternetConnectivity.checkConnectivity();
//
//    selectedStatus = TabWallet.MY_REWARD;
//
//    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
//
//    listFavoriteItem = List<Item>();
//
//    bool loading = false;
//
//    currentUser = applicationBloc.currentUserValue.value;
//    if (currentUser == null) {
//    } else {
//      imageUrl = currentUser.getImageUrl();
//      if (InternetConnectivity.internet) {
//        _initUserData();
//      }
//    }
//    applicationBloc.notifyEvent.listen((data) {
//      if (data == AppEvent.RELOAD_WALLET) {
//        refreshData();
//      }
//    });
//
//    _tabController.addListener(() {
//      if (!_tabController.indexIsChanging) {
//        if (_tabController.index == 0) {
//          selectedStatus = TabWallet.MY_REWARD;
//        } else if (_tabController.index == 1) {
//          selectedStatus = TabWallet.MY_FAVORITE_ITEM;
//        }
//        refreshData();
//      }
//    });
//
//    HttpCode.eventBus.on<HttpErrorEvent>().listen((event) {
//      if (event.code == 401) {
//        BlocProvider.of<ApplicationBloc>(context).logout();
//        HttpCode.eventBus.destroy();
//        Navigator.of(context).push(new MaterialPageRoute<Null>(
//            builder: (BuildContext context) {
//              return SignInPage();
//            },
//            fullscreenDialog: true));
//      }
//    });
  }

  _initUserData() {
    InternetConnectivity.checkConnectivity().then((data) {
      if (InternetConnectivity.internet) {
        refreshData();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: CommonColor.commonLinearGradient),
        ),
        title: _buildHeader(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: CommonColor.backgroundColor,
        child: Center(
          child: Text("Đây là trang Quản lý địa điểm"),
        )
      ),
    );
  }

  _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setSp(14),
          ),
          child: Text(
            FlutterI18n.translate(context, "walletDeals.header"),
            style: TextStyle(fontSize: ScreenUtil().setSp(22), color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(
            right: ScreenUtil().setSp(14),
          ),
          child: ShoppingCart(),
        )
      ],
    );
  }

  Widget _buildListWallet() {
    return EasyRefresh(
      autoLoad: false,
      key: _easyRefreshKey2,
      refreshHeader: CustomRefreshHeader(
        loadingColor: Colors.grey,
        color: CommonColor.backgroundColor,
        key: _headerKey2,
      ),
      refreshFooter: CustomRefreshFooter(
        backgroundColor: Colors.white,
        key: _footerKey2,
      ),
      child: CustomScrollView(physics: AlwaysScrollableClampingScrollPhysics(), semanticChildCount: listMyReward.length, slivers: <Widget>[
        buildListReward()
      ]),
      onRefresh: () async {
        refreshData();
      },
      loadMore: () async {
        loadMoreData();
      },
    );
  }

  Widget _buildListWallet2() {
    return EasyRefresh(
      autoLoad: false,
      key: _easyRefreshKey,
      refreshHeader: CustomRefreshHeader(
        loadingColor: Colors.grey,
        color: CommonColor.backgroundColor,
        key: _headerKey,
      ),
      refreshFooter: CustomRefreshFooter(
        backgroundColor: Colors.white,
        key: _footerKey,
      ),
      child: CustomScrollView(physics: AlwaysScrollableClampingScrollPhysics(), semanticChildCount: listMyReward.length, slivers: <Widget>[
        buildListMyFavorite()
      ]),

      onRefresh: () async {
        refreshData();
      },
      loadMore: () async {
        loadMoreData();
      },
    );
  }
  Widget buildListReward() {
    return listMyReward != null && listMyReward.length > 0
        ? SliverPadding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var item = listMyReward[index];
                  return ItemCard(
                    voucherCode: item.voucherCode,
                    item: item.item,
                    showLocation: false,
                    width: ScreenUtil().setSp(345),
                    height: ScreenUtil().setSp(288),
                    imageHeight: ScreenUtil().setSp(179),
                    middleHeight: ScreenUtil().setSp(61),
                    footerHeight: ScreenUtil().setSp(45),
                    paddingRight: 0,
                    paddingBottom: ScreenUtil().setSp(20),
                    pageContext: 'WALLET',
                    callbackRedeem: Reusable.showTotastError,
                    callbackRemoveCoupon: _removeCoupon,
                    dataService: dataService,
                    displayType: 'BIG_CARD',
                  );
                },
                childCount: listMyReward.length,
              ),
            ),
          )
        : SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, ScreenUtil().setSp(60), 0, 0),
              child: Center(
                child: Text(
                  "You don't have any Items in your wallet yet",
                  style: TextStyle(fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w300),
                ),
              ),
            ),
          );
  }

  Widget buildListMyFavorite() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(16),
          right: ScreenUtil().setWidth(16),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: listFavoriteItem.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: ScreenUtil().setSp(168)/ScreenUtil().setSp(202),
            mainAxisSpacing: 7.0,
            crossAxisSpacing: 7.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            Item item = listFavoriteItem[index];
            return ItemCard(
              item: item,
              showLocation: true,
              star: item.itemPrice != null ? item.itemPrice.toString() : '50',
              width: ScreenUtil().setSp(168),
              height: ScreenUtil().setSp(202),
              imageHeight: ScreenUtil().setSp(109),
              middleHeight: ScreenUtil().setSp(50),
              footerHeight: ScreenUtil().setSp(35),
              paddingRight: 0,
              paddingBottom: 0,
              displayType: DisplayType.GRID,
            );
          },
        ),
      ),
    );
  }
  _removeCoupon(couponId, status) async {
    try {
      final res = await dataService.removeItemFromWallet(couponId, status);
      refreshData();
//      _showMessageUndoDialog(true);
    } catch (error) {
      Reusable.showTotastError(error.message);
    }
  }

  @override
  Future initData() {
    setState(() {
      listFavoriteItem = [];
    });
  }

  @override
  Future loadMoreData() async {
    if (!last) {
      page = page + 1;
      getWallet();
    } else {
      print('last page..........');
    }
  }

  @override
  Future refreshData() async {
    page = 0;
    getWallet();
  }

  getWallet() async {
    try {
      if (page == 0) {
        setState(() {
          listFavoriteItem = [];
          listMyReward = [];
        });
      }
      if (TabWallet.MY_FAVORITE_ITEM == selectedStatus) {
        ListItem listItem = await dataService.getFavoritesItem(page);
        setState(() {
          listFavoriteItem.addAll(listItem.content);
          last = listItem.last;
        });
      } else if (TabWallet.MY_REWARD == selectedStatus) {
        ListMyReward listItem = await dataService.getMyReward(page);
        setState(() {
          listMyReward.addAll(listItem.content);
          last = listItem.last;
        });
      }
    } catch (error) {
      Reusable.handleHttpError(context, error, applicationBloc);
    }
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
          return child;
        }).then<void>((T value) {});
  }
}
