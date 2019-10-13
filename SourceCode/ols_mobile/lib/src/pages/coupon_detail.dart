import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:ols_mobile/src/blocs/wallet_bloc.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/http_client.dart';
import 'package:ols_mobile/src/common/util/image_util.dart';
import 'package:ols_mobile/src/common/util/internet_connectivity.dart';
import 'package:ols_mobile/src/models/bloc_delegate.dart';
import 'package:ols_mobile/src/models/item_detail_model.dart';
import 'package:ols_mobile/src/models/item_model.dart';
import 'package:ols_mobile/src/models/store_model.dart';
import 'package:ols_mobile/src/models/user_modal.dart';
import 'package:ols_mobile/src/pages/wtite-review.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/bubble_tab_indicator.dart';
import 'package:ols_mobile/src/widgets/error.dart';
import 'package:ols_mobile/src/widgets/m_point.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:ols_mobile/src/widgets/showToast.dart';
import 'package:ols_mobile/src/widgets/tab_bar.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:url_launcher/url_launcher.dart';

import 'loading-detail.dart';
import 'login.dart';

class ItemDetailPage extends StatefulWidget {
  final itemCode;
  final heroTag;
  final previousPage;

  ItemDetailPage({this.itemCode, this.heroTag, this.previousPage});

  @override
  State<StatefulWidget> createState() {
    return _ItemDetailPageState();
  }
}

