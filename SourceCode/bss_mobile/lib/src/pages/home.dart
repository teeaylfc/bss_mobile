import 'package:bss_mobile/src/pages/shift_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/http_client.dart';
import 'package:bss_mobile/src/common/util/internet_connectivity.dart';
import 'package:bss_mobile/src/models/account_info_model.dart';
import 'package:bss_mobile/src/models/category_model.dart';
import 'package:bss_mobile/src/models/list_item_model.dart';
import 'package:bss_mobile/src/models/store_model.dart';
import 'package:bss_mobile/src/models/user_modal.dart';
import 'package:bss_mobile/src/pages/address_add.dart';
import 'package:bss_mobile/src/pages/bankCard_link.dart';
import 'package:bss_mobile/src/pages/coupon_detail.dart';
import 'package:bss_mobile/src/pages/loading-grid.dart';
import 'package:bss_mobile/src/pages/main.dart';
import 'package:bss_mobile/src/pages/qr_scanner.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/service/stellar_data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/style/styles.dart';
import 'package:bss_mobile/src/widgets/category_card.dart';
import 'package:bss_mobile/src/widgets/coupon_card.dart';
import 'package:bss_mobile/src/widgets/item_card_home.dart';
import 'package:bss_mobile/src/widgets/m_point.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:bss_mobile/src/widgets/section_title.dart';
import 'package:bss_mobile/src/widgets/store_item_home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'loading-card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
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

  int availableShift = 0;
  int bookedShift = 0;
  int confirmShift = 0;
  double profit = 0.0;
  String date;

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
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    applicationBloc.currentUserValue.listen((user) {
      if (user != null) {
        fullName = user.fullName;
        imageUrl = user.getImageUrl();
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
    // checkLocaltionPermission();
  }



  // getStoreList() {
  //   dataService.getStore("", false).then((data) {
  //     setState(() {
  //       listStore = [];
  //       listStore.addAll(data.content);
  //     });
  //   }).catchError((error) {
  //     Reusable.handleHttpError(context, error, applicationBloc);
  //   });
  // }

  // Future<Position> getCurrentLocation() async {
  //   try {
  //     setState(() {
  //       isGettingLocation = true;
  //     });
  //     return await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   } catch (error) {
  //     isGettingLocation = false;
  //   }
  // }

  // void checkLocaltionPermission() {
  //   _geolocator.checkGeolocationPermissionStatus().then((status) {
  //     print('status: $status');
  //   });
  //   _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways).then((status) {
  //     print('always status: $status');
  //   });
  //   _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse)
  //     ..then((status) {
  //       print('whenInUse status: $status');
  //     });
  // }
void _onRefresh() async{
   date = DateTime.now().toString().substring(0, 10);
    // monitor network fetch
     await _initData();
     await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
  Future<Null> _initData() async {
     dataService.getAvailableShift(date).then((data){
       setState(() {
         availableShift = data;
       });
     });
     dataService.getStatusShift(1,date).then((data){
       setState(() {
         confirmShift = data;
       });
     });
      dataService.getStatusShift(2,date).then((data1){
       dataService.getStatusShift(3,date).then((data2){
       setState(() {
         bookedShift = data1 + data2;
       });
     });
     });
      dataService.getProfitDay(date).then((data){
       setState(() {
         profit = data;
       });
     });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xffF7F7F7),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView(key: PageStorageKey('parentList'), controller: _scrollController, children: <Widget>[
            _buildHeader(),
            SizedBox(
              height: ScreenUtil().setSp(40),
            )     ,
            Padding(
              padding:  EdgeInsets.only(left: ScreenUtil().setSp(15),right: ScreenUtil().setSp(15)),
              
              child: Container(
                 decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 16.0,
              color: Colors.black12,
              offset: Offset(0.0, 10.0),
            ),
          ],
          borderRadius: BorderRadius.circular(16)),
                constraints: BoxConstraints(
                  minHeight: ScreenUtil().setSp(150),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    _buildInfo("Ca đã đặt",bookedShift,Colors.red),
                    Container(
                      height: 1,
                      padding: EdgeInsets.only(left: 15,right: 15),
                      color: Color(0xffE7E7E7),
                    ),
                    _buildInfo("Ca trống",availableShift,Colors.green),
                    Container(
                      height: 1,
                      padding: EdgeInsets.only(left: 15,right: 15),
                      color: Color(0xffE7E7E7),
                    ),
                     _buildInfo("Ca chờ xác nhận",confirmShift,Colors.green),
                    Container(
                      height: 1,
                      padding: EdgeInsets.only(left: 15,right: 15),
                      color: Color(0xffE7E7E7),
                    ),
                    _buildInfo("Doanh thu",profit.toString() + " VNĐ",Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setSp(50),
            ),
            GestureDetector(
              onTap: (){
                  dataService.getDetailContract(13).then((data){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftDetailPage(data, '',type: "VIEW",)));
      });
              },
              child: Container(
                child: Image.asset("assets/images/loyalty/banner_add.png",fit: BoxFit.cover,)),
            )
          ]),
        ),
      ),
    );
  }

  // _buildBanner() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: ScreenUtil().setSp(20), left: _listPadding[0]),
  //     child: SizedBox(
  //       height: ScreenUtil().setHeight(157),
  //       child: ListView.builder(
  //           controller: _listScroll[0],
  //           shrinkWrap: true,
  //           scrollDirection: Axis.horizontal,
  //           physics: ClampingScrollPhysics(),
  //           itemCount: 2,
  //           itemBuilder: (context, index) {

  //           }),
  //     ),
  //   );
  // }

   _buildInfo(title, value,color) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().setSp(30),
          right: ScreenUtil().setSp(30),
          top: ScreenUtil().setSp(10),
          bottom: ScreenUtil().setSp(10)),
          
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(16), color: CommonColor.textBlack),
          ),
          Text(
            value.toString(),
            style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold,
                color: color),
          ),
        ],
      ),
    );
  }
  Widget _buildBalanceInfo() {
    return Container(
      width: ScreenUtil().setWidth(344),
      height: ScreenUtil().setHeight(135),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 16.0,
              color: Colors.black12,
              offset: Offset(0.0, 10.0),
            ),
          ],
          borderRadius: BorderRadius.circular(16)),
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
                    style: TextStyle(fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),
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
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => AddressAddPage(),
                              //   ),
                              // );
                            },
                            child: MPoint(
                              iconSize: ScreenUtil().setSp(18),
                              point: '$balance',
                              textColor: CommonColor.textBlack,
                              fontSize: ScreenUtil().setSp(14),
                            ),
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
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(8),
            ),
            child: Container(
              height: ScreenUtil().setHeight(0.8),
              color: Color(0xFFDADADA),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(21),
              bottom: ScreenUtil().setHeight(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildIconButton(
                  Image.asset(
                    'assets/images/loyalty/member_code_icon.png',
                    width: ScreenUtil().setSp(52),
                    height: ScreenUtil().setSp(36),
                  ),
                  FlutterI18n.translate(context, 'homePage.scan'),
                  _openQRCodeScaner,
                ),
                _buildIconButton(
                  Image.asset(
                    'assets/images/loyalty/card_link_ic.png',
                    width: ScreenUtil().setSp(51),
                    height: ScreenUtil().setSp(39),
                  ),
                  FlutterI18n.translate(context, 'homePage.linkCard'),
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BankCardLink()));
                  },
                ),
                _buildIconButton(
                    Image.asset(
                      'assets/images/reward.png',
                      width: ScreenUtil().setSp(51),
                      height: ScreenUtil().setSp(33),
                    ),
                    "Thông tin cá nhân", () {
                    pickItemBloc.profilePage();
                })
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
          height: fullName != null ? ScreenUtil().setHeight(140) : ScreenUtil().setHeight(140),
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
                                FlutterI18n.translate(context, 'title') + ' ${fullName}!',
                                style: TextStyle(fontSize: ScreenUtil().setSp(20), color: Colors.white, fontWeight: FontWeight.bold),
                              )
                            : Container(
                                height: ScreenUtil().setHeight(10),
                              ),
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
            image,
            SizedBox(
              height: ScreenUtil().setSp(11),
            ),
            Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500, height: 0.4),
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

  _buildListHorizotal(future, width, height, subTextFontWeight, key, scrollController) {
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
                physics: ClampingScrollPhysics(),
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

  _buildListCategory(future, controller) {
    return FutureBuilder<CategoryList>(
        future: future,
        builder: (context, AsyncSnapshot<CategoryList> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Padding(padding: const EdgeInsets.all(18.0), child: buildErrorText(snapshot)));
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
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setHeight(93),
                    imageHeight: ScreenUtil().setWidth(70),
                    paddingRight: 0,
                  );
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
              return isMyCoupon && (snapshot.data.content == null || snapshot.data.content.length == 0)
                  ? _buildMyCoupon()
                  : SizedBox(
                      height: ScreenUtil().setSp(200),
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
                            star: item.itemPrice != null ? item.itemPrice.toString() : '',
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setSp(200),
                            imageHeight: ScreenUtil().setSp(105),
                            middleHeight: ScreenUtil().setSp(60),
                            footerHeight: ScreenUtil().setSp(30),
                            paddingRight: 12,
                            paddingBottom: 4,
                            iconSize: ScreenUtil().setSp(16),
                            pointFontSize: ScreenUtil().setSp(12),
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
