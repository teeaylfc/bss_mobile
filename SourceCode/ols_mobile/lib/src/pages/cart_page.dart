import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/util/internet_connectivity.dart';
import 'package:ols_mobile/src/models/item_model.dart';
import 'package:ols_mobile/src/pages/address_accept_gift.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/no_internet.dart';
import 'package:ols_mobile/src/widgets/order_item.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage>
    with AutomaticKeepAliveClientMixin<CartPage> {
  DataService dataService = DataService();
  RefreshController _refreshController = RefreshController();
  List<Item> listOrder;
  bool loading = false;
  final storage = new FlutterSecureStorage();
  String errorMessage;
  List<Item> cloneListOrder;
  ApplicationBloc applicationBloc;
  double totalPoint;
  int countList = 0;
  double balance = 0;
  List<String> listItemCode = [];

  @override
  void initState() {
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    getData();
    getUserBalance();
    super.initState();
  }

  getUserBalance() {
    dataService.getBalance().then((data) {
      print("respone: ${data.balance}");
      setState(() {
        balance = data.balance;
      });
    }).catchError((err) {});
  }

  getData() async {
    var token = await storage.read(key: Config.TOKEN_KEY);
    var listOrderLocal = await storage.read(key: Config.LIST_ORDER);
    if (token == null) {
      if (listOrderLocal == null) {
        cloneListOrder = [];
        setState(() {
          totalPoint = 0;
          listOrder = [];
          countList = 0;
        });
      } else {
        cloneListOrder = OrderList.fromJson(jsonDecode(listOrderLocal)).items;
        double count = 0;
        OrderList.fromJson(jsonDecode(listOrderLocal)).items.forEach((item) {
          count = count + (item.quantity * item.itemPrice);
        });
        setState(() {
          listOrder = OrderList.fromJson(jsonDecode(listOrderLocal)).items;
          totalPoint = count;
          countList =
              OrderList.fromJson(jsonDecode(listOrderLocal)).items.length;
        });
      }
      _refreshController.refreshCompleted();
    } else {
      loading = true;
      dataService.getListCart().then((data) {
        setState(() {
          _refreshController.refreshCompleted();
          listOrder = data.items;
          countList = data.totalElements;
          totalPoint = data.totalPoint;
          loading = false;
        });
        print('listOrder: ${data.toJson()}');
      }).catchError((err) {
        loading = false;
      });
    }
  }

  changeAmount(item, type) async {
    var token = await storage.read(key: Config.TOKEN_KEY);
    if (token == null) {
      if (type == ChangeAmount.MINUS && item.quantity == 0) {
        setState(() {
          countList = countList - 1;
        });
        var newList = cloneListOrder
            .where((obj) => obj.itemCode != item.itemCode)
            .toList();
        cloneListOrder = newList;
        double count = 0;
        if (cloneListOrder.length == 0) {
          setState(() {
            totalPoint = 0;
          });
        } else {
          cloneListOrder.forEach((obj) {
            count = count + obj.itemPrice * obj.quantity;
          });
          setState(() {
            totalPoint = count;
          });
        }
        OrderList orderList = OrderList(items: cloneListOrder);
        storage.write(key: Config.LIST_ORDER, value: jsonEncode(orderList));
      } else {
        double count = 0;
        cloneListOrder.forEach((obj) {
          if (item.itemCode == obj.itemCode) {
            obj.quantity = item.quantity;
            count = count + (item.quantity * item.itemPrice);
          } else {
            count = count + (obj.quantity * obj.itemPrice);
          }
        });
        OrderList orderList = OrderList(items: cloneListOrder);

        print("countPrice: ${cloneListOrder[0].toJson()}");
        setState(() {
          totalPoint = count;
        });
        storage.write(key: Config.LIST_ORDER, value: jsonEncode(orderList));
      }
      applicationBloc.getLocalOrderCount();
    } else {
      var jsonRequest = {"quantity": type == ChangeAmount.PLUS ? 1 : -1};
      dataService.addOrUpdateCart(item.itemCode, jsonRequest).then((data) {
        if (data.items != null) {
          setState(() {
            countList = data.totalElements;
            totalPoint = data.totalPoint;
          });
          if (data.items.length > 0) {
            int count = 0;
            cloneListOrder = data.items;
            data.items.forEach((obj) {
              count = count + obj.quantity;
            });
            applicationBloc.changeOrderCount(count);
          } else if (data.items.length == 0) {
            cloneListOrder = [];
            applicationBloc.changeOrderCount(0);
          } else {
            applicationBloc.changeOrderCount(0);
          }
        }
      }).catchError((err) {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: CommonColor.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Color(0xffF76016),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: CommonColor.commonLinearGradient),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: StreamBuilder(
            stream: applicationBloc.orderCountStream,
            builder: (context, snapshot) {
              print("snapshot: ${snapshot.data}");
              return Text('${FlutterI18n.translate(context, "cart_page.header")} (${snapshot.hasData? snapshot.data.toString() : "0"})');
            }),
        titleSpacing: 0.0,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: getData,
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
            ? !loading && listOrder != null
                ? CustomScrollView(slivers: [
                    SliverPadding(
                      padding: EdgeInsets.only(left: 0, right: 15),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Container(
                              padding: EdgeInsets.only(top: 19),
                              child: Slidable(
                                closeOnScroll: true,
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: OrderItem(
                                    item: listOrder[index],
                                    index: index,
                                    changeAmount: changeAmount),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: FlutterI18n.translate(context, "cart_page.delete"),
                                    color: Color(0xFFEB5757),
                                    icon: Icons.delete,
                                    onTap: () => _removeCart(listOrder[index]),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: listOrder?.length,
                        ),
                      ),
                    )
                  ])
                : Container(
                    child: SpinKitFadingCircle(
                      color: Colors.grey,
                      size: 25,
                    ),
                  )
            : Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: NoInternetConnection(),
              ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  _removeCart(item) async {
    var token = await storage.read(key: Config.TOKEN_KEY);
    if (token == null) {
      print("item: ${item.toJson()}");
      List<Item> newList =
          listOrder.where((obj) => obj.itemCode != item.itemCode).toList();
      setState(() {
        listOrder = newList;
        countList = countList - 1;
        totalPoint = newList.length == 0
            ? 0
            : totalPoint - (item.quantity * item.itemPrice);
      });
      cloneListOrder = newList;
      OrderList orderList = OrderList(items: newList);
      storage.write(key: Config.LIST_ORDER, value: jsonEncode(orderList));
      applicationBloc.getLocalOrderCount();
    } else {
      dataService.removeCart(item.itemCode).then((data) {
        setState(() {
          listOrder = data.items ?? [];
          countList = data.items.length ?? 0;
          totalPoint = data.totalPoint;
        });
        cloneListOrder = data.items ?? [];
        if (data.items != null && data.items.length > 0) {
          int count = 0;
          data.items.forEach((obj) {
            count = count + obj.quantity;
          });
          applicationBloc.changeOrderCount(count);
        } else {
          applicationBloc.changeOrderCount(0);
        }
      }).catchError((err) {});
    }
  }

  _buildBottomButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            spreadRadius: 5.0,
            offset: Offset(
              1.0,
              1.0,
            ),
          )
        ],
      ),
      height: ScreenUtil().setSp(80),
      padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    countList != 0
                        ? FlutterI18n.translate(context, "cart_page.offersSelected", {"offers": countList.toString()})
                        : 'Bạn chưa chọn ưu đãi nào',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                        color: CommonColor.textBlack),
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(9),
                  ),
                  Row(
                    children: <Widget>[
                      Image(
                        height: ScreenUtil().setSp(24),
                        image: AssetImage('assets/images/loyalty/m_dollar.png'),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(5),
                      ),
                      Text(
                        totalPoint != null ? totalPoint.toString() : "0",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.bold,
                          color: (CommonColor.textBlack),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              RaisedGradientButton(
                  child: Text(
                    FlutterI18n.translate(context, "cart_page.redeemGifts"),
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(16)),
                  ),
                  gradient: CommonColor.commonButtonColor,
                  height: ScreenUtil().setSp(40),
                  width: ScreenUtil().setSp(126),
                  borderRadius: 36,
                  onPressed: () {
                    _modalBottomSheetMenu();
                  })
            ],
          )
        ],
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: ScreenUtil().setSp(225),
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.fromLTRB(21, 10, 21, 21),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          FlutterI18n.translate(context, "cart_page.exchangeGiftWith"),
                          style: TextStyle(
                            color: CommonColor.textBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(17),
                          ),
                        ),
                      ),
