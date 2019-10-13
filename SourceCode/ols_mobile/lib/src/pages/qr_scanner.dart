import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/checkout.dart';
import 'package:ols_mobile/src/pages/redeem_success.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../main.dart';

class QRScannerPage extends StatefulWidget {
  final List couponIds;
  final Function callback;
  final QRCODE_TYPE qrType;
  String screenType = "";

  QRScannerPage({
    Key key,
    this.couponIds,
    this.callback,
    this.qrType,
    this.screenType,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QRScannerPageState();
  }
}

class _QRScannerPageState extends State<QRScannerPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DataService dataService = DataService();

  QRReaderController controller;
  AnimationController animationController;
  Animation<double> verticalPosition;

  String qrcode = "";

  QRCODE_TYPE qrType;

  bool loading = false;

  void initState() {
    super.initState();
    qrType = widget.qrType;
    checkAvailableCamera();
  }

  Future<Null> checkAvailableCamera() async {
    // Fetch the available cameras before initializing the app.
    try {
      if (cameras != null) {
        animationController = new AnimationController(
          vsync: this,
          duration: new Duration(seconds: 3),
        );

        animationController.addListener(() {
          this.setState(() {});
        });
        animationController.forward();
        verticalPosition = Tween<double>(begin: 0.0, end: 300.0).animate(CurvedAnimation(parent: animationController, curve: Curves.linear))
          ..addStatusListener((state) {
            if (state == AnimationStatus.completed) {
              animationController.reverse();
            } else if (state == AnimationStatus.dismissed) {
              animationController.forward();
            }
            
          });

        // pick the first available camera
        onNewCameraSelected(cameras[0]);
      }
    } on QRReaderException catch (e) {
      logError(e.code, e.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(0.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color.fromRGBO(00, 00, 00, 0.7),
              child: Center(child: _cameraPreviewWidget()),
            ),
            'WALLET' == widget.screenType || "CHECK_OUT" == widget.screenType
                ? Positioned(
                    top: 30,
                    right: 20,
                    child: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Color(0xFFE7E7E7),
                        ),
                        onPressed: () {
                          controller?.dispose();
                          Navigator.of(context).pop();
                        }))
                : Container(),
            Center(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setSp(300),
                    width: ScreenUtil().setSp(300),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Color(0xFF1EF929), width: 2.0)),
                    ),
                  ),
                  Positioned(
                    top: verticalPosition != null ? verticalPosition.value : 0,
                    left: 25,
                    child: Container(width: ScreenUtil().setSp(250), height: ScreenUtil().setSp(2), color: Color(0xFF1EF929)),
                  )
                ],
              ),
            ),
            // Align(
