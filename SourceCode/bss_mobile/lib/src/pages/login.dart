import 'package:bss_mobile/src/blocs/application_bloc.dart';
import 'package:bss_mobile/src/blocs/auth_bloc.dart';
import 'package:bss_mobile/src/blocs/bloc_provider.dart';
import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:bss_mobile/src/common/flutter_screenutil.dart';
import 'package:bss_mobile/src/common/http_client.dart';
import 'package:bss_mobile/src/models/bloc_delegate.dart';
import 'package:bss_mobile/src/models/user_modal.dart';
import 'package:bss_mobile/src/pages/main.dart';
import 'package:bss_mobile/src/pages/registration.dart';
import 'package:bss_mobile/src/pages/sign_in.dart';
import 'package:bss_mobile/src/service/auth_service.dart';
import 'package:bss_mobile/src/style/color.dart';
import 'package:bss_mobile/src/widgets/raised_gradient_button.dart';
import 'package:bss_mobile/src/widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LogInPage extends StatefulWidget {
  LogInPage() {}

  @override
  State<StatefulWidget> createState() {
    return _LogInPageState();
  }
}

class _LogInPageState extends State<LogInPage> implements BlocDelegate<User> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _message = 'Log in/out by pressing the buttons below.';

  bool loading = false;
  AuthService authService = AuthService();
  GoogleSignInAccount _googleUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc(delegate: this);

    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
        ),
        body: Container(
            child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 14,
                ),
                // SvgPicture.asset("assets/images/logo1.svg", height: 20.0, width: 20.0, color: Colors.orange,),
                _buildLoginButton(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 26,
                ),

                Row(
                  children: <Widget>[
                    Expanded(child: Container(height: 1, color: Color(0xFFa9a9a9))),
                    Text(
                      '   or   ',
                      style: TextStyle(color: Color(0xFFa9a9a9)),
                    ),
                    Expanded(child: Container(height: 1, color: Color(0xFFa9a9a9)))
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 26,
                ),

                Row(
                  children: <Widget>[_buildSocialButton(AssetImage('assets/images/f.png'), authBloc, 'facebook'), SizedBox(width: ScreenUtil().setSp(20)), _buildSocialButton(AssetImage('assets/images/g.png'), authBloc, 'google')],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 26,
                ),
                Row(
                  children: <Widget>[
                    Text('Not a member yet? ', style: TextStyle(color: Color(0xFFa9a9a9), fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.w200)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                      },
                      child: Text(
                        'Create an account',
                        style: TextStyle(
                          color: CommonColor.textRed,
                          fontSize: ScreenUtil().setSp(13),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 18,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Text('By singing in you acccept our', style: TextStyle(color: Color(0xFFa9a9a9), fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w200)),
                Text(
                  ' Terms and condidions',
                  style: TextStyle(
                    color: CommonColor.textGrey,
                    fontSize: ScreenUtil().setSp(12),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ])),
      ),
    );
  }

  _buildLoginButton(context) {
    return RaisedGradientButton(
        child: Text(
          'Sign in with email',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
        ),
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFF76016), Color(0xFFFC9A30)],
        ),
        image: AssetImage('assets/images/email.png'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
        });
  }

  _buildSocialButton(image, authBloc, type) {
    return Expanded(
      child: GestureDetector(
        onTap: () => {_loginSocial(authBloc, type)},
        child: new Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 15,
          decoration: new BoxDecoration(borderRadius: new BorderRadius.circular(30.0), border: Border.all(color: Color(0xFFa9a9a9))),
          child: Container(height: ScreenUtil().setSp(20), decoration: BoxDecoration(image: DecorationImage(image: image))),
        ),
      ),
    );
  }

  _loginSocial(authBloc, type) {
    if (type == SocialConnectionType.FACEBOOK) {
      _loginFacebook(authBloc);
    } else if (type == SocialConnectionType.GOOGLE) {
      _loginGoogle(authBloc);
    }
  }

  _loginGoogle(authBloc) async {
    try {
      // _googleSignIn.signInSilently();
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      setState(() {
        loading = true;
      });
      authBloc.loginSocial(SocialConnectionType.GOOGLE, googleUser.displayName, googleUser.email, googleUser.id, googleUser.photoUrl);
    } catch (error) {
      setState(() {
        loading = false;
      });
    }
  }

  _loginFacebook(authBloc) async {
    final facebookLogin = FacebookLogin();


    await facebookLogin.logOut();
    final result = await facebookLogin.logInWithReadPermissions(['email']);
//    print(result.accessToken.token);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        setState(() {
          loading = true;
        });
        var inforByFacebook = await authService.getInforFacebook(accessToken.token);
        authBloc.loginSocial(SocialConnectionType.FACEBOOK, inforByFacebook['name'].toString(), inforByFacebook['email'].toString().replaceAll('\u0040', '@'), inforByFacebook['id'], inforByFacebook['picture']['data']['url']);
        _showMessage('''
         Logged in!
   
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions} ''');

        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  void _showMessage(String message) {
    // setState(() {
    _message = message;
    print(message);
    // });
  }

  @override
  error(HttpError error) {
    setState(() {
      loading = false;
    });
    Reusable.showSnackBar(
      _scaffoldKey,
      error.message,
    );
  }

  @override
  success(user) {
    setState(() {
      loading = false;
    });
    BlocProvider.of<ApplicationBloc>(context).changeCurrentUser(user);
    BlocProvider.of<ApplicationBloc>(context).changeOrderCount(user.walletCount);

    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
    return null;
  }
}
