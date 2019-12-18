import 'dart:convert';

import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/pages/home.dart';
import 'package:bss_mobile/src/pages/main.dart';
import 'package:bss_mobile/src/pages/sign_in.dart';
import 'package:bss_mobile/src/service/local_authentication/service_locator.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

List<CameraDescription> cameras;
final _storage = new FlutterSecureStorage();

void main() async {
  runApp(
    BlocProvider(
      child: MaterialApp(
        localizationsDelegates: [
          FlutterI18nDelegate(
              useCountryCode: false,
              fallbackFile: 'en',
              path: LanguageSetting.LANGUAGE_PATH),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        theme: ThemeData(
          primaryColor: CommonColor.textRed,
          fontFamily: "Nunito",
          canvasColor: Colors.transparent,
        ),
        home: SplashPage(),
        // routes: <String, WidgetBuilder>{
        //   '/processCheckout': (BuildContext context) => ProcessCheckoutPage(),
        // },
      ),
      bloc: ApplicationBloc(),
    ),
  );
  setupLocator();
  try {
    cameras = await availableCameras();
  } on QRReaderException catch (e) {}
  FlutterStatusbarcolor.setStatusBarColor(Colors.black.withOpacity(0.2));
}

class ProcessCheckoutPage {}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool hasLogin = true;

  @override
  void initState() {
    // TODO: implement initState
    _getToken();
    super.initState();
  }

  _getToken() async {
    String token = await _storage.read(key: Config.TOKEN_KEY);
    if (token == null) {
      setState(() {
        hasLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    ScreenUtil.instance =
        ScreenUtil(width: 375, height: 667, allowFontScaling: true)
          ..init(context);

    var currentLanguage = applicationBloc.currentLanguageValue.value;
    if (currentLanguage == null) {
      currentLanguage = LanguageSetting.LANGUAGE_EN;
    }
    FlutterI18n.refresh(context, Locale(currentLanguage));
    return Stack(children: <Widget>[
      SplashScreen(
          seconds: 5,
          navigateAfterSeconds: hasLogin ? MainPage() : SignInPage(),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: TextStyle(),
          loaderColor: Colors.transparent),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
      colors: <Color>[Color(0xFF005e8a), Color(0xFFd8ffd6)],
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      stops: const <double>[0.0, 1],
      tileMode: TileMode.clamp)
        ),
        child: Column(
          children: <Widget>[
           Container(
             padding: EdgeInsets.only(top: ScreenUtil().setSp(100)),
                  child: Image.asset(
                    'assets/images/loyalty/app_launcher_icon.png',
                    fit: BoxFit.fitHeight,
                    width: MediaQuery.of(context).size.width / 1.8,
                  )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/4.5,
                  ),
                  SizedBox(
                width: ScreenUtil().setSp(50),
                height: ScreenUtil().setSp(50),
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xffD90D0D),
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Color(0XFFFC9A30),
                  ),
                ),
              )
          ],
        ),
      ),
    ]);
  }
}
