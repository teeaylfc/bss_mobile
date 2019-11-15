import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/util/image_util.dart';
import 'package:bss_mobile/src/common/util/internet_connectivity.dart';
import 'package:bss_mobile/src/models/item_model.dart';
import 'package:bss_mobile/src/pages/checkout_final.dart';
import 'package:bss_mobile/src/pages/coupon_detail.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/confirm_dialog.dart';
import 'package:bss_mobile/src/widgets/line_divider.dart';
import 'package:bss_mobile/src/widgets/m_point.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';

class ItemCard extends StatefulWidget {
  final Function callbackRedeem;
  final Function callbackRemoveCoupon;
  final Item item;
  final String distance;
  final String star;
  final bool showLocation;
  final double width;
  final double height;
  final double paddingBottom;
  final double paddingRight;
  final String pageContext;
  final int count;
  final double imageHeight;
  final double middleHeight;
  final double footerHeight;
  final DataService dataService;
  final String voucherCode;
  final double iconSize;
  final double pointFontSize;

  final String displayType;
  ItemCard(
      {this.voucherCode,
      this.item,
      this.showLocation,
      this.distance,
      this.star,
      this.width,
      this.height,
      this.imageHeight,
      this.middleHeight,
      this.footerHeight,
      this.paddingRight,
      this.paddingBottom,
      this.count,
      this.pageContext,
      this.callbackRedeem,
      this.callbackRemoveCoupon,
      this.dataService,
      this.iconSize,
      this.pointFontSize,
      this.displayType});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) {
      // if (status == AnimationStatus.completed) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

    void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    dynamic imageWidget = ImageUtil.getImageUrlFromList(widget.item.imageDTO);

    Widget distanceInfo = Container();
    if (widget.showLocation) {
      distanceInfo = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          widget.distance != null && widget.distance.length > 0
              ? Image(
                  height: ScreenUtil().setSp(14),
                  image: AssetImage('assets/images/map-pin.png'),
                )
              : Container(),
          widget.distance != null && widget.distance.length > 0
              ? Flexible(
                  child: AutoSizeText(
                    ' ' + widget.distance,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(13),
                      color: (CommonColor.textGrey),
                    ),
                  ),
                )
              : Container(),
          widget.distance != null && widget.distance.length > 0
              ? SizedBox(
                  width: ScreenUtil().setSp(8),
                )
              : Container(),
          widget.distance != null && widget.distance.length > 0
              ? Image(
                  height: ScreenUtil().setSp(3),
                  image: AssetImage('assets/images/dot.png'),
                )
              : Container(),
          widget.distance != null && widget.distance.length > 0
              ? SizedBox(
                  width: ScreenUtil().setSp(8),
                )
              : Container(),
          MPoint(
            iconSize: widget.iconSize,
            fontSize: widget.pointFontSize,
            point: widget.star,
          ),
        ],
      );
    }
    if (widget.pageContext != null && widget.pageContext == Page.WALLET || widget.pageContext == Page.REWARD) {
      distanceInfo = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            !widget.item.expired
                ? FlutterI18n.translate(context, "coupon_card.daysLeft", {"days": widget.item.remainingDay != null ? widget.item.remainingDay : ''})
                : FlutterI18n.translate(context, "coupon_card.expired"),
            style: TextStyle(color: CommonColor.textOrange, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.white30,
              onTap: () async {
                if (widget.item.expired) {
                  final ConfirmAction action = await _asyncConfirmDialog(context);
                } else {
                  widget.dataService.getQrCode(widget.voucherCode).then((data) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOutFinalPage(data["voucherNo"],
                        widget.item.store != null ? widget.item.store.storeName : "")));
                  });
                }
              },
              child: Container(
                width: ScreenUtil().setSp(67),
                child: widget.item.expired
                    ? AutoSizeText(
                        FlutterI18n.translate(context, "coupon_card.delete"),
                        textAlign: TextAlign.right,
                        style: TextStyle(color: CommonColor.textRed, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(13)),
                      )
                    : AutoSizeText(
                        FlutterI18n.translate(context, "coupon_card.useNow"),
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Color(0xff0A4DD0), fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(13)),
                      ),
              ),
            ),
          )
        ],
      );
    }
    BoxShadow boxShadow = BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.12).withOpacity(0.12),
      offset: new Offset(0.0, 0.0),
      blurRadius: 3.0,
    );

    _scale = 1 + _controller.value;

    return GestureDetector(
      onTapCancel: _onTapCancel,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: () {
        _openCouponDetail(context, widget.item);
      },
      child: Transform.scale(
        scale: _scale,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, widget.paddingRight, widget.paddingBottom),
          child: Container(
            margin: EdgeInsets.fromLTRB(3.0, 2, (widget.displayType != null ? (widget.displayType == DisplayType.GRID ? 0 : 3) : 12 - widget.paddingRight), 3),
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              border: new Border.all(color: Colors.transparent), borderRadius: BorderRadius.circular(16.0),
              // border: Border.all(color: Color(0xFFE7E7E7), width: 0.5),
              color: Colors.white,
              boxShadow: [boxShadow],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image(
                    image: imageWidget,
                    width: widget.width,
                    height: widget.imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setSp(12),
                    right: ScreenUtil().setSp(12),
                  ),
                  height: widget.middleHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AutoSizeText(
                          widget.item.itemName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: AutoSizeText(
                          widget.item.store != null && widget.item.store.storeName != null ? widget.item.store.storeName : '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CommonColor.textGrey,
                            fontSize: ScreenUtil().setSp(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                (widget.footerHeight != null && widget.footerHeight > 0)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          LineDivider(color: Color(0xFFE7E7E7)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            height: widget.footerHeight,
                            child: distanceInfo,
                          )
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          // ),
        ),
      ),
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: ConfirmDialog(
                  width: 306,
                  height: 200,
                  headline: 'Xoá ưu đãi',
                  title: 'Bạn chắc chắn muốn xoá ưu đãi này?',
                  callbackConfirm: removeItem,
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  removeItem() {
    // callbackRemoveCoupon(item.id, item.status);
  }

  _openCouponDetail(context, Item item) {
    InternetConnectivity.checkConnectivity().then(
      (data) {
        if (InternetConnectivity.internet) {
          Navigator.of(context).push(
            PageRouteBuilder<Null>(
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                  return AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget child) {
                        return Opacity(
                          opacity: animation.value,
                          child: ItemDetailPage(
                            itemCode: item.itemCode,
                            previousPage: widget.pageContext,
                          ),
                        );
                      });
                },
                transitionDuration: Duration(milliseconds: 250)),
          );
        } else {
          Reusable.showTotastError("No internet connection! Please try again");
        }
      },
    );
  }
}
