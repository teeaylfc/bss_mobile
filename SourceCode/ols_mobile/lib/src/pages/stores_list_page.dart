import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/util/internet_connectivity.dart';
import 'package:ols_mobile/src/models/address_model.dart';
import 'package:ols_mobile/src/models/store_model.dart';
import 'package:ols_mobile/src/pages/address_add.dart';
import 'package:ols_mobile/src/pages/grid_view_store.dart';
import 'package:ols_mobile/src/pages/page_state.dart';
import 'package:ols_mobile/src/pages/sign_in.dart';
import 'package:ols_mobile/src/pages/stadium_manager.dart';
import 'package:ols_mobile/src/pages/store_info.dart';
import 'package:ols_mobile/src/service/auth_service.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/address_card.dart';
import 'package:ols_mobile/src/widgets/bubble_tab_indicator.dart';
import 'package:ols_mobile/src/widgets/no_internet.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:ols_mobile/src/widgets/refresh_footer.dart';
import 'package:ols_mobile/src/widgets/refresh_header.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:ols_mobile/src/widgets/store_card.dart';
import 'package:ols_mobile/src/widgets/tab_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:flutter/services.dart';

class StoreListPage extends StatefulWidget {
  const StoreListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StoreListPageState();
  }
}

class _StoreListPageState extends PageState<StoreListPage>
    with
        AutomaticKeepAliveClientMixin<StoreListPage>,
        SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  DataService dataService = DataService();
  RefreshController _refreshController = RefreshController();

  bool loading;

  String errorMessage;

  final List<Tab> tabs = <Tab>[
    Tab(text: "Tất cả cửa hàng"),
    Tab(text: "Cửa hàng yêu thích")
  ];
  double opacityHeader = 0;
  TabController _tabController;

  List<Store> listStore = List<Store>();
  List<Store> listFavoriteStore = List<Store>();
  List<Store> listAllStore = List<Store>();
  AuthService authService = AuthService();
  ApplicationBloc applicationBloc;
  AuthenticationState authStatus = AuthenticationState.notDetermined;
  bool favorites = false;
  ScrollController _controller;
  List<Address> listAddress = List<Address>();

  @override
  void initState() {
    // TODO: implement initState
    getAllAddress();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _tabController.dispose();

    super.dispose();
  }

  getStoreList() {
    dataService.getStore(page, favorites).then((data) {
      setState(() {
        if (page == 0) {
          listStore = [];
        }
        listStore.addAll(data.content);
        last = data.last;
      });
    }).catchError((error) {
      Reusable.handleHttpError(context, error, applicationBloc);
    });
  }

  getAllAddress(){
    dataService.getAllAdress().then((data){
      listAddress = [];
      setState(() {
        listAddress.addAll(data.address);
      });

    }).catchError((error){
      Reusable.handleHttpError(context, error, applicationBloc);
    });
  }

  getAllStore() {
    dataService.getAllStore(page).then((data) {
      print("data: ${data.content[0].toJson()}");
      setState(() {
        if (page == 0) {
          listAllStore = [];
        }
        listAllStore.addAll(data.content);
      });
    }).catchError((err) {
      Reusable.handleHttpError(context, err, applicationBloc);
    });
  }

  getFavoriteStore() {
    dataService.getFavoriteStore(page).then((data) {
      setState(() {
        if (page == 0) {
          listFavoriteStore = [];
        }
        listFavoriteStore.addAll(data.content);
      });
    }).catchError((err) {
//      Reusable.handleHttpError(context, err, applicationBloc);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        gradient: CommonColor.leftRightLinearGradient
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(child: Text("Quản lý địa điểm")),
        ),
       body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffF7F7F7),
          child: Column(
            children: <Widget>[
                    Expanded(
                   child: ListView.builder(
                  itemCount: listAddress.length,
                  itemBuilder: (context,index){
                      return _addressCard(listAddress[index]);
                  },
                ),
                    )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(   
        color: Colors.white,   
      padding: const EdgeInsets.all(10.0),
      child: RaisedGradientButton(
          child: Text(
            'Thêm địa điểm',
            style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
          ),
          gradient: CommonColor.leftRightLinearGradient,
      height: ScreenUtil().setSp(40),
          onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AddressAddPage()
                  ));
          }),
        ),
      ),
    );
  }

  Widget _addressCard(Address address){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StadiumManager()));
      },
      onLongPress: (){},
      child: Container(
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
                  Image.asset("assets/images/loyalty/stadium_logo.jpg",width: ScreenUtil().setSp(70),height: ScreenUtil().setSp(70),),
                  SizedBox(
                    width: ScreenUtil().setSp(15),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Sân bóng Đông Đô',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          fontWeight: FontWeight.bold,
                          color: CommonColor.textBlack,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setSp(6),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: ScreenUtil().setWidth(230),
                          minHeight: ScreenUtil().setHeight(20),
                        ),
                        child: Text(
                          address.description ?? '',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.bold,
                            color: Color(0xff696969),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setSp(10),
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset("assets/images/loyalty/location_icon.png",width: 20,height: 25,),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                         constraints: BoxConstraints(
                          maxWidth: ScreenUtil().setWidth(200),
                          minHeight: ScreenUtil().setHeight(18),
                        ),
                            child: Text(
                              address.specificAddress+', ' +  address.town.name + ', ' + address.district.name + ', ' + address.city.name,
                              style: TextStyle(
                                  color: Color(0xffFD4435),
                                  fontSize: ScreenUtil().setSp(12),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                         Container(child: Image.asset("assets/images/loyalty/edit_icon.png",width: ScreenUtil().setSp(25),height: ScreenUtil().setSp(25),)),
                         SizedBox(
                           width: ScreenUtil().setSp(20),
                         ),
                          Container(child: Image.asset("assets/images/loyalty/delete_icon.png",width: ScreenUtil().setSp(25),height: ScreenUtil().setSp(25),)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _gridViewStore(type) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = (size.width - ScreenUtil().setSp(66)) / 4;
    final double itemHeight = itemWidth + ScreenUtil().setSp(25);
    final double itemImage = ScreenUtil().setSp(75.15);
    // TODO: implement build
    List<Store> listStore =
        type == TypeStore.ALL_STORE ? listAllStore : listFavoriteStore;
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: ScreenUtil().setSp(15),
          right: ScreenUtil().setSp(5),
        ),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
//          shrinkWrap: true,
//            physics: const NeverScrollableScrollPhysics()
          childAspectRatio: (itemWidth / itemHeight),
          primary: false,
          padding: EdgeInsets.only(top: ScreenUtil().setSp(12)),
          crossAxisCount: 4,
          children: listStore.map((item) {
            return GestureDetector(
              onTap: () => _storeInfo(item.storeId),
              child: Container(
                margin: EdgeInsets.only(right: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      child: Image.network(
                        item.logoUrl,
                        width: itemImage,
                        height: itemImage,
                        fit: BoxFit.contain,
                      ),
                      borderRadius:
                          new BorderRadius.circular(ScreenUtil().setSp(12)),
                    ),
                    Container(
                      child: Text(
                        item.storeName,
                        maxLines: 2,
                        style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                      ),
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(8)),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  _storeInfo(itemID) {
    var route = new MaterialPageRoute(
        builder: (context) => StoreInfoPage(
              storeId: itemID,
            ));
    Navigator.push(context, route);
  }

//  _buildListStore() {
//    return SliverPadding(
//      padding: EdgeInsets.only(
//          left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15)),
//      sliver: SliverList(
//        delegate: SliverChildBuilderDelegate(
//          (context, index) {
//            var store = listStore[index];
//            return Container(
//              padding: EdgeInsets.only(top: 19),
//              child: StoreCard(
//                store: store,
//              ),
//            );
//          },
//          childCount: listStore.length,
//        ),
//      ),
//    );
//  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future initData() {
    // TODO: implement initData
    return null;
  }

  @override
  Future loadMoreData() async {
    if (!last) {
      page = page + 1;
      getStoreList();
    } else {
      print('last page..........');
    }
  }

  @override
  Future refreshData() async {
    page = 0;
    getStoreList();
  }
}
