import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Classic (default) Header
class CustomRefreshHeader extends RefreshHeader {
  final Color textColor;
  final double refreshHeight;
  final bool isFloat;
  final bool showMore;
  final String moreInfo;
  final Color loadingColor;
  final Gradient gradient;
  final Color color;

  CustomRefreshHeader({@required GlobalKey<RefreshHeaderState> key, this.textColor: Colors.white, this.loadingColor: Colors.grey, 
  this.refreshHeight: 70.0, this.isFloat: false, this.showMore: false, this.gradient, this.moreInfo: "Updated at %T", this.color})
      : super(key: key, refreshHeight: refreshHeight, isFloat: isFloat);

  @override
  CustomRefreshHeaderState createState() => CustomRefreshHeaderState();
}

class CustomRefreshHeaderState extends RefreshHeaderState<CustomRefreshHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Future onRefreshReady() async {
    super.onRefreshReady();
  }

  @override
  Future onRefreshing() async {
    super.onRefreshing();
  }

  @override
  Future onRefreshed() async {
    super.onRefreshed();
  }

  @override
  Future onRefreshRestore() async {
    super.onRefreshRestore();
  }

  @override
  Future onRefreshEnd() async {
    super.onRefreshEnd();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: widget.gradient != null ? BoxDecoration(gradient: widget.gradient) : BoxDecoration(color: widget.color != null ? widget.color : Color(0xFFFB6753)),
      height: this.height,
      child: Container(
        height: this.height > 45.0 ? this.height : 45.0,
        child: this.refreshHeaderStatus == RefreshHeaderStatus.REFRESHING ||
                this.refreshHeaderStatus == RefreshHeaderStatus.NO_REFRESH ||
                this.refreshHeaderStatus == RefreshHeaderStatus.REFRESH_READY ||
                this.refreshHeaderStatus == RefreshHeaderStatus.REFRESHED
            ? Container(
                child: SpinKitFadingCircle(
                  color: widget.loadingColor,
                  size: 25,
                ),
              )
            : new Container(),
      ),
    );
  }
}
