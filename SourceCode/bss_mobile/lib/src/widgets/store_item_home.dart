import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/models/store_model.dart';
import 'package:bss_mobile/src/pages/store_info.dart';

class StoreItemHome extends StatefulWidget{
  Store item;

  StoreItemHome(this.item);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StoreItemHomeState();
  }

}

class _StoreItemHomeState extends State<StoreItemHome> with SingleTickerProviderStateMixin{
  Store item;

  AnimationController _controller;
  double _scale;

  @override
  void initState() {
    item =  widget.item;
    _initAnimationController();
  }
  _initAnimationController(){
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
      if (status == AnimationStatus.completed) _controller.reverse();
    });
  }


  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 + _controller.value;
    return Padding(
      padding: EdgeInsets.only(right: 14),
      child: Container(
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTap: () {
            Navigator.of(context).push(
               MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return StoreInfoPage(
                      storeId: item.storeId,
                    );
                  },
                  fullscreenDialog: true),
            );
          },
          child:  Transform.scale(
            scale: _scale,
            child: Container(
              width: ScreenUtil().setHeight(78),
              height: ScreenUtil().setWidth(78),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.logoUrl),
                    fit: BoxFit.cover,
                  ),
                  border: new Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }


}