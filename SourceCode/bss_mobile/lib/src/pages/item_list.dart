import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:bss_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/models/category_model.dart';
import 'package:bss_mobile/src/models/item_model.dart';
import 'package:bss_mobile/src/pages/page_state.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/coupon_card.dart';
import 'package:bss_mobile/src/widgets/refresh_footer.dart';
import 'package:bss_mobile/src/widgets/refresh_header.dart';
import 'package:bss_mobile/src/widgets/search.dart';

class ItemListPage extends StatefulWidget {
  final dynamic object;

  ItemListPage({this.object});

  @override
  State<StatefulWidget> createState() => _ItemListPageState();
}

class _ItemListPageState extends PageState<ItemListPage> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  DataService dataService = DataService();

  List<Item> listCoupon = List<Item>();

  _ItemListPageState();

  String previousPage;

  String type;

  String title;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.object['previousPage'] != null) {
      previousPage = widget.object['previousPage'];
    }
    if (widget.object['type'] != null) {
      type = widget.object['type'];
    }
    loadData();
  }

  @override
  void didUpdateWidget(ItemListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xffF42E13),
          elevation: 0.0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: 'SEARCH' != previousPage && 'CATEGORY' != previousPage
              ? Text(
                  title ?? '',
                  style: TextStyle(color: Colors.white),
                )
              : SearchField(
                  keyword: title,
                  paddingLeft: false,
                  callbackSearch: _initSearch,
                  callbackGetByCategory: _initGetByCategory,
                ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              back();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              children: <Widget>[
                _buildListChip(),
                (listCoupon != null && listCoupon.length > 0)
                    ? Expanded(
                        child: _buildListCoupon(),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
                        child: Center(
                          child: Text(
                            !loading ? 'Không có ưu đãi nào được tìm thấy. \n\nThử lại với tìm kiếm khác!' : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 0.6,
                              color: CommonColor.textGrey,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildListChip() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(8)),
      child: SizedBox(
        height: ScreenUtil().setSp(40),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            FilterChip(
              backgroundColor: Color(0xFFF1F3F4),
              label: Text(
                "juice & smoothies",
                style: TextStyle(color: CommonColor.textGrey),
              ),
              onSelected: (bool value) {
                print("selected");
              },
            ),
            SizedBox(
              width: ScreenUtil().setSp(10),
            ),
            FilterChip(
              backgroundColor: Color(0xFFF1F3F4),
              label: Text(
                "milk tea",
                style: TextStyle(color: CommonColor.textGrey),
              ),
              onSelected: (bool value) {
                print("selected");
              },
            ),
            SizedBox(
              width: ScreenUtil().setSp(10),
            ),
            FilterChip(
              backgroundColor: Color(0xFFF1F3F4),
              label: Text(
                "coffee",
                style: TextStyle(color: CommonColor.textGrey),
              ),
              onSelected: (bool value) {
                print("selected");
              },
            ),
          ],
        ),
      ),
    );
    // End List Chips
  }

  Widget _buildListCoupon() {
    return EasyRefresh(
      autoLoad: false,
      key: _easyRefreshKey,
      refreshHeader: CustomRefreshHeader(
        color: Colors.white,
        loadingColor: Colors.grey,
        key: _headerKey,
      ),
      refreshFooter: CustomRefreshFooter(
        key: _footerKey,
      ),
      child: CustomScrollView(slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var item = listCoupon[index];
              return ItemCard(
                item: item,
                showLocation: true,
                star: item.itemPrice != null ? item.itemPrice.toString() : '',
                width: ScreenUtil().setSp(345),
                height: ScreenUtil().setSp(281),
                imageHeight: ScreenUtil().setSp(174),
                middleHeight: ScreenUtil().setSp(67),
                footerHeight: ScreenUtil().setSp(37),
                paddingRight: 0,
                paddingBottom: ScreenUtil().setSp(20),
                count: 0,
                displayType: 'BIG_CARD',
                      iconSize: ScreenUtil().setSp(18),
                            pointFontSize: ScreenUtil().setSp(14),
              );
            },
            childCount: listCoupon.length,
          ),
        )
      ]),
      onRefresh: () async {
        refreshData();
      },
      loadMore: () async {
        loadMoreData();
      },
    );
  }

  back() {
    if ('HOME' == previousPage) {
      bottomNavBarBloc.pickItem(PageIndex.DISCOVER);
    } else if ('CATEGORY' == previousPage) {
      bottomNavBarBloc.pickItem(PageIndex.CATEGORY_LIST);
    } else if ('BROWSER' == previousPage) {
      bottomNavBarBloc.pickItem(PageIndex.BROWSER);
    } else if ('SEARCH' == previousPage) {
      bottomNavBarBloc.pickItem(PageIndex.BROWSER);

      // Navigator.of(context).push(
      //   PageRouteBuilder<Null>(
      //       pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      //         return AnimatedBuilder(
      //             animation: animation,
      //             builder: (BuildContext context, Widget child) {
      //               return Opacity(
      //                 opacity: animation.value,
      //                 child: SearchPage(keyword: title),
      //               );
      //             });
      //       },
      //       transitionDuration: Duration(milliseconds: 200)),
      // );
    }
  }

  @override
  Future initData() {
    listCoupon = [];
    page = 1;
  }

  _initSearch(keyword) {
    title = keyword;
    dataService.search(keyword, page).then((data) {
      setData(data);
    }).catchError((error) {});
  }

  _initGetByCategory(Category category) {
    title = category.categoryDescription;

    dataService.getItemByCategory(widget.object['category'].categoryCode, page).then((data) {
      setData(data);
    }).catchError((error) {});
  }

  loadData() {
    setState(() {
      loading = true;
      if ('NEWEST' == type) {
        dataService.getNewestItem(page).then((data) {
          setData(data);
        }).catchError((error) {});
        title = 'Mới nhất';
      }else if("INTERESTING" == type){
        dataService.getInterestingItem(page).then((data) {
          setData(data);
        }).catchError((error) {});
        title = "Ưu đãi hấp dẫn" ;
      }else if("EXPIRESOON" == type){
        dataService.getExpireSoon(page).then((data) {
          setData(data);
        }).catchError((error) {});
        title = "Ưu đãi sắp hết hạn";
      }
      else if ('SEARCH' == previousPage) {
        _initSearch(widget.object['keyword'].toString().trim());
      }
      else if (widget.object['category'] != null) {
        title = widget.object['category'].categoryDescription;
        if ('TOP-BOOK' == type) {
          dataService.getInterestingItem(page).then((data) {
            setData(data);
          }).catchError((error) {});
        } else if ('NEARBY' == type) {
          dataService.getExpireSoon(page).then((data) {
            setData(data);
          }).catchError((error) {});
        } else {
          _initGetByCategory(widget.object['category']);
        }
      } else if (('BOOKING' == type || 'REWARD' == type) && 'SEARCH' != previousPage) {
        if ('REWARD' == type) {
          title = "REWARDS";
        } else {
          title = type;
        }
        dataService.getListItemBookingRewards(type, page).then((data) {
          setData(data);
        }).catchError((error) {});
      }
    });
  }

  setData(data) {
    loading = false;
    setState(() {
      if (page == 0) {
        listCoupon = [];
      }
      listCoupon.addAll(data.content);
      last = data.last;
    });
  }

  @override
  Future loadMoreData() async {
    if (!last) {
      page++;
      loadData();
    } else {
      print('last page..........');
    }
  }

  @override
  Future refreshData() async {
    page = 0;
    loadData();
  }
}
