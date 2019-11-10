import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/bankCard_link.dart';
import 'package:ols_mobile/src/pages/card_authentication.dart';
import 'package:ols_mobile/src/pages/main.dart';
import 'package:ols_mobile/src/service/local_authentication/service_locator.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
List<CameraDescription> cameras;

void main() async {
  setupLocator();
  try {
    cameras = await availableCameras();
  } on QRReaderException catch (e) {}
  await FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

  runApp(
    BlocProvider(
      child: MaterialApp(
        localizationsDelegates: [FlutterI18nDelegate(useCountryCode: false, fallbackFile: 'en', path: LanguageSetting.LANGUAGE_PATH), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        theme: ThemeData(
          primaryColor: CommonColor.textRed,
          fontFamily: "Roboto",
          canvasColor: Colors.transparent,
        ),
        // home: DistributorPage(),
        home: SplashPage(),
        routes: {
          'bankcard': (context) => BankCardLink(),
          '/cardAuthen': (context) => CardAuthenticaton(),
        },
      ),
      bloc: ApplicationBloc(),
    ),
  );
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    ScreenUtil.instance = ScreenUtil(width: 375, height: 667, allowFontScaling: true)..init(context);

    var currentLanguage = applicationBloc.currentLanguageValue.value;
    if (currentLanguage == null) {
      currentLanguage = LanguageSetting.LANGUAGE_EN;
    }
    FlutterI18n.refresh(context, Locale(currentLanguage));
    return Stack(
      children: <Widget>[
        SplashScreen(
            seconds: 2,
            navigateAfterSeconds: MainPage(),
            // image: Image(fit: BoxFit.cover, image: AssetImage('assets/images/loyalty/app_launcher_icon.png')),
            // imageBackground: AssetImage("assets/images/redeem_success_bg.png"),
            backgroundColor: Colors.white,
            styleTextUnderTheLoader: TextStyle(),
            // photoSize: ScreenUtil().setSp(50),
            loaderColor: Colors.transparent),
        Center(
          child: Column(
            children: <Widget>[
              Container(
                width: ScreenUtil().setSp(110),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/loyalty/logo_stadium.png',
                    ),
                  ),
                ),
              ),
              Text("BOOKING SPORT",style: TextStyle(
                color: Colors.green,
                fontSize: ScreenUtil().setSp(16),
              ),)
            ],
          ),
        ),
      ],
    );
  }
}
