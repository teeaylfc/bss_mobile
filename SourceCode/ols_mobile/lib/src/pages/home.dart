import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/http_client.dart';
import 'package:ols_mobile/src/common/util/image_util.dart';
import 'package:ols_mobile/src/common/util/internet_connectivity.dart';
import 'package:ols_mobile/src/models/account_info_model.dart';
import 'package:ols_mobile/src/models/category_model.dart';
import 'package:ols_mobile/src/models/list_item_model.dart';
import 'package:ols_mobile/src/models/store_model.dart';
import 'package:ols_mobile/src/models/user_modal.dart';
import 'package:ols_mobile/src/pages/coupon_detail.dart';
import 'package:ols_mobile/src/pages/loading-grid.dart';
import 'package:ols_mobile/src/pages/main.dart';
import 'package:ols_mobile/src/pages/qr_scanner.dart';
import 'package:ols_mobile/src/pages/store_info.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/service/stellar_data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/style/styles.dart';
import 'package:ols_mobile/src/widgets/category_card.dart';
import 'package:ols_mobile/src/widgets/coupon_card.dart';
import 'package:ols_mobile/src/widgets/item_card_home.dart';
import 'package:ols_mobile/src/widgets/m_point.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:ols_mobile/src/widgets/section_title.dart';
import 'package:ols_mobile/src/widgets/shopping_cart.dart';
import 'package:ols_mobile/src/widgets/store_item_home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'loading-card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  RefreshController _refreshController = RefreshController();

  ScrollController _scrollController = ScrollController();

  ApplicationBloc applicationBloc;
  DataService dataService = DataService();
  StellarDataService stellarDataService = StellarDataService();

  final formatCurrency = NumberFormat.simpleCurrency();

  Geolocator _geolocator;
  Position _position;

  String fullName;
  String imageUrl;

  String balance = '0.0';
  bool isLoadingBalance = false;
  bool isGettingLocation = false;
  double latitude;
  double longitude;

  List<Store> listStore = List<Store>();

  Future<ListItem> hotItemFuture;
  Future<ListItem> newestItemFuture;
  Future<ListItem> interestingItemFuture;
  Future<CategoryList> categoryListFuture;
  Future<ListItem> expireSoonFuture;
  Future<ListItem> viewNearlyItemFuture;

  static final countListView = 8;
  List<ScrollController> _listScroll = List<ScrollController>(countListView);
  List<double> _listPadding = List<double>(countListView);
  List<Function> _listFunction = List<Function>(countListView);



  bool loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
