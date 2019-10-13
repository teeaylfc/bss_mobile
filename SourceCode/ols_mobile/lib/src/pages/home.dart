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
    _initScrollController();
    _geolocator = Geolocator();
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    // sroll to top page
    applicationBloc.notifyEvent.listen((onData) {
      if (AppEvent.SCROLL_HOME == onData) {
        if (_scrollController.hasClients &&
            _scrollController.position.pixels > 0.0) {
          _scrollController.animateTo(0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500));
        }
      }
    });

    applicationBloc.currentUserValue.listen((user) {
      if (user != null) {
        fullName = user.fullName;
        imageUrl = user.getImageUrl();
        getViewNearlyItem(0);
        // balance = user.balance;
        getBalance();
      } else {
        fullName = null;
        imageUrl = null;
        balance = '0.0';
      }
    });

    // ///
    // applicationBloc.orderCount.listen((count) {
    //   orderCount = count;
    // });

    _initData();
    checkLocaltionPermission();
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _initData,
          header: CustomHeader(
            refreshStyle: RefreshStyle.Behind,
            builder: (c, m) {
              return Container(
                padding: EdgeInsets.only(
                  top: 40,
                ),
                decoration: BoxDecoration(
                    border: Border.all(style: BorderStyle.none),
                    color: CommonColor.backgroundColor),
                alignment: Alignment.bottomCenter,
                child: SpinKitFadingCircle(
                  color: Colors.grey,
                  size: ScreenUtil().setSp(25),
                ),
              );
            },
          ),
          child: ListView(
              key: PageStorageKey('parentList'),
              controller: _scrollController,
              children: <Widget>[
                _buildHeader(),
                _buildBanner(),
                /////////////
                InkWell(
                    child: Container(
                  padding: EdgeInsets.fromLTRB(18, 27, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(context, 'homePage.hot'),
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: FontWeight.bold,
                          color: CommonColor.textBlack,
                        ),
                      ),
                    ],
                  ),
                )),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(214),
                    child: _buildListHorizotal3(hotItemFuture, 343.0, 214.0,
                        FontWeight.bold, 'hotItemList', _listScroll[1]),
                  ),
                ),

                ////////
                SectionTitle(
                    FlutterI18n.translate(context, 'homePage.newest'),
                    GestureDetector(
                        onTap: () {
                          bottomNavBarBloc.pickItem(PageIndex.COUPON_LIST,
                              {'previousPage': 'HOME', 'type': 'NEWEST'});
                        },
                        child: Text(
                          FlutterI18n.translate(context, 'homePage.seeAll'),
                          style: Styles.seeAllTextStyle,
                        ))),
                Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                    left: _listPadding[2],
                  ),
                  child: _buildListItemsSmall(newestItemFuture, false,
                      'newestItemList', _listScroll[2]),
                ),
                ////////
                SectionTitle(
                    FlutterI18n.translate(context, 'homePage.category'),
                    GestureDetector(
                        onTap: () => {
                              bottomNavBarBloc.pickItem(PageIndex.CATEGORY_LIST)
                            },
                        child: Text(
                          FlutterI18n.translate(context, 'homePage.seeAll'),
                          style: Styles.seeAllTextStyle,
                        ))),
                Padding(
                    padding: EdgeInsets.fromLTRB(_listPadding[3], 12, 0, 0),
                    child: SizedBox(
                        height: ScreenUtil().setSp(120),
                        child: _buildListCategory(
                            categoryListFuture, _listScroll[3]))
                    ///////
                    ),
                ////////
                SectionTitle(
                    FlutterI18n.translate(context, 'homePage.interesting'),
                    GestureDetector(
                        onTap: () {
                          bottomNavBarBloc.pickItem(PageIndex.COUPON_LIST,
                              {'previousPage': 'HOME', 'type': 'INTERESTING'});
                        },
                        child: Text(
                          FlutterI18n.translate(context, 'homePage.seeAll'),
                          style: Styles.seeAllTextStyle,
                        ))),

                Padding(
                  padding: EdgeInsets.fromLTRB(_listPadding[4], 12, 0, 0),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(156),
                    child: _buildListHorizotal(
                        interestingItemFuture,
                        234.0,
                        156.0,
                        FontWeight.w500,
                        'interestingItemList',
                        _listScroll[4]),
                  ),
                ),
                ////////
                GestureDetector(
                  onTap: () {},
                  child: SectionTitle(
                    FlutterI18n.translate(context, 'homePage.soon'),
                    GestureDetector(
                      onTap: () {
                        bottomNavBarBloc.pickItem(PageIndex.COUPON_LIST,
                            {'previousPage': 'HOME', 'type': 'EXPIRESOON'});
                      },
                      child: Text(
                        FlutterI18n.translate(context, 'homePage.seeAll'),
                        style: Styles.seeAllTextStyle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, left: _listPadding[5]),
                  child: _buildListItemsSmall(expireSoonFuture, false,
                      'expireSoonList', _listScroll[5]),
                ),
                ////////
                applicationBloc.getAuthStatus.value
                    ? FutureBuilder(
                        future: viewNearlyItemFuture,
                        builder: (context, AsyncSnapshot<ListItem> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            case ConnectionState.done:
                              return Wrap(
                                children: <Widget>[
                                  SectionTitle(
                                    FlutterI18n.translate(
                                        context, 'homePage.near'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 12, left: _listPadding[6]),
                                    child: _buildListItemsSmall(
                                        viewNearlyItemFuture,
                                        true,
                                        'recentlyViewList',
                                        _listScroll[6]),
                                  ),
                                ],
                              );
                            default:
                              Center(child: Text('Load data error....'));
                          }
                          return Container();
                        })
                    : Container(),

                _buildFavoritesBrand(listStore),
                SizedBox(
                  height: 10,
                )
              ]),
        ),
      ),
    );
  }

  _buildBanner() {
    return Padding(
      padding: EdgeInsets.only(top: 27, left: _listPadding[0]),
      child: SizedBox(
        height: ScreenUtil().setHeight(157),
        child: ListView.builder(
            controller: _listScroll[0],
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Image.asset(
                    'assets/images/loyalty/demo.png',
                    width: ScreenUtil().setWidth(343),
                    height: ScreenUtil().setHeight(157),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildBalanceInfo() {
    return Container(
      width: ScreenUtil().setWidth(344),
      height: ScreenUtil().setHeight(110),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 10.0,
                color: Colors.black12,
                offset: Offset(0.0, 10.0))
          ],
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(37),
            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    FlutterI18n.translate(context, 'homePage.balance'),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                isLoadingBalance
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: SizedBox(
                          width: ScreenUtil().setSp(12),
                          height: ScreenUtil().setSp(12),
                          child: SpinKitFadingCircle(
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          MPoint(
                            iconSize: ScreenUtil().setSp(18),
                            point: '$balance',
                            textColor: CommonColor.textBlack,
                            fontSize: ScreenUtil().setSp(14),
                          ),
                          SizedBox(
                            width: ScreenUtil().setSp(5),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 7,
                            color: Color(0xFF9B9B9B),
                          ),
                        ],
                      ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8)),
            child: Container(
                height: ScreenUtil().setHeight(0.8), color: Color(0xFFDADADA)),
          ),
          Container(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(10),
              bottom: ScreenUtil().setHeight(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildIconButton(
                  Image.asset(
                    'assets/images/loyalty/pay_ic.png',
                    width: ScreenUtil().setWidth(28),
                    height: ScreenUtil().setHeight(35),
                  ),
                  FlutterI18n.translate(context, 'homePage.scan'),
                  _openQRCodeScaner,
                ),
                _buildIconButton(
                  Image.asset(
                    'assets/images/loyalty/card_link_ic.png',
                    width: ScreenUtil().setWidth(37),
                    height: ScreenUtil().setHeight(27),
                  ),
                  FlutterI18n.translate(context, 'homePage.linkCard'),
                  null,
                ),
                _buildIconButton(
                    Image.asset(
                      'assets/images/reward.png',
                      width: ScreenUtil().setWidth(36),
                      height: ScreenUtil().setHeight(24),
                    ),
                    FlutterI18n.translate(context, 'homePage.gift'),
                    null)
              ],
            ),
          ),
        ],
      ),
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
              _buildBalanceInfo()
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
