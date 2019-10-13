import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/util/internet_connectivity.dart';
import 'package:ols_mobile/src/models/category_model.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/coupon_card.dart';
import 'package:ols_mobile/src/widgets/error.dart';
import 'package:ols_mobile/src/widgets/no_internet.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:ols_mobile/src/widgets/search.dart';
import 'package:ols_mobile/src/widgets/section_title.dart';
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
  ScrollController _scrollController = ScrollController();

  CategoryList _categoryList = CategoryList([], true);

  bool loading;

  String errorMessage;
  int countListView = 10;
  List<ScrollController> _listScroll;
  List<double> _listPadding;
  List<Function> _listFunction ;


  @override
  void initState() {
    super.initState();
    InternetConnectivity.checkConnectivity();

    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    // sroll to top page
    applicationBloc.notifyEvent.listen((onData) {
      if (AppEvent.SCROLL_BROWSER == onData) {
        if (_scrollController.hasClients && _scrollController.position.pixels > 0.0) {
          _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
        }
      }
    });

    _initData(false);
    _initScrollListening();

  }

  _callbackInitData() {
    InternetConnectivity.checkConnectivity().then((data) {
      if (InternetConnectivity.internet) {
        _initData(false);
      }
    });
  }

  _initScrollListening(){
    _listScroll = List<ScrollController>(countListView);
    _listPadding = List<double>(countListView);
    _listFunction = List<Function>(countListView);
    for(int i = 0; i < _listScroll.length ; i++){
      _listScroll[i] = ScrollController();
      _listPadding[i] = 16;
      _listFunction[i] = (){
        if(_listScroll[i].hasClients){
          if (_listScroll[i].offset >= _listScroll[i].position.minScrollExtent &&
              !_listScroll[i].position.outOfRange) {
            setState(() {
              _listPadding[i] = 0;
            });
          }
          if (_listScroll[i].offset <= _listScroll[i].position.minScrollExtent &&
              !_listScroll[i].position.outOfRange) {
            setState(() {
              _listPadding[i] = 16;
            });
          }
        }
      };
    }
    for(int i= 0 ; i < _listScroll.length ; i ++){
      _listScroll[i].addListener(_listFunction[i]);
    }
  }

  _initData(refresh) {
    setState(() {
      loading = true;
    });
    if (PageStorage.of(context).readState(context, identifier: "_categoryList") == null || refresh) {
      dataService.getBrowserCategory(1).then((data) {
        setState(() {
          loading = false;
          errorMessage = null;
          _categoryList = CategoryList(data, true);
        });
        _refreshController.refreshCompleted();
        PageStorage.of(context).writeState(context, _categoryList, identifier: "_categoryList");
      }).catchError((error) {
        setState(() {
          loading = false;
          errorMessage = error.message;
        });
        _refreshController.refreshCompleted();
        // Reusable.handleHttpError(context, error, null);
      });
    } else {
      _categoryList = PageStorage.of(context).readState(context, identifier: "_categoryList");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
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
          _initData(true);
        },
        header: CustomHeader(
            refreshStyle: RefreshStyle.Behind,
            builder: (c, m) {
              return Container(
                alignment: Alignment.bottomCenter,
                child: SpinKitFadingCircle(
                  color: Colors.grey,
                  size: ScreenUtil().setSp(20),
                ),
              );
            }),
        child: InternetConnectivity.internet
            ? ListView(
                controller: _scrollController,
                children: <Widget>[
                  Container(
                    child: _categoryList != null && _categoryList.content != null && _categoryList.content.length > 0
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _categoryList.content.length,
                            itemBuilder: (BuildContext context, int index) {
                              var item = _categoryList.content[index];
                              if (item.itemDTOS != null && item.itemDTOS.length > 0) {
                                return Column(
                                  children: <Widget>[
                                    SectionTitle(
                                      item.categoryDescription,
                                      GestureDetector(
                                        onTap: () {
                                          bottomNavBarBloc.pickItem(PageIndex.COUPON_LIST, {'category': item, 'previousPage': 'BROWSER'});
                                        },
                                        child: Text(
                                          FlutterI18n.translate(context, "browser.seeAll"),
                                          style: TextStyle(color: CommonColor.textBlue),
                                        ),
                                      ),
                                      EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), 30, ScreenUtil().setWidth(16), 8),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(left: _listPadding[index]),
                                      child: SizedBox(
                                        height: ScreenUtil().setHeight(210),
                                        width: MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Expanded(
                                              child: ListView.builder(
                                                  controller:_categoryList.content[index].itemDTOS.length >2 ? _listScroll[index] : null,
                                                  key: PageStorageKey(item.categoryDescription),
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount: _categoryList.content[index].itemDTOS.length,
                                                  itemBuilder: (BuildContext context, int index2) {
                                                    var item = _categoryList.content[index].itemDTOS[index2];
                                                    return ItemCard(
                                                      item: item,
                                                      showLocation: true,
                                                      width: ScreenUtil().setWidth(168),
                                                      height: ScreenUtil().setHeight(206),
                                                      imageHeight: ScreenUtil().setHeight(115),
                                                      middleHeight: ScreenUtil().setHeight(52),
                                                      footerHeight: ScreenUtil().setHeight(35),
                                                      paddingRight: 0,
                                                      paddingBottom: 0,
                                                      star: item.itemPrice != null ? item.itemPrice.toString() : '',
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        : loading
                            ? Container(
                                alignment: Alignment(0.0, 0.0),
                                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 18),
                                child: LoadingGridPage(
                                  itemCount: 8,
                                  itemWidth: (MediaQuery.of(context).size.width - 36 - 10) / 2,
                                  itemHeight: MediaQuery.of(context).size.width / 3.8,
                                ),
                              )
                            : errorMessage != null
                                ? Container(
                                  height: MediaQuery.of(context).size.height/2,
                                    child: ErrorPage('Tap to retry', _callbackInitData, errorMessage),
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 200),
                                      child: Text('No coupon!'),
                                    ),
                                  ),
                  ),
                ],
              )
            : Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: NoInternetConnection(
                  callback: _callbackInitData,
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
