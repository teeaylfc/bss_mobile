import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/models/item_model.dart';
import 'package:bss_mobile/src/models/list_transaction_model.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/coupon_card.dart';
import 'package:bss_mobile/src/widgets/coupon_count.dart';
import 'package:bss_mobile/src/widgets/merchant_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class TransactionHistoryDetailPage extends StatefulWidget {
  final Transaction transaction;
  final String previousScreen;

  const TransactionHistoryDetailPage({this.transaction, this.previousScreen});

  @override
  State<StatefulWidget> createState() {
    return _TransactionHistoryDetailPageState();
  }
}

class _TransactionHistoryDetailPageState extends State<TransactionHistoryDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formatCurrency = NumberFormat.simpleCurrency();

  DataService dataService = DataService();
  List<CouponTransaction> usedItems = List<CouponTransaction>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if ('NOTIFICATION' != widget.previousScreen) {
      getTransactionDetail();
    } else {
      usedItems = widget.transaction.offerRedeems;
    }
  }

// Get transaction detail
  getTransactionDetail() {
    try {
      setState(() {
        loading = true;
      });
      dataService.getTransactionHistoryDetail(widget.transaction.transactionId).then((data) {
        setState(() {
          usedItems = data.offerRedeems;
        });
      });
    } catch (error) {}
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Transaction details'),
          elevation: 0.7,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(18), ScreenUtil().setSp(24), ScreenUtil().setSp(18), 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Transaction ' + widget.transaction?.transactionId.toString(),
                  style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(8),
                ),
                Text(
                  widget.transaction?.txnDatetime.toString(),
                  style: TextStyle(color: Color(0xFFA9A9A9), fontSize: ScreenUtil().setSp(14)),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(15),
                ),
                _buildTransactionDetail(),
                SizedBox(
                  height: ScreenUtil().setSp(30),
                ),
                usedItems != null && usedItems.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Coupon(s) used:',
                            style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold, color: CommonColor.textBlack),
                          ),
                          _buildUsedCoupon(),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTransactionDetail() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Color(0xFFE7E7E7),
        ),
      ),
      constraints: BoxConstraints(minHeight: ScreenUtil().setSp(257)),
      padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(15), ScreenUtil().setSp(15), ScreenUtil().setSp(15), ScreenUtil().setSp(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MerchantImage(imageId: widget.transaction.storeImage),
              SizedBox(
                width: ScreenUtil().setSp(8),
              ),
              Flexible(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.transaction?.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold, color: CommonColor.textBlack),
                      ),
                      SizedBox(
                        height: ScreenUtil().setSp(5),
                      ),
                      Text(
                        widget.transaction?.storeAddress,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: ScreenUtil().setSp(10), fontWeight: FontWeight.normal, color: Color(0xFFA9A9A9)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setSp(20),
          ),
          _buildRowItem('Total Invoice', (widget.transaction.netAmount != null ? formatCurrency.format(widget.transaction.grossAmount) : '0.00')),
          _buildRowItem('Coupon applied', (widget.transaction.netAmount != null ? formatCurrency.format(widget.transaction.discountAmount) : '0.00')),
          Divider(
            color: Color(0xffE7E7E7),
          ),
          _buildRowItem('Total ', (widget.transaction.netAmount != null ? formatCurrency.format(widget.transaction.netAmount) : '0.00')),
          _buildRowItem(CYW_DOLLAR + ' earned', (widget.transaction.awardAmount != null ? formatCurrency.format(widget.transaction.awardAmount) : '0.00')),
        ],
      ),
    );
  }

  _buildRowItem(textLeft, textRight, [colorTextLeft, colorTextRight]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          Text(
            textLeft,
            style: TextStyle(color: Color(colorTextLeft != null ? colorTextLeft : 0xFF696969), fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Text(
            textRight,
            style: TextStyle(color: Color(colorTextRight != null ? colorTextRight : 0xFF696969), fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  _buildUsedCoupon() {
    return usedItems != null && usedItems.length > 0
        ? Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
            child: SizedBox(
                height: ScreenUtil().setSp(125),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: usedItems.length,
                    itemBuilder: (context, int index) {
                      var item = usedItems[index];
                      return Stack(
                        children: <Widget>[
                          ItemCard(
                            // item: item,
                            showLocation: false,
                            width: ScreenUtil().setSp(150),
                            height: ScreenUtil().setSp(125),
                            imageHeight: ScreenUtil().setSp(77),
                            middleHeight: ScreenUtil().setSp(45),
                            footerHeight: ScreenUtil().setSp(0),
                            paddingRight: ScreenUtil().setSp(8),
                            paddingBottom: 0,
                          ),
                          Positioned(
                            right: ScreenUtil().setSp(8),
                            child: CouponCount(count: item.quantity),
                          )
                        ],
                      );
                    })),
          )
        : Container();
  }

  @override
  Future initData() {
    // TODO: implement initData
    return null;
  }
}