//                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.black38),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(16),
                  ),
                  Row(
                    children: <Widget>[
                      Image(
                        height: ScreenUtil().setSp(42),
                        image: AssetImage('assets/images/loyalty/m_dollar.png'),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(9),
                      ),
                      Text(
                        totalPoint != null ? totalPoint.toString() : "0",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.bold,
                          color: (CommonColor.textGrey),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(16),
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(context, "cart_page.currentBalance"),
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.bold,
                          color: (CommonColor.textGrey),
                        ),
                      ),
                      Image(
                        height: ScreenUtil().setSp(14),
                        image: AssetImage(
                            'assets/images/loyalty/m_dollar_grey.png'),
                      ),
                      Text(
                        ' ${balance.toString()}',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.bold,
                          color: (CommonColor.textGrey),
                        ),
                      ),
                      Text(
                        '• ${FlutterI18n.translate(context, "cart_page.remainingBalance")}',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.bold,
                          color: (CommonColor.textGrey),
                        ),
                      ),
                      Image(
                        height: ScreenUtil().setSp(14),
                        image: AssetImage(
                            'assets/images/loyalty/m_dollar_grey.png'),
                      ),
                      Text(
                        ' ${(balance - totalPoint).toString()}',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.bold,
                          color: (CommonColor.textGrey),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        RaisedGradientButton(
                            child: Text(
                              FlutterI18n.translate(context, "cart_page.cancel"),
                              style: TextStyle(
                                  color: CommonColor.textGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(16)),
                            ),
                            color: Colors.white,
                            height: ScreenUtil().setSp(40),
                            width: ScreenUtil().setSp(126),
                            borderRadius: 36,
                            borderColor: Color(0xFFE7E7E7),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        Spacer(),
                        RaisedGradientButton(
                            child: Text(
                              FlutterI18n.translate(context, "cart_page.continue"),
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(16)),
                            ),
                            gradient: CommonColor.commonButtonColor,
                            height: ScreenUtil().setSp(40),
                            width: ScreenUtil().setSp(126),
                            borderRadius: 36,
                            onPressed: () => _acceptChangeGift())
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _acceptChangeGift() async {
    if (cloneListOrder != null) {
      for (int i = 0; i < cloneListOrder.length; i++) {
        listItemCode.add(cloneListOrder[i].itemCode);
      }
    } else {
      for (int i = 0; i < listOrder.length; i++) {
        listItemCode.add(listOrder[i].itemCode);
      }
    }
    bool a = await dataService.prepareCheckout(listItemCode);
    if (a == false) {
      var rs;
      try {
        rs = await dataService.checkoutCart(listItemCode, "");
        Navigator.pop(context);
        Navigator.pop(context);
        Reusable.showMessageDialog(true, "Đổi quà thành công", context);
      } catch (error) {
        Reusable.showMessageDialog(false," Max Allowed Quantity Exceeded!", context);
      }
    } else {
      var route = new MaterialPageRoute(
          builder: (context) => AddressAccepGift(
                listItemCode: listItemCode,
              ));
      Navigator.push(context, route);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
