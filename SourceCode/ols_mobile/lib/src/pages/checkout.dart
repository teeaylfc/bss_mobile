import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/main.dart';
import 'package:ols_mobile/src/pages/qr_scanner.dart';
import 'package:ols_mobile/src/pages/redeem_success.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/service/stellar_data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:ols_mobile/src/widgets/section_title.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final double grossAmount;
  final double discountAmount;
  final dynamic transactionId;

  final double nettAmount;
  final double nettAmountCyw;

  final QRCODE_TYPE qrCodeType;
  final String qrCode;
  final String authCode;
  final String cardHeaders;

  final Function backWallet;

  CheckoutPage(
      {this.grossAmount,
      this.nettAmount,
      this.nettAmountCyw,
      this.discountAmount,
      this.qrCodeType,
      this.qrCode,
      this.cardHeaders,
      this.authCode,
      this.backWallet,
      this.transactionId}) {}

  @override
  State<StatefulWidget> createState() {
    return _CheckoutPageState();
  }
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final formatCurrency = NumberFormat.simpleCurrency();
  DataService dataService = DataService();
  StellarDataService stellarDataService = StellarDataService();

  QrImage _qrImg;
  String cywBalanceFormatted;

  double cywBalance;

  String selectedStatus;
  bool loading = false;
  bool isLoadingBalance = false;
  bool payWithCyWEnable = false;

  appBar(context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(144, 187, 105, 0.14),
      elevation: 0.0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      iconTheme: IconThemeData(color: CommonColor.textRed),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(
            Icons.cancel,
            color: CommonColor.textGrey,
            size: 25,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _generateQR();
    if (widget.qrCodeType == QRCODE_TYPE.RECEIPT) {
      _getStellarBalance();
    }
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setNavigationBarColor(Colors.orange[200]);
    // if (useWhiteForeground(Colors.green[400])) {
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    // } else {
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // }
    return Scaffold(
      body: CustomScrollView(physics: AlwaysScrollableClampingScrollPhysics(), slivers: <Widget>[
        SliverAppBar(
          floating: false,
          pinned: true,
          snap: false,
          backgroundColor: Color.fromRGBO(144, 187, 105, 0.14),
          expandedHeight: ScreenUtil().setSp(170.0),
          automaticallyImplyLeading: false,
          actions: <Widget>[_buildCloseIcon()],
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setSp(30)),
                  child: Image(
                    height: ScreenUtil().setSp(70),
                    image: AssetImage('assets/images/dollar_icon.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
                child: widget.qrCodeType == QRCODE_TYPE.RECEIPT && _qrImg != null
                    ? Text(
                        'Coupon applied !',
                        style: TextStyle(color: CommonColor.textBlack, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(16)),
                      )
                    : Container(),
              ),
            ]),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _qrImg != null
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Center(
                          child: Text(
                            'Scan your code at counter to redeem reward',
                            style: TextStyle(color: Color(0xFFA9A9A9), fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Container(child: Center(child: _qrImg)),
                      )
                    ],
                  )
                : Container(),

            // Pay At Table
            widget.qrCodeType == QRCODE_TYPE.RECEIPT
                ? Column(
                    children: <Widget>[
                      Text(
                        widget.authCode ?? '',
                        style: TextStyle(fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.w500),
                      ),
                      widget.cardHeaders != null && widget.cardHeaders != ''
                          ? Column(
                              children: <Widget>[
                                SizedBox(
                                  height: ScreenUtil().setSp(15),
                                ),
                                Text(
                                  widget.cardHeaders != null && widget.cardHeaders != '' ? 'Coupons must pay using card: ' : '',
                                  style: TextStyle(
                                    color: CommonColor.textRed,
                                    fontSize: ScreenUtil().setSp(14),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.cardHeaders ?? '',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(16),
                                    fontWeight: FontWeight.bold,
                                    color: (CommonColor.textGrey),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  )
                : Center(),
            // Pay At Table
            widget.qrCodeType == QRCODE_TYPE.RECEIPT ? _buildInvoiceSection() : Container()
          ]),
        )
      ]),
      bottomNavigationBar: Container(
        // height: 140,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Color(0xFFD6D6D6),
            blurRadius: 5.0,
          ),
        ]),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: widget.qrCodeType == QRCODE_TYPE.RECEIPT ? _buildCYWWalletSection(context) : _buildScanNowSection(context),
        ),
      ),
    );
  }

  _buildCloseIcon() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(left: 10),
          height: ScreenUtil().setSp(35),
          width: ScreenUtil().setSp(35),
          child: Card(
            child: Icon(
              Icons.clear,
              color: CommonColor.textGrey,
              size: ScreenUtil().setSp(16),
            ),
            shape: CircleBorder(),
            color: Color(0xFFEAEAEA),
            elevation: 0.0,
          ),
        ));
  }

  _buildInvoiceSection() {
    return Column(
      children: <Widget>[
        SectionTitle('Summary'),

        /// Invoice
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 20),
          child: Card(
            child: Container(
              color: Color(0xffF1F3F4),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildRowItem('Total Invoice', '\$ ${widget.grossAmount.toStringAsFixed(2) ?? 0}'),
                    _buildRowItem('Coupon applied', '\$ -${widget.discountAmount.toStringAsFixed(2) ?? 0}', null, 0xFF27AE60),
                    Divider(
                      color: CommonColor.textGrey,
                    ),
                    _buildRowItem('Total ', '\$ ${widget.nettAmount.toStringAsFixed(2) ?? 0}'),
                    _buildRowItem('Pay with ' + CYW_DOLLAR.toLowerCase(), CYW_DOLLAR.toLowerCase() + ' ${widget.nettAmountCyw.toStringAsFixed(2) ?? 0}', 0xFFFA8526, 0xFFFA8526),
                  ],
                ),
              ),
            ),
          ),
        ),
        /// Invoice
      ],
    );
  }

  _buildRowItem(textLeft, textRight, [colorTextLeft, colorTextRight]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          Text(
            textLeft,
            style: TextStyle(
              color: Color(colorTextLeft != null ? colorTextLeft : 0xFF696969),
              fontSize: ScreenUtil().setSp(16),
            ),
          ),
          Spacer(),
          Text(
            textRight,
            style: TextStyle(
              color: Color(colorTextRight != null ? colorTextRight : 0xFF696969),
              fontSize: ScreenUtil().setSp(16),
            ),
          ),
        ],
      ),
    );
  }

  _buildPayButton(context) {
    return RaisedGradientButton(
        enable: payWithCyWEnable,
        child: Text(
          'Pay with ' + CYW_DOLLAR.toLowerCase(),
          style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
        ),
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)],
        ),
        height: ScreenUtil().setSp(40),
        width: ScreenUtil().setSp(126),
        borderRadius: 20,
        onPressed: () {
          payWithCyWEnable ? confirmDialog(context) : Reusable.showTotastError("Balance is not sufficient");
        });
  }

  _buildScanNowSection(context) {
    return Container(
      height: ScreenUtil().setSp(143),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Text(
          'Please scan QR code on your bill to earn reward.',
          style: TextStyle(
            color: CommonColor.textBlack,
            fontSize: ScreenUtil().setSp(14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: RaisedGradientButton(
              width: ScreenUtil().setSp(162),
              child: Text(
                'Scan Now',
                style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
              ),
              gradient: LinearGradient(
                colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)],
              ),
              height: ScreenUtil().setSp(42),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return QRScannerPage(
                        qrType: QRCODE_TYPE.RECEIPT,
                        screenType: "CHECK_OUT",
                      );
                    },
                    fullscreenDialog: true));
              }),
        )
      ]),
    );
  }

  _buildConfirmButton(context) {
    return Container(
      child: RaisedGradientButton(
          child: loading
              ? SizedBox(
                  width: ScreenUtil().setSp(20),
                  height: ScreenUtil().setSp(20),
                  child: SpinKitFadingCircle(
                    color: Colors.grey,
                    size: 40,
                  ),
                )
              : Text(
                  'Confirm',
                  style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w400, fontSize: ScreenUtil().setSp(14)),
                ),
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)],
          ),
          height: ScreenUtil().setSp(33),
          width: MediaQuery.of(context).size.width / 3,
          onPressed: () {
            payWithCYWStellar();
          }),
    );
  }

  _buildCancelutton(context) {
    return Container(
        child: RaisedGradientButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: CommonColor.textRed, fontWeight: FontWeight.w400, fontSize: ScreenUtil().setSp(14)),
            ),
            color: Colors.white,
            borderColor: CommonColor.textRed,
            height: ScreenUtil().setSp(33),
            width: MediaQuery.of(context).size.width / 3,
            onPressed: () {
              Navigator.of(context).pop(false);
            }));
  }

  Future<bool> confirmDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Pay with '+ CYW_DOLLAR.toLowerCase() +' ${widget.nettAmountCyw.toStringAsFixed(3) ?? 0} ?',
                  style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(20),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                  _buildCancelutton(context),
                  _buildConfirmButton(context),
                ]),
                SizedBox(
                  height: ScreenUtil().setSp(20),
                ),
              ],
            ),
          );
        });
  }

  _buildCYWWalletSection(context) {
    return Container(
      height: ScreenUtil().setSp(60),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/cyw_wallet.png'),
            width: ScreenUtil().setSp(42),
            height: ScreenUtil().setSp(35),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'CYW wallet',
                style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold, color: (CommonColor.textGrey)),
              ),
              Text(cywBalanceFormatted ?? "0.0" + CYW_DOLLAR.toLowerCase()),
            ],
          ),
          Spacer(),
          _buildPayButton(context),
        ],
      )),
    );
  }

  void _generateQR() async {
    String content;
    if (widget.qrCodeType == QRCODE_TYPE.RECEIPT) {
      content = widget.authCode;
    } else if (widget.qrCodeType == QRCODE_TYPE.POS_ID) {
      content = widget.qrCode;
    }

    QrImage image;
    if (content == null || content == '') {
      image = null;
    } else {
      try {
        if (widget.qrCodeType == QRCODE_TYPE.RECEIPT) {
          image = QrImage(
            data: content,
            size: 200,
            gapless: false,
            foregroundColor: const Color(0xFF111111),
          );
        } else if (widget.qrCodeType == QRCODE_TYPE.POS_ID) {
          image = QrImage(
            version: 25,
            data: content,
            size: 200,
            gapless: false,
            foregroundColor: const Color(0xFF111111),
          );
        }
      } on PlatformException {
        image = null;
      }
    }

    setState(() {
      _qrImg = image;
    });
  }

  _getStellarBalance() async {
    setState(() {
      isLoadingBalance = true;
    });
    try {
      final res = await stellarDataService.getStellarBalance();
      setState(() {
        if (res != null) {
          cywBalance = res;
          cywBalanceFormatted = formatCurrency.format(res);
          if (widget.nettAmountCyw != null && cywBalance >= widget.nettAmountCyw) {
            setState(() {
              payWithCyWEnable = true;
            });
          }
        }

        isLoadingBalance = false;
      });
    } catch (error) {
      setState(() {
        isLoadingBalance = false;
      });
      Reusable.showTotastError(error.toString());
    }
  }

  payWithCYWStellar() async {
    if (!loading) {
      try {
        setState(() {
          loading = true;
        });
        final res = await stellarDataService.payWithCYWStellar(widget.transactionId);
        setState(() {
          loading = false;
        });
        if (res != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RedeemSuccessPage()));
        } else {
          Navigator.of(context).pop(false);
          Reusable.showTotastError("Payment failed");
        }
      } catch (error) {
        setState(() {
          loading = false;
        });
        Navigator.of(context).pop(false);
        Reusable.showTotastError("Payment failed: " + error.message);
      }
    }
  }
}