//                alignment: Alignment.bottomCenter,
//                child: Container(
//                    color: Color.fromRGBO(00, 00, 00, 0.7),
//                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//                      RaisedButton(
//                          color: qrType == QRCODE_TYPE.RECEIPT ? Colors.orange : Colors.grey,
//                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//                          child: Container(
//                            width: MediaQuery.of(context).size.width / 4,
//                            child: Text(
//                              'RECEIPT',
//                              textAlign: TextAlign.center,
//                              style: TextStyle(color: Colors.white),
//                            ),
//                          ),
//                          onPressed: () {
//                            setState(() {
//                              qrType = QRCODE_TYPE.RECEIPT;
//                              controller?.stopScanning();
//                              controller?.startScanning();
//                              // _scanReceiptDataCertificatePayAtTable(context, "245004|242502|3|2500|1000|81807*1||7ddfcbff20b762e87b3e946c1114982efa9e6f661d1b807e031dda37d00bc713|0");
//                              // _payAtTable(context, [19252],
//                                  // "1566803198746|262002|546|7|HDJ*182*3|57298dcb7bfde0fcef30251cfe070c790fa444f7fab8680d8d0bad86063da81f|1");
//                              // _scanReceiptDataCertificate(context, '245006|242502|5|10000|0|||d040de9d1986260bb7fec9a62cf423937ba50f10fdeee4d140947c1973be3230|0');
//                            });
//                          }),
//                      SizedBox(
//                        width: ScreenUtil().setSp(10),
//                      ),
//                      RaisedButton(
//                          color: qrType == QRCODE_TYPE.POS_ID ? Colors.orange : Colors.grey,
//                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//                          child: Container(
//                            width: MediaQuery.of(context).size.width / 4.8,
//                            child: Text(
//                              'POS ID',
//                              textAlign: TextAlign.center,
//                              style: TextStyle(color: Colors.white),
//                            ),
//                          ),
//                          onPressed: () {
//                            setState(() {
//                              qrType = QRCODE_TYPE.POS_ID;
//                              controller?.stopScanning();
//                              controller?.startScanning();
//                            });
//                            // TODO remove
//                            // _selectCouponOffline([], context,164602);
//                          }),
//                    ])
//                )
            // )
          ],
        ),
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'No camera selected',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: QRReaderPreview(controller),
      );
    }
  }

  void onCodeRead(dynamic qrcode) {
    var couponIds = [];
    if (widget.couponIds != null) {
      couponIds = widget.couponIds;
    }
    if (qrcode != null) {
        if (qrcode.toString().endsWith(QRCODE_RECEIPT_TYPE.PAY_AT_COUNTER_OFFLINE)) {
          setState(() {
            qrType = QRCODE_TYPE.RECEIPT;
          });
          _scanReceiptDataCertificate(context, qrcode.toString());
        } else if (qrcode.toString().endsWith(QRCODE_RECEIPT_TYPE.PAY_AT_TABLE_CHECK)) {
           setState(() {
            qrType = QRCODE_TYPE.RECEIPT;
          });
          _payAtTable(context, couponIds, qrcode.toString());
        } else if (qrcode.toString().endsWith(QRCODE_RECEIPT_TYPE.PAY_AT_TABLE_OFFLINE)) {
           setState(() {
            qrType = QRCODE_TYPE.RECEIPT;
          });
          _scanReceiptDataCertificatePayAtTable(context, qrcode.toString());
        } else {
            setState(() {
             qrType = QRCODE_TYPE.POS_ID; 
            });
          _selectCouponOffline(couponIds, context, qrcode.toString());
      }
    }
    // Future.delayed(const Duration(seconds: 10), controller.startScanning);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = new QRReaderController(cameraDescription, ResolutionPreset.high, [CodeFormat.qr, CodeFormat.pdf417], onCodeRead);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      // if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      if (mounted) {
        setState(() {});
        controller.startScanning();
      }
    } on QRReaderException catch (e) {
      logError(e.code, e.description);
      showInSnackBar('${e.code}\n${e.description}');
    }
  }

  void logError(String code, String message) => print('$code\nError Message: $message');

  // Scan invoice qrcode for PAY AT TABLE
  _payAtTable(context, couponIds, qrcode) async {
    setState(() {
      loading = true;
    });
    try {
      final res = await dataService.payAtTable(couponIds, qrcode);
      setState(() {
        loading = false;
      });
      if (res != null) {
        final errors = res['errors'];
        if (errors != null && errors is List) {
          // errors
          Reusable.showTotastError((errors[0]['message'] + ': ' + errors[0]['offerName']));
        } else {
          String cardHeaders = '';
          if (res['cardHeaders'] != null) {
            for (var i = 0; i < res['cardHeaders'].length; i++) {
              final cardHeader = res['cardHeaders'][i];
              if (cardHeaders.length > 0) {
                cardHeaders = cardHeaders + ' | ' + cardHeader['distributorName'].toString().toUpperCase() + '-' + cardHeader['cardHeader'];
              } else {
                cardHeaders = cardHeader['distributorName'].toString().toUpperCase() + '-' + cardHeader['cardHeader'];
              }
            }
          }
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return CheckoutPage(
                    qrCodeType: QRCODE_TYPE.RECEIPT,
                    authCode: res['authCode'],
                    grossAmount: res['grossAmount'],
                    discountAmount: res['discountAmount'],
                    nettAmount: res['nettAmount'],
                    nettAmountCyw: res['nettAmountCyw']??0,
                    transactionId: res['transactionId'],
                    cardHeaders: cardHeaders,
                    backWallet: _backWallet);
              },
              fullscreenDialog: true));
        }
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      if ('WALLET' == widget.screenType) {
        widget.callback(error.message ?? "");
        _backWallet();
      } else {
        Reusable.showTotastError(error.message ?? "");
      }
    }
  }

  //Select coupon to redeem
  _selectCouponOffline(couponIds, context, posId) async {
    setState(() {
      loading = true;
    });
    try {
      final res = await dataService.selectItemOffline(couponIds, posId);
      setState(() {
        loading = false;
      });
      if (res != null) {
        if (res['qrCode'] != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckoutPage(
                        qrCodeType: QRCODE_TYPE.POS_ID,
                        qrCode: res['qrCode'],
                      )));
        } else if (res['errors'] != null) {
          _backWallet();
          widget.callback(res['errors'][0]['message'] ?? "");
        }
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      if ('WALLET' == widget.screenType) {
        widget.callback(error.message ?? "");
        _backWallet();
      } else {
        Reusable.showTotastError(error.message ?? "");
      }
    }
  }

  //Scan QR Code offile transaction
  _scanReceiptDataCertificate(context, qrCode) async {
    setState(() {
      loading = true;
    });
    try {
      final res = await dataService.receiptDataCertificate(qrCode);
      setState(() {
        loading = false;
      });
      if (res != null) {
        final rewards = res['brandSpendRewardOffers'] ?? [];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RedeemSuccessPage(
                      rewardItems: rewards,
                    )));
      } else {
        Reusable.showTotastError("Unknow error !");
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      if ('WALLET' == widget.screenType) {
        widget.callback(error.message.toString() ?? "");
        _backWallet();
      } else {
        Reusable.showTotastError(error.message.toString() ?? "");
      }
    }
  }

  //Scan QR Code offile transaction
  _scanReceiptDataCertificatePayAtTable(context, qrCode) async {
    setState(() {
      loading = true;
    });
    try {
      final res = await dataService.receiptDataCertificatePayAtTable(qrCode);
      setState(() {
        loading = false;
      });
      print(res);
      if (res != null) {
        final rewards = res['brandSpendRewardOffers'] ?? [];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RedeemSuccessPage(
                      rewardItems: rewards,
                    )));
      } else {
        Reusable.showTotastError("Unknow error !");
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      if ('WALLET' == widget.screenType) {
        widget.callback(error.message.toString() ?? "");
        _backWallet();
      } else {
        Reusable.showTotastError(error.message.toString() ?? "");
      }
    }
  }

  @override
  void dispose() {
    animationController?.stop();
    animationController?.dispose();
    controller?.stopScanning();
    controller?.dispose();
    super.dispose();
  }

  void showInSnackBar(String message) {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(message)));
    }
  }

  _backWallet() {
    controller?.dispose();
    Navigator.of(context).pop();
  }
}