class _ItemDetailPageState extends State<ItemDetailPage> with SingleTickerProviderStateMixin implements BlocDelegate<dynamic> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<PullToRefreshNotificationState> key = new GlobalKey<PullToRefreshNotificationState>();
  final storage = new FlutterSecureStorage();
  final DataService dataService = DataService();
  var top = 0.0;
  int totalFavorite;
  bool likeStatus = false;
  Item itemDetail;
  bool showBookButton = false;
  Future<Item> _futureItemDetail;
  TextEditingController countController = TextEditingController(text: "1");
  WalletBloc walletBloc;
  ApplicationBloc applicationBloc;
  User user;
  int countItem;
  bool isShowGetButton = false;
  var listReview = [];
  var offerImage;
  BitmapDescriptor markerIcon;

  final List<Tab> tabs = <Tab>[Tab(text: "Điều kiện sử dụng"), Tab(text: "Địa điểm áp dụng")];
  TabController _tabController;
  String selectedStatus;

  @override
  void initState() {
    super.initState();
    InternetConnectivity.checkConnectivity();
    countItem = 1;
    _initData();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(26, 26)), 'assets/images/map-pin2.png').then((onValue) {
      markerIcon = onValue;
    });
    selectedStatus = "TAB1";
    _tabController = new TabController(vsync: this, length: tabs.length);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          selectedStatus = "TAB1";
        });
      } else if (_tabController.index == 1) {
        setState(() {
          selectedStatus = "TAB2";
        });
      }
    });
  }

  _initData() {
    setState(() {
      applicationBloc = BlocProvider.of<ApplicationBloc>(context);
      user = applicationBloc.currentUserValue.value;
      _futureItemDetail = dataService.getItemDetail(widget.itemCode);
    });
  }

  Future<bool> onRefresh() {
    setState(() {
      user = applicationBloc.currentUserValue.value;
      _futureItemDetail = dataService.getItemDetail(widget.itemCode);
    });
    return Future.value(true);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    walletBloc = WalletBloc(delegate: this);
    // change the navigation bar color to material color [orange-200]
    // FlutterStatusbarcolor.setNavigationBarColor(Colors.orange[200]);
    // if (useWhiteForeground(Colors.green[400])) {
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    // } else {
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // }
    return FutureBuilder<Item>(
        future: _futureItemDetail,
        builder: (context, AsyncSnapshot<Item> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingDetailPage();
            case ConnectionState.active:
              return Scaffold(
                backgroundColor: CommonColor.backgroundColor,
                body: Center(),
              );
            case ConnectionState.none:
              return Scaffold(
                backgroundColor: CommonColor.backgroundColor,
                body: Center(
                  child: Text('No Internet connection found! Please try again'),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                HttpError error = snapshot.error as HttpError;
                return Scaffold(
                  backgroundColor: CommonColor.backgroundColor,
                  body: ErrorPage('Trở lại', () {
                    Navigator.pop(context);
                  }, error.message),
                );
              }
              itemDetail = snapshot.data;
              offerImage = ImageUtil.getImageUrlFromList(itemDetail.imageDTO);

              return Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: CommonColor.backgroundColor,
                  body: PullToRefreshNotification(
                    onRefresh: onRefresh,
                    color: Colors.blue,
                    pullBackOnRefresh: true,
                    key: key,
                    child: CustomScrollView(physics: AlwaysScrollableClampingScrollPhysics(), slivers: <Widget>[
                      PullToRefreshContainer(buildPulltoRefreshAppbar),
                      // _buildHeaderBar(),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              color: Colors.white,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        child: (Image(
                                          image: AssetImage('assets/images/loyalty/demo1.png'),
                                          width: ScreenUtil().setSp(60),
                                          height: ScreenUtil().setSp(60),
                                        )),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setSp(10),
                                      ),
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                        Text(
                                          itemDetail.itemName,
                                          style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setSp(10),
                                        ),
                                        Text(
                                          itemDetail.categoryDescription ?? '',
                                          style: TextStyle(
                                            color: CommonColor.textGrey,
                                            fontSize: ScreenUtil().setSp(14),
                                          ),
                                        )
                                      ]),
                                      Spacer(),
                                      _buildLikeButton(context),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Container(
                                    width: ScreenUtil().setSp(345),
                                    decoration: BoxDecoration(color: Color(0xFfF9F9F9), borderRadius: BorderRadius.circular(8), boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 1.0,
                                        spreadRadius: 1.0,
                                        offset: Offset(
                                          1.0,
                                          // horizontal, move right 10
                                          1.0, // vertical, move down 10
                                        ),
                                      )
                                    ]),
                                    child: Container(
                                      padding: EdgeInsets.only(top: ScreenUtil().setSp(15)),
                                      width: ScreenUtil().setSp(345),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding:
                                                EdgeInsets.only(left: ScreenUtil().setSp(13), right: ScreenUtil().setSp(13), bottom: ScreenUtil().setSp(9)),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color: Color(0xffE7E7E7),
                                              style: BorderStyle.solid,
                                              width: 1,
                                            ))),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  constraints: BoxConstraints(maxWidth: ScreenUtil().setSp(325)),
                                                  child: Text(
                                                    itemDetail.description ?? '',
                                                    style:
                                                        TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: ScreenUtil().setSp(4),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'assets/images/loyalty/time_icon.png',
                                                      width: ScreenUtil().setSp(14),
                                                      height: ScreenUtil().setSp(14),
                                                    ),
                                                    SizedBox(
                                                      width: ScreenUtil().setSp(6),
                                                    ),
                                                    Text(
                                                      itemDetail.effectiveDate ?? '',
                                                      style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(14)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: ScreenUtil().setSp(54),
                                            padding: EdgeInsets.only(left: ScreenUtil().setSp(14), right: ScreenUtil().setSp(14)),
                                            child: Row(
                                              children: <Widget>[
                                                MPoint(point: itemDetail.itemPrice.toString() ?? "" , iconSize: ScreenUtil().setSp(24), fontSize: ScreenUtil().setSp(16)),
                                                SizedBox(
                                                  width: ScreenUtil().setSp(7),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (countItem > 1) {
                                                      setState(() {
                                                        countItem--;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(100),
                                                        border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid)),
                                                    width: ScreenUtil().setSp(24),
                                                    height: ScreenUtil().setSp(24),
                                                    child: Center(
                                                        child: Text(
                                                      "-",
                                                      style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Color(0xff696969)),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ScreenUtil().setSp(13),
                                                ),
                                                Text(
                                                  "$countItem",
                                                  style: TextStyle(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.bold, color: Color(0xff343434)),
                                                ),
                                                SizedBox(
                                                  width: ScreenUtil().setSp(13),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      countItem++;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(100),
                                                        border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid)),
                                                    width: ScreenUtil().setSp(24),
                                                    height: ScreenUtil().setSp(24),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        size: ScreenUtil().setSp(12),
                                                        color: Color(0xff696969),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: TabBarWidget(tabs,_tabController),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                                          child: Column(
                                            children: <Widget>[
                                              selectedStatus == "TAB1"
                                                  ? _buildDescSection(context, FlutterI18n.translate(context, 'itemDetailPage.use'), itemDetail.termAndConditions ?? '', 20.0, "")
                                                  : _buildLocation(context, itemDetail.redeemLocation != null ? itemDetail.redeemLocation : []),
                                              SizedBox(
                                                height: ScreenUtil().setSp(8),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(ScreenUtil().setSp(0)),
                                                child: Column(
                                                  children: <Widget>[
                                                    _buildDescSection(context,   FlutterI18n.translate(context, 'itemDetailPage.about')+" ", itemDetail.description ?? '', 20.0, itemDetail.itemName),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                color: Color(
                                                  0xFFF2F2F2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                ////////////////////////////
                              ],
                            ),
                          ),
                        ]),
                      )
                    ]),
                  ),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0xFFD6D6D6),
                        blurRadius: 5.0,
                      ),
                    ]),
                    child: Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), child: _buildGetButton(context, widget.itemCode)),
                  ));
            default:
              return Scaffold(
                backgroundColor: CommonColor.backgroundColor,
                body: ErrorPage('Back', () {
                  Navigator.pop(context);
                }),
              );
            // Center(child: Text('Unexected error....'));
          }
        });
  }

  Widget buildPulltoRefreshAppbar(PullToRefreshScrollNotificationInfo info) {
    var action = Container();
    var offset = info?.dragOffset ?? 0.0;
    var expandedHeight = MediaQuery.of(context).size.height / 3 + offset;
    return SliverAppBar(
        expandedHeight: expandedHeight,
        floating: false,
        pinned: true,
        snap: false,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        backgroundColor: Colors.white,
        actions: <Widget>[action],
        flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          top = constraints.biggest.height;

          final text = (itemDetail.itemName != null ? itemDetail.itemName : '');
          return FlexibleSpaceBar(
              centerTitle: true,
              title: AnimatedOpacity(
                duration: Duration(milliseconds: 0),
                // opacity: 1,
                opacity: top <= 100 ? 1 : 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setSp(50),
                    right: showBookButton ? ScreenUtil().setSp(92) : ScreenUtil().setSp(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              background: Hero(
                tag: itemDetail.itemCode.toString() + itemDetail.effectiveDate,
                child: Image(
                  image: offerImage,
                  height: ScreenUtil().setSp(250),
                  fit: BoxFit.cover,
                ),
              ));
        }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                height: ScreenUtil().setSp(35),
                width: ScreenUtil().setSp(35),
                child: Card(
                  child: Icon(
                    Icons.clear,
                    color: Color(0xff696969),
                    size: ScreenUtil().setSp(16),
                  ),
                  shape: CircleBorder(),
                  color: Color(0xFFEAEAEA),
                  elevation: 0.0,
                ),
              ),
            ),
          ],
        ));
  }

  _buildLocation(context, List<Store> listStores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: ScreenUtil().setSp(20), bottom: ScreenUtil().setSp(10)),
          width: MediaQuery.of(context).size.width,
          child: Text(
            FlutterI18n.translate(context, 'itemDetailPage.place') + '(' + (listStores != null ? listStores.length.toString() : '') + ')',
            style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 5),
            shrinkWrap: true,
            itemCount: listStores.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/images/loyalty/location_icon.png'),
                          height: ScreenUtil().setSp(24),
                        ),
                        SizedBox(
                          width: ScreenUtil().setSp(10),
                        ),
                        Text(
                          listStores[index].storeName ?? '',
                          style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setSp(8)),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/map-pin.png'),
                        height: ScreenUtil().setSp(12),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(10),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          listStores[index].address ?? '',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.normal),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _showMap(listStores[index].latitude ?? 0.0, listStores[index].longitude ?? 0.0, listStores[index].address ?? '',
                              listStores[index].storeName ?? '');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          width: MediaQuery.of(context).size.width / 4,
                          child: Text(
                            FlutterI18n.translate(context, 'itemDetailPage.map'),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff0A4DD0),
                              fontSize: ScreenUtil().setSp(14),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: ScreenUtil().setSp(8)),
                    Row(children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/phone_ic.png'),
                        height: ScreenUtil().setSp(12),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(10),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          listStores[index].phone ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.normal),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (listStores[index].phone != null) {
                            launch("tel://" + listStores[index].phone);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          width: MediaQuery.of(context).size.width / 4,
                          child: Text(
                              FlutterI18n.translate(context, 'itemDetailPage.call'),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff0A4DD0),
                              fontSize: ScreenUtil().setSp(14),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              );
            }),
      ],
    );
  }

  _buildDescSection(context, title, content, paddingTop, title2, [content2, twoColumn, titleHightlight]) {
    var contentText = Text(
      content ?? '',
      style: TextStyle(color: CommonColor.textGrey, fontSize: ScreenUtil().setSp(14), height: ScreenUtil().setSp(1.3)),
    );
    dynamic contentSection = contentText;
    if (twoColumn != null && twoColumn) {
      contentSection = Row(
        children: <Widget>[
          contentText,
          Spacer(),
          content2,
        ],
      );
    }
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setSp(paddingTop)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  title2,
                  style: TextStyle(color: Color(0xffF42E13), fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          contentSection,
        ],
      ),
    );
  }

  _buildLikeButton(context) {
    likeStatus = itemDetail.favourite != null ? itemDetail.favourite : false;
    return LikeButton(
      size: 20,
      circleColor: CircleColor(start: Color(0xFFEB5757), end: Color(0xFFEB5757)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xFFEB5757),
        dotSecondaryColor: Color(0xFFEB5757),
      ),
      onTap: (bool isLiked) {
        if (BlocProvider.of<ApplicationBloc>(context).getAuthStatus.value) {
          return _likeCoupon(itemDetail.itemCode);
        }
      },
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Color(0xFFEB5757) : Colors.grey,
          size: 20,
        );
      },
      isLiked: likeStatus,
      likeCount: totalFavorite != null ? totalFavorite : itemDetail.favouriteCount ?? 0,
      countBuilder: (int count, bool isLiked, String text) {
        var color = isLiked ? Color(0xFFEB5757) : Colors.grey;
        Widget result;
        if (count == 0) {
          text = 'Like';
        }
        result = Text(
          text,
          style: TextStyle(color: color, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.w400),
        );
        return result;
      },
      likeCountPadding: EdgeInsets.only(left: 5.0),
    );
  }

  _buildGetButton(context, offerId) {
    return RaisedGradientButton(
        child: Text(
          FlutterI18n.translate(context, 'itemDetailPage.add'),
          style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
        ),
        gradient: CommonColor.commonButtonColor,
        height: ScreenUtil().setSp(40),
        onPressed: () {
          _addOrderItem(context);
//          Navigator.pop(context);
          // final offerIds = [
          //   {'add': true, 'count': 1, 'offerId': offerId}
          // ];

          // walletBloc.addOffersToWallet(offerIds);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
        });
  }

  _addOrderItem(context) async {
    var token = await storage.read(key: Config.TOKEN_KEY);
    if (token == null) {
      var listOrderLocal = await storage.read(key: Config.LIST_ORDER);
      Item itemCart = Item(
        itemCode: itemDetail.itemCode,
        itemName: itemDetail.itemName,
        quantity: countItem,
        itemPrice: itemDetail.itemPrice,
        description: itemDetail.description,
        imageDTO: itemDetail.imageDTO,
        endDate: itemDetail.endDate,
        startDate: itemDetail.startDate,
        expired: itemDetail.expired,
      );
      if (listOrderLocal != null) {
        var orderList = OrderList.fromJson(jsonDecode(listOrderLocal));
        if (orderList.items.where((k) => k.itemCode == itemDetail.itemCode).length > 0) {
          orderList.items.forEach((obj) {
            if (obj.itemCode == itemDetail.itemCode) {
              obj.quantity = obj.quantity + countItem;
              return;
            }
          });
        } else {
          orderList.items.add(itemCart);
        }
        storage.write(key: Config.LIST_ORDER, value: jsonEncode(orderList));
      } else {
        List<Item> listItem = [itemCart];
        OrderList newListCart = OrderList(items: listItem);
        print('newListCart: $newListCart');
        storage.write(key: Config.LIST_ORDER, value: jsonEncode(newListCart));
      }
      applicationBloc.getLocalOrderCount();
    } else {
      dataService.addOrUpdateCart(itemDetail.itemCode, {"quantity": countItem}).then((data) {
        if (data.items != null && data.items.length > 0) {
          int count = 0;
          data.items.forEach((obj) {
            count = count + obj.quantity;
          });
          applicationBloc.changeOrderCount(count);
        } else {
          applicationBloc.changeOrderCount(0);
        }
      }).catchError((err) {
        print("add err: ${err.toString()}");
      });
    }
    _showSuccessDialog();
//    Toast(title: '2333', context: context).showToast();
  }

  void openReviewDialog(context, companyId) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    if (applicationBloc.currentUserValue.value != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (BuildContext context) {
                return ReviewDialog(
                  companyId: companyId,
                );
              },
              fullscreenDialog: true))
          .then((Review) {
        if (Review != null) {
          setState(() {
            listReview.insert(0, Review);
          });
        }
      });
    } else {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new LogInPage();
          },
          fullscreenDialog: true));
    }
  }

  @override
  State<StatefulWidget> createState() {
    return null;
  }

  @override
  error(HttpError error) {
    Reusable.handleHttpError(context, error, applicationBloc);
    return null;
  }

  @override
  success(t) {
    BlocProvider.of<ApplicationBloc>(context).changeOrderCount(t['totalCount']);
    _showSuccessDialog();
    // _showSnackBar();
    return null;
  }

  _showSuccessDialog() {
    containerForSheet<String>(
        context: context,
        child: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: CupertinoActionSheet(actions: <Widget>[
            CupertinoActionSheetAction(
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Image.asset(
                  'assets/images/check_icon.png',
                  height: ScreenUtil().setSp(24),
                ),
                SizedBox(
                  width: ScreenUtil().setSp(10),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(context, 'itemDetailPage.success'),
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: CommonColor.textBlack,
                          height: 1.5,
                        ),
                      ),
                      Text(
                         FlutterI18n.translate(context, 'itemDetailPage.redeem'),
                        style: TextStyle(height: 1.5, color: CommonColor.textRed, fontSize: ScreenUtil().setSp(14)),
                      )
                    ],
                  ),
                )
              ]),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop("Wallet");
              },
            )
          ]),
        ));
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
          return child;
        }).then<void>((T value) {
      if ('Wallet' == value) {
        bottomNavBarBloc.pickItem(PageIndex.WALLET);
        Navigator.pop(context);
        if (widget.previousPage != null && Page.WALLET == widget.previousPage) {
          applicationBloc.changeNotifyEventValue(AppEvent.RELOAD_WALLET);
        }
      }
    });
  }

  Future<bool> _likeCoupon(id) async {
    final Completer<bool> completer = new Completer<bool>();
    try {
      final Item item = await dataService.likeItem(id);
      if (item != null) {
        Timer(const Duration(milliseconds: 200), () {
          // setState(() {
          //   likeStatus = item.wishList;
          //   itemDetail.wishList = likeStatus;
          //   if (likeStatus) {
          //     totalFavorite = 111;
          //   } else {
          //     totalFavorite = 0;
          //   }
          // });
          completer.complete(item.favourite);
        });
      }
    } catch (error) {
      Reusable.showTotastError(error.message);
      completer.complete(likeStatus);
    }
    return completer.future;
  }

  Set<Marker> markers = Set();

  _showMap(lat, long, address, storeName) {
    Marker resultMarker = Marker(
      markerId: MarkerId(storeName),
      icon: markerIcon,
      infoWindow: InfoWindow(title: storeName, snippet: address),
      position: LatLng(lat, long),
    );
    markers.add(resultMarker);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Color(0xFF737373),
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      address ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(15),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2 - 100,
                      child: GoogleMap(
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat ?? 0, long ?? 0),
                          zoom: 15,
                        ),
                        markers: markers,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  String dateFormat(text) {
    String s;
    try {
//      DateTime d = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZZZZ", "en_US").parse(text);
      DateTime d = DateFormat("MM/dd/yyyy HH:mm:ss", "en_US").parse(text);
      s = DateFormat("HH:mm  dd.MM.yyyy").format(d).toString();
    } catch (error) {
      var now = DateTime.now();
      s = DateFormat("HH:mm  dd.MM.yyyy").format(now).toString();
    }
    return s;
  }
}
