import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/pages/checkout.dart';
import 'package:bss_mobile/src/pages/redeem_success.dart';
import 'package:bss_mobile/src/pages/shift_detail.dart';
import 'package:bss_mobile/src/service/data_service.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
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
        verticalPosition = Tween<double>(begin: 0.0, end: ScreenUtil().setSp(380)).animate(CurvedAnimation(parent: animationController, curve: Curves.linear))
          ..addStatusListener((state) {
            if (state == AnimationStatus.completed) {
              animationController.forward();
              animationController.repeat();
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
               
            Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Opacity(
                        opacity: 0.65,
                        child: Container(
                          color: Colors.black,
                        )),
                  ),
                  Opacity(
                    opacity: 1,
                    child: Container(
                      width: ScreenUtil().setSp(30),
                      color: Colors.green,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Opacity(
                          opacity: 0.65,
                          child: Container(
                            width: ScreenUtil().setSp(40),
                            height: ScreenUtil().setSp(320),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil().setSp(320),
                            width: ScreenUtil().setSp(300),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: ScreenUtil().setSp(20),
                                    height: ScreenUtil().setSp(20),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: ScreenUtil().setSp(4)),
                                      left: BorderSide(
                                          color: Colors.white,
                                          width: ScreenUtil().setSp(4)),
                                    )),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: ScreenUtil().setSp(20),
                                    height: ScreenUtil().setSp(20),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      top: BorderSide(
                                          color: Colors.white,
                                          width: ScreenUtil().setSp(4)),
                                      right: BorderSide(
                                          color: Colors.white,
                                          width: ScreenUtil().setSp(4)),
                                    )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: ScreenUtil().setSp(20),
                                    height: ScreenUtil().setSp(20),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                          color: Colors.white,
                                          width: ScreenUtil().setSp(4)),
                                      left: BorderSide(
                                          color: Colors.white,
                                          width: ScreenUtil().setSp(4)),
                                    )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: ScreenUtil().setSp(20),
                                    height: ScreenUtil().setSp(20),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                          color: Colors.white,
                                          width: ScreenUtil().setSp(4)),
                                      right: BorderSide(
                                          color: Colors.white,
                                          width: ScreenUtil().setSp(4)),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: verticalPosition != null
                                ? verticalPosition.value
                                : 0,
                            left: ScreenUtil().setSp(0),
                            child: Column(
                              children: <Widget>[
                                Opacity(
                                  opacity: 1,
                                  child: Container(
                                    width: ScreenUtil().setSp(320),
                                    height: ScreenUtil().setSp(30),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFFc2f9ff),
                                              Colors.transparent
                                            ],
                                            begin: FractionalOffset.topCenter,
                                            end: FractionalOffset.bottomCenter,
                                            stops: const <double>[0.0, 1],
                                            tileMode: TileMode.clamp)
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: Opacity(
                          opacity: 0.65,
                          child: Container(
                            width: ScreenUtil().setSp(40),
                            height: ScreenUtil().setSp(320),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Opacity(
                        opacity: 0.65,
                        child: Container(
                          color: Colors.black,
                        )),
                        
                  ),
                ],
              ),
            ),
            Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Color(0xFFE7E7E7),
                        ),
                        onPressed: () {
                          controller?.dispose();
                          Navigator.of(context).pop();
                        })),
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
      dataService.getDetailContract(qrcode).then((data){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftDetailPage(data, '',type: "VIEW",)));
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ShiftDetailPage(data,'',type: "VIEW",)));
      });
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
