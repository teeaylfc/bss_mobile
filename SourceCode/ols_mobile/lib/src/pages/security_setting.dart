import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/shared_preferences_util.dart';
import 'package:ols_mobile/src/service/auth_service.dart';
import 'package:ols_mobile/src/service/local_authentication/local_authentication_service.dart';
import 'package:ols_mobile/src/service/local_authentication/service_locator.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SecuritySettingPage extends StatefulWidget {
  SecuritySettingPage() {}

  @override
  State<StatefulWidget> createState() {
    return _SecuritySettingPageState();
  }
}

class _SecuritySettingPageState extends State<SecuritySettingPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _storage = new FlutterSecureStorage();

  AuthService authService = AuthService();

  final LocalAuthenticationService _localAuth = locator<LocalAuthenticationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var loading = false;
  var loginByBiometric = false;

  @override
  void initState() {
    _getBiometricClientSecret().then((_biometricClientSecret) {
      if (_biometricClientSecret != null && _biometricClientSecret.length > 0) {
        setState(() {
          loginByBiometric = true;
        });
      }
    });
    super.initState();
  }

  Future<String> _getBiometricClientSecret() async {
    return await _storage.read(key: Config.BIOMETRIC_CLIENT_SECRET);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          title: Text(
            'Security Setting',
            style: TextStyle(fontWeight: FontWeight.w500, color: CommonColor.textBlack),
          ),
          centerTitle: true,
          elevation: 0.7,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 30, 18, 0),
            child: ListTile(
              title: Text(
                'Login by fingerprint',
                style: TextStyle(
                  color: CommonColor.textBlack,
                  fontSize: ScreenUtil().setSp(16),
                ),
              ),
              subtitle: Text('Use your fingerprint instead of password'),
              onTap: () {},
              trailing: CupertinoSwitch(
                activeColor: Colors.orange,
                value: loginByBiometric,
                onChanged: (bool value) {
                  changeLoginSetting(value);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  changeLoginSetting(val) {
    if (!val && loginByBiometric) {
      _showCancelDialog();
    } else {
      _localAuth.authenticate().then((isAuthenticated) async {
        if (isAuthenticated) {
          final deviceId = await getDeviceId();
          final res = await authService.biometricRegister(deviceId);
          if (res != null) {
            setState(() {
              loginByBiometric = val;
            });
          }
          _showInfoDialog('Activate login by fingerprint successflly');
        } else {
          _showInfoDialog('Invalid biometric. Please try again.');

          setState(() {
            loginByBiometric = false;
          });
        }
      }).catchError((error) {
        print(error);
      });
    }
  }

  _unRegisterBiometric() async {
    final res = await authService.biometricUnRegister();
    if (res != null) {
      await _storage.delete(key: Config.BIOMETRIC_CLIENT_SECRET);
      setState(() {
        loginByBiometric = false;
      });
      // _showInfoDialog('Disable login by fingerprint successflly');
      Navigator.pop(context);
    } else {
      _showInfoDialog('Disable login by fingerprint unsuccessflly');
    }
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: new Text("Notice"),
        content: new Text("Are you sure to cancel logining the app by fingerprint?"),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Yes"),
            onPressed: () {
              _unRegisterBiometric();
            },
          ),
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void _showInfoDialog(text) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Notice"),
        content: new Text(text),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
