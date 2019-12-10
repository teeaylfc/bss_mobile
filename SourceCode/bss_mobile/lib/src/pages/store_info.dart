import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/http_client.dart';
import 'package:bss_mobile/src/common/util/internet_connectivity.dart';
import 'package:bss_mobile/src/models/item_model.dart';
import 'package:bss_mobile/src/models/list_item_model.dart';
import 'package:bss_mobile/src/models/store_model.dart';
import 'package:bss_mobile/src/pages/loading-card.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/coupon_card.dart';
import 'package:bss_mobile/src/widgets/no_internet.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';

class StoreInfoPage extends StatefulWidget {
  final String storeId;
  const StoreInfoPage({Key key, this.storeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StoreInfoPageState();
  }
}

class _StoreInfoPageState extends State<StoreInfoPage> with AutomaticKeepAliveClientMixin<StoreInfoPage> {
  DataService dataService = DataService();

  bool loading = false;
  bool loadingItem = false;

  bool likeStatus = false;

  String errorMessage;

  ListItem storeItemList;

  int storeItemCount = 0;

  int totalFavorite;

  Store store;

  @override
  void initState() {
    super.initState();
    // getStoreItemList(0);
    // _getStoreDetail();
  }

  getStoreItemList(page) async {
    setState(() {
      loadingItem = true;
    });
    storeItemList = await dataService.getStoreItem(widget.storeId);
    setState(() {
      storeItemCount = storeItemList.totalElements;
      loadingItem = false;
    });
  }

  _getStoreDetail() async {
    setState(() {
      loading = true;
    });
    store = await dataService.getStoreDetail(widget.storeId);
    setState(() {
      loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: CommonColor.backgroundColor,
      appBar: AppBar(
        elevation: 1.0,
        iconTheme: IconThemeData(
          color: Color(0xffF76016),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          store != null ? store.storeName : 'Loading',
          style: TextStyle(
            color: CommonColor.textBlack,
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: CommonColor.textBlack,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: InternetConnectivity.internet
          ? Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(15), ScreenUtil().setSp(15), ScreenUtil().setSp(15), 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    loading
                        ? Container(
                            child: SpinKitFadingCircle(
                              color: Colors.grey,
                              size: 25,
                            ),
                          )
                        : _buildStoreCard(),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setSp(26), bottom: ScreenUtil().setSp(15)),
                      child: Text(
                        'Ưu đãi ($storeItemCount)',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: FontWeight.bold,
                          color: (Colors.black),
                        ),
                      ),
                    ),
                    _buildListDeal(
                      storeItemList,
                      312.0,
                      208.0,
                    )
                  ],
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: NoInternetConnection(),
            ),
    );
  }

  Widget _buildStoreCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0xFFE7E7E7), width: 0.5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE7E7E7),
            blurRadius: 2,
            offset: new Offset(0.0, 0.2),
          )
        ],
      ),
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(
                store.logoUrl,
                width: ScreenUtil().setSp(58),
                height: ScreenUtil().setSp(58),
              ),
              SizedBox(
                width: ScreenUtil().setSp(9),
              ),
              Text(
                store.storeName,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.bold,
                  color: (CommonColor.textGrey),
                ),
              ),
              Spacer(),
              _buildLikeButton(context)
            ],
          ),
          SizedBox(
            height: ScreenUtil().setSp(26),
          ),
          Text(
            store.description ?? '',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              color: (CommonColor.textGrey),
            ),
          )
        ],
      ),
    );
  }

  _buildLikeButton(context) {
    likeStatus = store.favourite != null ? store.favourite : false;
    return LikeButton(
      size: 20,
      circleColor: CircleColor(start: Color(0xFFFFCC18), end: Color(0xFFFFCC18)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xFFFFCC18),
        dotSecondaryColor: Color(0xFFFFCC18),
      ),
      onTap: (bool isLiked) {
        if (BlocProvider.of<ApplicationBloc>(context).getAuthStatus.value) {
          return _likeStore(store.storeId);
        }
      },
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.star,
          color: isLiked ? Color(0xFFFFCC18) : Colors.grey,
          size: 20,
        );
      },
      isLiked: likeStatus,
      likeCount: totalFavorite != null ? totalFavorite : store.favouriteCount ?? 0,
      countBuilder: (int count, bool isLiked, String text) {
        var color = isLiked ? Color(0xFFFFCC18) : Colors.grey;
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

  _buildListDeal(future, width, height) {
    return loadingItem
        ? Container(
            alignment: Alignment.topLeft,
            child: LoadingCard(
              itemWidth: width,
              itemHeight: height,
            ),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: storeItemList.content.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: ScreenUtil().setSp(168) / ScreenUtil().setSp(201),
              mainAxisSpacing: 7.0,
              crossAxisSpacing: 7.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              Item item = storeItemList.content[index];
              return ItemCard(
                item: item,
                showLocation: true,
                star: item.itemPrice != null ? item.itemPrice.toString() : '50',
                width: ScreenUtil().setSp(168),
                height: ScreenUtil().setSp(201),
                imageHeight: ScreenUtil().setSp(110),
                middleHeight: ScreenUtil().setSp(50),
                footerHeight: ScreenUtil().setSp(35),
                paddingRight: 0,
                paddingBottom: 0,
                displayType: DisplayType.GRID,
              );
            },
          );
  }

  Future<bool> _likeStore(id) async {
    final Completer<bool> completer = new Completer<bool>();
    try {
      final Store item = await dataService.likeStore(id);
      if (item != null) {
        Timer(const Duration(milliseconds: 200), () {
          completer.complete(item.favourite);
        });
      }
    } catch (error) {
      Reusable.showTotastError(error.message);
      completer.complete(likeStatus);
    }
    return completer.future;
  }

  Widget buildErrorText(AsyncSnapshot snapshot) {
    if (snapshot.hasError) {
      HttpError error = snapshot.error as HttpError;
      return Center(child: Text(error.message));
    }
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