//    _initScrollController();
//    _geolocator = Geolocator();
//    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
//
//    // sroll to top page
//    applicationBloc.notifyEvent.listen((onData) {
//      if (AppEvent.SCROLL_HOME == onData) {
//        if (_scrollController.hasClients &&
//            _scrollController.position.pixels > 0.0) {
//          _scrollController.animateTo(0.0,
//              curve: Curves.easeOut,
//              duration: const Duration(milliseconds: 500));
//        }
//      }
//    });
//
//    applicationBloc.currentUserValue.listen((user) {
//      if (user != null) {
//        fullName = user.fullName;
//        imageUrl = user.getImageUrl();
//        getViewNearlyItem(0);
//        // balance = user.balance;
//        getBalance();
//      } else {
//        fullName = null;
//        imageUrl = null;
//        balance = '0.0';
//      }
//    });
//
//    // ///
//    // applicationBloc.orderCount.listen((count) {
//    //   orderCount = count;
//    // });
//
//    _initData();
//    checkLocaltionPermission();
  }

  _initScrollController(){
    for (int i = 0; i < _listScroll.length; i++) {
      _listScroll[i] = ScrollController();
      _listPadding[i] = 18;
      _listFunction[i] = () {
        if (_listScroll[i].hasClients) {
          if (_listScroll[i].offset >=
              _listScroll[i].position.minScrollExtent &&
              !_listScroll[i].position.outOfRange) {
            setState(() {
              _listPadding[i] = 0;
            });
          }
          if (_listScroll[i].offset <=
              _listScroll[i].position.minScrollExtent &&
              !_listScroll[i].position.outOfRange) {
            setState(() {
              _listPadding[i] = 18;
            });
          }
        }
      };
    }
    for (int i = 0; i < _listScroll.length; i++) {
      _listScroll[i].addListener(_listFunction[i]);
    }
  }


  getStoreList() {
    dataService.getStore("", false).then((data) {
      setState(() {
        listStore = [];
        listStore.addAll(data.content);
      });
    }).catchError((error) {
      Reusable.handleHttpError(context, error, applicationBloc);
    });
  }

  Future<Position> getCurrentLocation() async {
    try {
      setState(() {
        isGettingLocation = true;
      });
      return await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (error) {
      isGettingLocation = false;
    }
  }

  void checkLocaltionPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  Future<Null> _initData() async {
    /// initial data
    getHotItem(0);
    getNewestItem(0);
    getInterestingItem(0);
    getHomeCategory();
    getExpireSoon(0);
    getStoreList();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(child: Text("Đây là trang Home")),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: fullName != null
              ? ScreenUtil().setHeight(140)
              : ScreenUtil().setHeight(140),
          decoration: BoxDecoration(
            gradient: CommonColor.commonLinearGradient,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(45),
            left: ScreenUtil().setWidth(18),
            right: ScreenUtil().setWidth(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<User>(
                  stream: applicationBloc.currentUser,
                  builder: (context, AsyncSnapshot<User> snapshot) {
                    if (snapshot.hasData) {
                      // imageUrl = snapshot.data.imageURL;
                      fullName = snapshot.data.fullName;
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        fullName != null
                            ? Text(
                                FlutterI18n.translate(context, 'title') +
                                    ' ${fullName}!',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(20),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            : Container(
                                height: ScreenUtil().setHeight(10),
                              ),
                        Spacer(),
                        ShoppingCart()
                      ],
                    );
                  }),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesBrand(List<Store> listBranch) {
    return Column(
      children: <Widget>[
        SectionTitle(
          FlutterI18n.translate(context, 'homePage.store'),
          GestureDetector(
            onTap: () {
              bottomNavBarBloc.pickItem(PageIndex.STORE_LIST,
                  {'previousPage': 'HOME', 'type': 'TODAY_PICK'});
            },
            child: Text(
              FlutterI18n.translate(context, 'homePage.seeAll'),
              style: Styles.seeAllTextStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12, left: _listPadding[7]),
          child: SizedBox(
            height: ScreenUtil().setHeight(78),
            child: ListView.builder(
                controller: _listScroll[7],
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                itemCount: listBranch.length,
                itemBuilder: (context, i) {
                  Store item = listBranch[i];
                  return StoreItemHome(item);
                }),
          ),
        )
      ],
    );
  }

  _buildIconButton(image, text, callback) {
    return Expanded(
      child: InkWell(
        onTap: callback,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: image,
              onPressed: callback,
            ),
            Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(10),
                  fontWeight: FontWeight.w500,
                  height: 0.4),
            )
          ],
        ),
      ),
    );
  }

  Widget buildErrorText(AsyncSnapshot snapshot) {
    if (snapshot.hasError) {
      HttpError error = snapshot.error as HttpError;
      return Center(child: Text(error.message));
    }
    return Container();
  }

  _buildListHorizotal(
      future, width, height, subTextFontWeight, key, scrollController) {
    return FutureBuilder<ListItem>(
        future: future,
        builder: (context, AsyncSnapshot<ListItem> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: buildErrorText(snapshot),
              ),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                alignment: Alignment.topLeft,
                child: LoadingCard(
                  itemWidth: width,
                  itemHeight: height,
                ),
              );
            case ConnectionState.done:
              return ListView.builder(
                controller: scrollController,
                key: PageStorageKey(key),
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.content.length,
                itemBuilder: (context, int index) {
                  var item = snapshot.data.content[index];
                  return ItemCardHome(
                    item: item,
                    width: width,
                    height: height,
                    subTextFontWeight: subTextFontWeight,
                    padding: 10.0,
                  );
                },
              );
            default:
              Center(child: Text('Load data error....'));
          }
          return Container();
        });
  }

  _buildListHorizotal3(
      future, width, height, subTextFontWeight, key, scrollController) {
    return FutureBuilder<ListItem>(
        future: future,
        builder: (context, AsyncSnapshot<ListItem> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: buildErrorText(snapshot),
              ),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                alignment: Alignment.topLeft,
                child: LoadingCard(
                  itemWidth: width,
                  itemHeight: height,
                ),
              );
            case ConnectionState.done:
              return Swiper(
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  var item = snapshot.data.content[index];
                  return ItemCardHome(
                    item: item,
                    width: width,
                    height: height,
                    subTextFontWeight: subTextFontWeight,
                    padding: 0.0,
                  );
                },
                itemCount: snapshot.data.content.length,
//                viewportFraction: width / MediaQuery.of(context).size.width,
                scale: 1,
              );
            default:
              Center(child: Text('Load data error....'));
          }
          return Container();
        });
  }

  _buildListCategory(future, controller) {
    return FutureBuilder<CategoryList>(
        future: future,
        builder: (context, AsyncSnapshot<CategoryList> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: buildErrorText(snapshot)));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingGridPage(
                itemCount: 3,
                itemWidth: ScreenUtil().setSp(109),
                itemHeight: ScreenUtil().setSp(84),
              );
            case ConnectionState.done:
              return ListView.builder(
                controller: controller,
                key: PageStorageKey('categoryList'),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data.content.length,
                itemBuilder: (context, int index) {
                  var item = snapshot.data.content[index];
                  return CategoryCard(
                      category: item,
                      width: ScreenUtil().setWidth(109),
                      height: ScreenUtil().setHeight(120),
                      imageHeight: ScreenUtil().setWidth(84),
                      paddingRight: ScreenUtil().setHeight(7));
                },
              );
            default:
              Center(child: Text('Load data error....'));

              return Container();
          }
        });
  }

  _buildListItemsSmall(future, isMyCoupon, key, controller) {
    return FutureBuilder<ListItem>(
        future: future,
        builder: (context, AsyncSnapshot<ListItem> snapshot) {
          if (snapshot.hasError) {
            return isMyCoupon
                ? _buildMyCoupon()
                : Center(
                    child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: buildErrorText(snapshot),
                  ));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingGridPage(
                itemCount: 3,
                itemWidth: MediaQuery.of(context).size.width / 4,
                itemHeight: MediaQuery.of(context).size.width / 4.5,
              );
            case ConnectionState.done:
              return isMyCoupon &&
                      (snapshot.data.content == null ||
                          snapshot.data.content.length == 0)
                  ? _buildMyCoupon()
                  : SizedBox(
                      height: ScreenUtil().setSp(205),
                      child: ListView.builder(
                        controller: controller,
                        key: PageStorageKey(key),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data.content.length,
                        itemBuilder: (context, int index) {
                          var item = snapshot.data.content[index];
                          return ItemCard(
                            item: item,
                            showLocation: true,
                            // distance: item.distance != null ? item.distance.toStringAsFixed(2) + ' km' : '',
                            star: item.itemPrice != null
                                ? item.itemPrice.toString()
                                : '',
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setSp(200),
                            imageHeight: ScreenUtil().setSp(112),
                            middleHeight: ScreenUtil().setSp(50),
                            footerHeight: ScreenUtil().setSp(35),
                            paddingRight: 12,
                            paddingBottom: 0,
                            iconSize: ScreenUtil().setSp(16),
                            pointFontSize: ScreenUtil().setSp(14),
                          );
                        },
                      ),
                    );
            default:
              Center(child: Text('Load data error....'));
              return Container();
          }
        });
  }

  _buildMyCoupon() {
    return Container(
      padding: const EdgeInsets.only(right: 18),
      child: Container(
        height: ScreenUtil().setSp(144),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFE7E7E7), width: 0.5),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(52, 27, 52, 0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/coupons.png',
                width: ScreenUtil().setSp(35),
                height: ScreenUtil().setSp(24),
              ),
              SizedBox(height: ScreenUtil().setSp(22)),
              Text(
                FlutterI18n.translate(context, 'homePage.noItem'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CommonColor.textGrey,
                  fontSize: ScreenUtil().setSp(13),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getBalance() async {
    setState(() {
      isLoadingBalance = true;
    });
    try {
      final AccountInfo res = await dataService.getBalance();
      setState(() {
        balance = formatCurrency.format(res.balance != null ? res.balance : 0);
        isLoadingBalance = false;
      });
    } catch (error) {
      setState(() {
        isLoadingBalance = false;
      });
    }
  }

  //
  getHotItem(page) async {
    setState(() {
      hotItemFuture = dataService.getHotItem(page);
      _refreshController.refreshCompleted();
    });
  }

  getNewestItem(page) async {
    setState(() {
      newestItemFuture = dataService.getNewestItem(page);
    });
  }

  getInterestingItem(page) async {
    setState(() {
      interestingItemFuture = dataService.getInterestingItem(page);
    });
  }

  getHomeCategory() async {
    categoryListFuture = dataService.getAllCategory();
    setState(() {
      _saveCategoryToStorage();
    });
  }

  _saveCategoryToStorage() {
    categoryListFuture.then((data) {
      print(data.totalElements);
      storage.setItem('categories', data);
    });
  }

  getExpireSoon(page) async {
    setState(() {
      expireSoonFuture = dataService.getExpireSoon(page);
    });
  }

  getViewNearlyItem(page) async {
    setState(() {
      viewNearlyItemFuture = dataService.getViewNearlyItem(page);
    });
  }

  _openCouponDtail(context, id) {
    InternetConnectivity.checkConnectivity().then(
      (data) {
        if (InternetConnectivity.internet) {
          Navigator.of(context).push(
            PageRouteBuilder<Null>(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget child) {
                        return Opacity(
                          opacity: animation.value,
                          child: ItemDetailPage(
                            itemCode: id,
                          ),
                        );
                      });
                },
                transitionDuration: Duration(milliseconds: 100)),
          );
        } else {
          Reusable.showTotastError("No internet connection! Please try again");
        }
      },
    );
  }

  _openQRCodeScaner() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return QRScannerPage(
            callback: Reusable.showTotastError,
            screenType: "WALLET",
          );
        },
        fullscreenDialog: true));
  }
}
