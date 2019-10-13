import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Classic (default) Header
class CustomRefreshFooter extends RefreshFooter {
  final double loadHeight;
  final bool isFloat;
  final bool showMore;
  final Color backgroundColor;
  CustomRefreshFooter({@required GlobalKey<RefreshFooterState> key, this.backgroundColor = Colors.transparent, this.loadHeight: 70.0, this.isFloat: false, this.showMore: false})
      : super(key: key, loadHeight: loadHeight, isFloat: isFloat);

  @override
  CustomRefreshFooterState createState() => CustomRefreshFooterState();
}

class CustomRefreshFooterState extends RefreshFooterState<CustomRefreshFooter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Future onLoadReady() async {
    super.onLoadReady();
  }

  @override
  Future onLoading() async {
    super.onLoading();
  }

  @override
  Future onLoaded() async {
    super.onLoaded();
  }

  @override
  Future onNoMore() async {
    super.onNoMore();
  }

  @override
  Future onLoadRestore() async {
    super.onLoadRestore();
  }

  @override
  Future onLoadEnd() async {
    super.onLoadEnd();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: this.height,
      child: Container(
        color: widget.backgroundColor,
        height: this.height > 45.0 ? this.height : 45.0,
        child: this.refreshFooterStatus == RefreshFooterStatus.LOADING ||
                this.refreshFooterStatus == RefreshFooterStatus.NO_LOAD ||
                this.refreshFooterStatus == RefreshFooterStatus.LOAD_READY ||
                this.refreshFooterStatus == RefreshFooterStatus.LOADED
            ? Container(
                child: SpinKitFadingCircle(
                  color: Colors.grey,
                  size: 25,
                ),
              )
            : new Container(),
      ),
    );
  }
}
