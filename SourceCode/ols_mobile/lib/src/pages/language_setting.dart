import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LanguageSettingPage extends StatefulWidget {
  LanguageSettingPage() {}

  @override
  State<StatefulWidget> createState() {
    return _LanguageSettingPageState();
  }
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _curentLanguage;
  ApplicationBloc applicationBloc;

  @override
  void initState() {
    super.initState();
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    _curentLanguage = applicationBloc.currentLanguageValue.value;
    if (_curentLanguage == null) {
      _curentLanguage = 'en';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: CommonColor.textBlack),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          FlutterI18n.translate(context, 'languageSettingPage.pageTitle'),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: CommonColor.textBlack,
          ),
        ),
        elevation: 0.7,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 30, 18, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/images/uk_flag.png'),
                    width: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('English'),
                  Spacer(),
                  Radio(
                    activeColor: Colors.orange,
                    value: LanguageSetting.LANGUAGE_EN,
                    groupValue: _curentLanguage,
                    onChanged: (String val) {
                      setState(() {
                        _curentLanguage = val;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/images/vi_flag.png'),
                    width: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Tiếng Việt'),
                  Spacer(),
                  Radio(
                    activeColor: Colors.orange,
                    value: LanguageSetting.LANGUAGE_VI,
                    groupValue: _curentLanguage,
                    onChanged: (String val) {
                      setState(() {
                        _curentLanguage = val;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: RaisedGradientButton(
                  onPressed: () {
                    _changeLanguage();
                  },
                  height: 38,
                  child: Text(
                    FlutterI18n.translate(context, 'languageSettingPage.buttonTitle'),
                    style: TextStyle(color: Colors.white),
                  ),
                  gradient: CommonColor.commonButtonColor,
                  borderRadius: 25,
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _changeLanguage() async {
    try {
      FlutterI18n.refresh(context, Locale(_curentLanguage));
      applicationBloc.changeLanguage(_curentLanguage);
      Reusable.showTotastSuccess(FlutterI18n.translate(context, 'languageSettingPage.messageSuccess'));
      Navigator.of(context).pop();
    } catch (error) {
      // Reusable.showTotastError(error);
    }
  }
}
