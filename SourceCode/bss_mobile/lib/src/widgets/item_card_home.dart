import 'package:flutter/material.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/util/image_util.dart';
import 'package:bss_mobile/src/common/util/internet_connectivity.dart';
import 'package:bss_mobile/src/models/item_model.dart';
import 'package:bss_mobile/src/pages/coupon_detail.dart';
import 'package:bss_mobile/src/widgets/m_point.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';

class ItemCardHome extends StatefulWidget {
  final Item item;
  final double width;
  final double height;
  final FontWeight subTextFontWeight;
  final double padding;

  ItemCardHome({this.item, this.width, this.height, this.subTextFontWeight, this.padding});

  @override
  _ItemCardHomeState createState() => _ItemCardHomeState();
}

class _ItemCardHomeState extends State<ItemCardHome> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  double opacityHeight;
  double containerHeight;

  double bottom;
  @override
  void initState() {
    opacityHeight = widget.height;
    containerHeight = widget.height;

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(animationController);

    bottom = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    animationController.forward();

    setState(() {
      if (opacityHeight == widget.height) {
        bottom = 10;
        opacityHeight = widget.height / 3;
        containerHeight = widget.height + 10;
      }
    });
  }

  void _onTapUp(TapUpDetails details) {
        animationController.reverse();

    setState(() {
      if (opacityHeight < widget.height) {
        opacityHeight = widget.height;
        bottom = 0;
        containerHeight = widget.height;
      }
    });
  }

  void _onTapCancel() {
            animationController.reverse();

    setState(() {
      if (opacityHeight < widget.height) {
        opacityHeight = widget.height;
        containerHeight = widget.height;
        bottom = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(animation.value);
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {
        _openCouponDtail(context, widget.item);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setSp(widget.padding)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  // curve: Curves.fastLinearToSlowEaseIn,
                  // duration: new Duration(milliseconds: 600),
                  width: ScreenUtil().setWidth(widget.width),
                  height: ScreenUtil().setHeight(widget.height),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ImageUtil.getImageUrlFromList(widget.item.imageDTO),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: animation.value,
                        child: AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: new Duration(milliseconds: 300),
                          width: ScreenUtil().setWidth(widget.width),
                          height: ScreenUtil().setHeight(opacityHeight),
                          foregroundDecoration: BoxDecoration(
                            color: Colors.black.withOpacity(.3),
                            // borderRadius: BorderRadius.circular(8.0),
                            borderRadius: opacityHeight == widget.height ? BorderRadius.all(Radius.circular(8)) : BorderRadius.all(Radius.zero),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 0, 5),
                            child: Text(
                              widget.item.companyName ?? '',
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                            child: Text(
                              widget.item.itemName ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: widget.subTextFontWeight),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 15),
                            child: MPoint(
                              point: widget.item.itemPrice.toString() ?? '0',
                              textColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _openCouponDtail(context, Item item) {
  }
}
