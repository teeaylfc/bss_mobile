import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/auth_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/http_client.dart';
import 'package:ols_mobile/src/models/account_info_model.dart';
import 'package:ols_mobile/src/models/bloc_delegate.dart';
import 'package:ols_mobile/src/models/item_model.dart';
import 'package:ols_mobile/src/models/user_modal.dart';
import 'package:ols_mobile/src/pages/main.dart';
import 'package:ols_mobile/src/pages/password-reset.dart';
import 'package:ols_mobile/src/pages/registration.dart';
import 'package:ols_mobile/src/service/auth_service.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/service/local_authentication/local_authentication_service.dart';
import 'package:ols_mobile/src/service/local_authentication/service_locator.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';

class SignInPage extends StatefulWidget {
  SignInPage() {}

  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> implements BlocDelegate<User> {
  final LocalAuthenticationService _localAuth =
      locator<LocalAuthenticationService>();
  AuthService authService = AuthService();
  DataService dataService = DataService();
  final _storage = new FlutterSecureStorage();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ApplicationBloc applicationBloc;


  //phuonglh9293@gmail.com/Oeoe999
  TextEditingController _emailController =
      TextEditingController(text: 'hoangnt@gmail.com');
  TextEditingController _passwordController =
      TextEditingController(text: '123');

  bool _obscureText = true;
  var connectivityResult;
  bool loading = false;
  bool loadingBiometric = false;

  @override
  void initState() {
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    getConnectionStatus();
    super.initState();
  }

  Future getConnectionStatus() async {
    connectivityResult = await (Connectivity().checkConnectivity());
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc(delegate: this);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: ScreenUtil().setSp(40)),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                width: ScreenUtil().setSp(98),
                height: ScreenUtil().setSp(98),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/loyalty/loy_logo.png'),
                  ),
                ),
              ),
            ),
            _showEmailInput(),
            _showPasswordInput(),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(40),
                    ScreenUtil().setSp(35),
                    ScreenUtil().setSp(40),
                    ScreenUtil().setSp(15)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _buildSignupButton(context, authBloc),
                    ),
                  ],
                )),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordResetPage(),
                  ),
                );
              },
              child: Center(
                child: Text(
                  FlutterI18n.translate(context, 'loginPage.forgetPass'),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(14), color: Colors.black),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                ScreenUtil().setSp(68),
                ScreenUtil().setSp(76),
                ScreenUtil().setSp(68),
                ScreenUtil().setSp(40),
              ),
              child: _buildSignupBiometricButton(
                context,
                authBloc,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, 'loginPage.notMember'),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        color: Color(0xff696969)),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationPage()));
                      },
                      child: Text(
                        FlutterI18n.translate(context, 'loginPage.createAccount'),
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color: Colors.blueAccent),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setSp(40),
        ScreenUtil().setSp(40),
        ScreenUtil().setSp(40),
        ScreenUtil().setSp(0),
      ),
      child:
          Stack(alignment: AlignmentDirectional.centerEnd, children: <Widget>[
        TextFormField(
          controller: _emailController,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          style: new TextStyle(
            color: Color(0xff343434),
            fontSize: ScreenUtil().setSp(18),
          ),
          decoration: InputDecoration(
              labelText:  FlutterI18n.translate(context, 'loginPage.phone'),
              labelStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(15),
                  color: Color(0xff9b9b9b),
                  fontWeight: FontWeight.w500),
              contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffBDBDBD)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              )),
          validator: (value) =>
              value.isEmpty ? FlutterI18n.translate(context, 'loginPage.phoneEmpty') : null,
          onSaved: (value) => {},
        ),
        Padding(
          padding: EdgeInsets.only(right: ScreenUtil().setSp(14)),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _emailController.text = '';
              });
            },
            child: Container(),
          ),
        )
      ]),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(40),
          ScreenUtil().setSp(27),
          ScreenUtil().setSp(40),
          ScreenUtil().setSp(0)),
      child: TextFormField(
        controller: _passwordController,
        maxLines: 1,
        obscureText: _obscureText,
        autofocus: false,
        style: new TextStyle(
          color: Color(0xff343434),
          fontSize: ScreenUtil().setSp(18),
        ),
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
                semanticLabel: _obscureText ? 'show password' : 'hide password',
                color: Colors.black,
                size: 15),
          ),
          labelText: FlutterI18n.translate(context, 'loginPage.pass'),
          labelStyle: TextStyle(
              fontSize: ScreenUtil().setSp(15),
              color: Color(0xff9b9b9b),
              fontWeight: FontWeight.w500),
          contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 5),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffBDBDBD)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        validator: (value) => value.isEmpty ? FlutterI18n.translate(context, 'loginPage.passEmpty') : null,
        onSaved: (value) => {},
      ),
    );
  }

  _buildSignupButton(context, AuthBloc authBloc) {
    return RaisedGradientButton(
        child: loading
            ? SizedBox(
                width: ScreenUtil().setSp(20),
                height: ScreenUtil().setSp(20),
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xffD90D0D),
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Color(0XFFFC9A30),
                  ),
                ),
              )
            : Text(
          FlutterI18n.translate(context, 'loginPage.login'),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(16),
                ),
              ),
        gradient: CommonColor.commonButtonColor,
        height: ScreenUtil().setSp(40),
        onPressed: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          if (!loading && !loadingBiometric) {
            setState(() {
              loading = true;
            });
            authBloc.login(_emailController.text, _passwordController.text);
          }
           Navigator.push(
               context, MaterialPageRoute(builder: (context) => MainPage()));

        });
  }

  _buildSignupBiometricButton(context, authBloc) {
    return RaisedGradientButton(
        child: loadingBiometric
            ? SizedBox(
                width: ScreenUtil().setSp(20),
                height: ScreenUtil().setSp(20),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Color(0XFFFC9A30),
                  ),
                ),
              )
            : Text(
          FlutterI18n.translate(context, 'loginPage.touchId'),
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(16)),
              ),
        image: AssetImage(
          'assets/images/loyalty/touch_id.png',
        ),
        borderRadius: 34,
        // borderColor: Colors.black,
        imageWidth: ScreenUtil().setSp(40),
        imageHeight: ScreenUtil().setSp(40),
        color: Colors.transparent,
        height: ScreenUtil().setSp(40),
        width: ScreenUtil().setSp(238),
        onPressed: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          if (!loading && !loadingBiometric) {
            _authenticateByBiometric(authBloc);
          }
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => MainPage()));
        });
  }

  @override
  error(HttpError error) {
    setState(() {
      loading = false;
      loadingBiometric = false;
    });
    Reusable.showTotastError(error.message);
  }

  @override
  success(user) async {
    setState(() {
      loading = false;
      loadingBiometric = false;
    });
    BlocProvider.of<ApplicationBloc>(context).changeCurrentUser(user);
    BlocProvider.of<ApplicationBloc>(context).changeAuthenticationStatus(true);
    BlocProvider.of<ApplicationBloc>(context)
        .changeOrderCount(user.walletCount);

    _getListOrder();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
      (Route<dynamic> route) => false,
    );
    return null;
  }

  _getListOrder() async {
    var listOrder = await _storage.read(key: Config.LIST_ORDER);
//    print("data add card: ${listOrder}");
    if (listOrder != null) {
      var listCart = OrderList.fromJson(jsonDecode(listOrder)).items;
      List newList = [];
      listCart.forEach((item) {
        var newItem = {"itemCode": item.itemCode, "quantity": item.quantity};
        newList.add(newItem);
      });
      dataService.addCartAfterLogin(newList).then((data) {
        int count = 0;
        data.items.forEach((item){
          count = count + item.quantity;
        });
        applicationBloc.changeOrderCount(count);
      }).catchError((err) {
        print('err');
      });
      _storage.delete(key: Config.LIST_ORDER);
    }
    else{
      applicationBloc.getOrderCount();
    }
  }

  _getBiometricClientSecret() async {
    return await _storage.read(key: Config.BIOMETRIC_CLIENT_SECRET);
  }

  void _authenticateByBiometric(AuthBloc authBloc) async {
    final biometricClientSecret = await _getBiometricClientSecret();
    if (biometricClientSecret == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Notice"),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
                'Biometric authentication is not enable. Please go to Security Setting to enable this function.'),
          ),
          actions: [
            FlatButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    } else {
      _localAuth.authenticate().then((isAuthenticated) {
        if (isAuthenticated) {
          setState(() {
            loadingBiometric = true;
          });
          authBloc.loginBiometric(_emailController.text, biometricClientSecret);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Error"),
              content: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text('Invalid biometric. Please try again.')),
              actions: [
                FlatButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
        }
      });
    }
  }
}
