import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/pages/language_setting.dart';
import 'package:ols_mobile/src/pages/main.dart';
import 'package:ols_mobile/src/pages/profile_edit.dart';
import 'package:ols_mobile/src/pages/security_setting.dart';
import 'package:ols_mobile/src/pages/transaction_history.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';

class ProfileMenuPage extends StatefulWidget {
  ProfileMenuPage() {}

  @override
  State<StatefulWidget> createState() {
    return _ProfileMenuPageState();
  }
}

class _ProfileMenuPageState extends State<ProfileMenuPage> {
  ApplicationBloc applicationBloc;
  @override
  void initState() {
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        elevation: 0.7,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 25, 18, 0),
        child: ListView(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return ProfileEditPage();
                    },
                    fullscreenDialog: true));
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    color: CommonColor.textBlack,
                    size: 16,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Edit profile',
                    style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF9B9B9B),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setSp(25),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return TransactionHistoryPage();
                    },
                    fullscreenDialog: true));
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.history,
                    color: CommonColor.textBlack,
                    size: 16,
                  ),
                  SizedBox(
                    width: ScreenUtil().setSp(10),
                  ),
                  Text(
                    'Transaction history',
                    style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF9B9B9B),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setSp(25),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return SecuritySettingPage();
                    },
                    fullscreenDialog: true));
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.security,
                    color: CommonColor.textBlack,
                    size: 16,
                  ),
                  SizedBox(
                    width: ScreenUtil().setSp(10),
                  ),
                  Text(
                    'Security Setting',
                    style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF9B9B9B),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setSp(25),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return LanguageSettingPage();
                    },
                    fullscreenDialog: true));
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.language,
                    color: CommonColor.textBlack,
                    size: 16,
                  ),
                  SizedBox(
                    width: ScreenUtil().setSp(10),
                  ),
                  Text(
                    'Language Setting',
                    style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF9B9B9B),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setSp(25),
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.notifications,
                  color: CommonColor.textBlack,
                  size: 16,
                ),
                SizedBox(
                  width: ScreenUtil().setSp(10),
                ),
                Text(
                  'Notification Setting',
                  style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF9B9B9B),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setSp(25),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Privacy & data',
                  style: TextStyle(
                    color: CommonColor.textBlack,
                    fontSize: ScreenUtil().setSp(16),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF9B9B9B),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setSp(25),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Customer support',
                  style: TextStyle(
                    color: CommonColor.textBlack,
                    fontSize: ScreenUtil().setSp(16),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF9B9B9B),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setSp(25),
            ),
            Row(
              children: <Widget>[
                Text(
                  'FAQ',
                  style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(16)),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF9B9B9B),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Color(0xFFD6D6D6),
            blurRadius: 5.0,
          ),
        ]),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: _buildLogoutButton(context, applicationBloc),
        ),
      ),
    );
  }

  _buildLogoutButton(context, applicationBloc) {
    return RaisedGradientButton(
        child: Text(
          'Log out',
          style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600, fontSize: 16.0),
        ),
        color: Color(0xFFFB101B),
        height: ScreenUtil().setSp(40),
        onPressed: () {
          _logout();
        });
  }

  void _logout() async {
     applicationBloc.logout().then((data) {
      googleSignIn.disconnect();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );
    });
  }
}
