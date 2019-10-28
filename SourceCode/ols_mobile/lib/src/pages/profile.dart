import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/models/account_info_model.dart';
import 'package:ols_mobile/src/models/booking_model.dart';
import 'package:ols_mobile/src/models/list_item_model.dart';
import 'package:ols_mobile/src/models/user_modal.dart';
import 'package:ols_mobile/src/pages/about_mbf.dart';
import 'package:ols_mobile/src/pages/account_link.dart';
import 'package:ols_mobile/src/pages/ask_question.dart';
import 'package:ols_mobile/src/pages/bankCard_link.dart';
import 'package:ols_mobile/src/pages/language_setting.dart';
import 'package:ols_mobile/src/pages/main.dart';
import 'package:ols_mobile/src/pages/member_code.dart';
import 'package:ols_mobile/src/pages/profile_edit.dart';
import 'package:ols_mobile/src/pages/security_setting.dart';
import 'package:ols_mobile/src/pages/send_feedback.dart';
import 'package:ols_mobile/src/pages/sign_in.dart';
import 'package:ols_mobile/src/pages/support_center.dart';
import 'package:ols_mobile/src/pages/term_condition.dart';
import 'package:ols_mobile/src/pages/transaction_history.dart';
import 'package:ols_mobile/src/pages/wallet_balance.dart';
import 'package:ols_mobile/src/service/auth_service.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/service/stellar_data_service.dart';
import 'package:ols_mobile/src/style/color.dart';
import 'package:ols_mobile/src/widgets/m_point.dart';
import 'package:ols_mobile/src/widgets/raised_gradient_button.dart';
import 'package:ols_mobile/src/widgets/reusable.dart';

import 'notification_list.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final _storage = new FlutterSecureStorage();
  
  final formatCurrency = NumberFormat.compactCurrency(symbol: '');
  AuthService _authService = AuthService();

  DataService dataService = DataService();
  StellarDataService stellarDataService = StellarDataService();

  ApplicationBloc applicationBloc;
  User currentUser;

  int notificationBadge;

  bool isLoadingBalance = false;
  String balance;
  bool isGettingLocation = false;
  String csn;

  int unReadNotificationCount;

  var connectivityResult;

  BookingList bookingList;
  Future<ListItem> listFavorites;
  String currentName;
  var imageUrl;

  @override
  void initState() {
    super.initState();
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    currentUser = applicationBloc.currentUserValue.value;
    if (currentUser == null) {
      //  bottomNavBarBloc.pickItem(4);
    } else {
      imageUrl = currentUser.getImageUrl();
      currentName = currentUser.fullName;
    }
  }
  @override
  Widget build(BuildContext context) {
    ContextProfile.context = context;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ClipPath(
                clipper: ClippingHeader(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: ScreenUtil().setSp(385),
                  decoration: BoxDecoration(
                    gradient: CommonColor.leftRightLinearGradient,
                      // borderRadius: BorderRadius.vertical(
                      //     bottom: Radius.elliptical(
                      //         MediaQuery.of(context).size.width, 160))
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil().setSp(65),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : AssetImage('assets/images/blank_profile.png')
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(76, 76, 0, 0),
                            width: ScreenUtil().setSp(22),
                            height: ScreenUtil().setSp(22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Container(
                              height: ScreenUtil().setSp(17),
                              child: Image.asset("assets/images/loyalty/vip_icon.png")
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setSp(13),
                      ),
                      Container(
                        height: ScreenUtil().setSp(20),
                        child: Text(currentName ?? "",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(20)
                        )

                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setSp(10),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setSp(155)),
                        child: MPoint(
                            iconSize: ScreenUtil().setSp(19),
                            fontSize: ScreenUtil().setSp(16),
                            background: false,
                            textColor: Colors.white,
                            point: balance ?? "0",
                          ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setSp(35),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _buildItemHeader("assets/images/loyalty/wallet_icon.png", FlutterI18n.translate(context, 'profilePage.balance') ,
                                  (){
                                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                                        builder: (BuildContext context) {
                                          return WalletBalance();
                                        },
                                        fullscreenDialog: true));
                                  }),
                          SizedBox(
                            width: ScreenUtil().setSp(44),
                          ),
                          _buildItemHeader("assets/images/loyalty/member_code_icon.png", FlutterI18n.translate(context, 'profilePage.memberCode') ,
                                  (){
                                    // Navigator.of(context).push(new MaterialPageRoute<Null>(
                                    //     builder: (BuildContext context) {
                                    //       return MemberCodePage();
                                    //     },
                                    //     fullscreenDialog: true));
                                  }),
                          SizedBox(
                            width: ScreenUtil().setSp(44),
                          ),
                          _buildItemHeader("assets/images/loyalty/card_icon.png", FlutterI18n.translate(context, 'profilePage.cardLinked'),
                                  (){
                                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                                        builder: (BuildContext context) {
                                          return BankCardLink();
                                        },
                                        fullscreenDialog: true));
                                  } ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setSp(20),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async{
                  String s = await _storage.read(key: Config.USER_ID);
                   print(s);
                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return ProfileEditPage();
                      },
                      fullscreenDialog: true)).then((data){
                        currentUser = applicationBloc.currentUserValue.value;
                        setState(() {
                         imageUrl = currentUser.imageURL; 
                        });
                      });
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(19), ScreenUtil().setSp(0), ScreenUtil().setSp(10), ScreenUtil().setSp(0)),
                  height: ScreenUtil().setSp(50),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.black,
                        size: ScreenUtil().setSp(20),
                      ),
                      SizedBox(
                       width: ScreenUtil().setSp(10),
                      ),
                      Text(
                        FlutterI18n.translate(context, 'profilePage.updateAccount'),
                        style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: ScreenUtil().setSp(16),
                        color: Color(0xFF9B9B9B),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setSp(1),
                color: Color(0xffF0F0F0),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return AccountLink();
                      },
                      fullscreenDialog: true));
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(19), ScreenUtil().setSp(0), ScreenUtil().setSp(10), ScreenUtil().setSp(0)),
                  height: ScreenUtil().setSp(50),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setSp(16),
                          child: Image.asset("assets/images/loyalty/link_icon.png")),
                      SizedBox(
                       width: ScreenUtil().setSp(10),
                      ),
                      Text(
                        FlutterI18n.translate(context, 'profilePage.accountLinked'),
                        style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: ScreenUtil().setSp(16),
                        color: Color(0xFF9B9B9B),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setSp(1),
                color: Color(0xffF0F0F0),
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
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(19), ScreenUtil().setSp(0), ScreenUtil().setSp(10), ScreenUtil().setSp(0)),
                  height: ScreenUtil().setSp(50),
                  child: Row(
                    children: <Widget>[
                      Container(
                          height: ScreenUtil().setSp(16),
                          child: Image.asset("assets/images/loyalty/history_icon.png")),
                      SizedBox(
                       width: ScreenUtil().setSp(10),
                      ),
                      Text(
                        FlutterI18n.translate(context, 'profilePage.transaction'),
                        style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: ScreenUtil().setSp(16),
                        color: Color(0xFF9B9B9B),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setSp(1),
                color: Color(0xffF0F0F0),
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
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(19), ScreenUtil().setSp(0), ScreenUtil().setSp(10), ScreenUtil().setSp(0)),
                  height: ScreenUtil().setSp(50),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: ScreenUtil().setSp(18),
                      ),
                      SizedBox(
                       width: ScreenUtil().setSp(10),
                      ),
                      Text(
                        FlutterI18n.translate(context, 'profilePage.setting'),
                        style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: ScreenUtil().setSp(16),
                        color: Color(0xFF9B9B9B),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setSp(7),
              ),
              Container(
                height: ScreenUtil().setSp(7),
                color: Color(0xffF0F0F0),
              ),
              _buildItemFAQ(FlutterI18n.translate(context, 'supportCenter.aboutMbf'),
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return AboutMbf();
                        },
                        fullscreenDialog: true));
                  }
              ),
              _buildItemFAQ(FlutterI18n.translate(context, 'supportCenter.tac'),
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return TermCondition();
                        },
                        fullscreenDialog: true));
                  }
              ),
              _buildItemFAQ(FlutterI18n.translate(context, 'supportCenter.faq'),
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return AskQuestion();
                        },
                        fullscreenDialog: true));
                  }
              ),
              _buildItemFAQ(FlutterI18n.translate(context, 'supportCenter.sendFeedback'),
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return SendFeedBack();
                  },
                        fullscreenDialog: true));
                  }
              ),
              SizedBox(
                height: ScreenUtil().setSp(7),
              ),
              Container(
                height: ScreenUtil().setSp(7),
                color: Color(0xffF0F0F0),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async{
                  _logout();
                   String s = await _storage.read(key: Config.TOKEN_KEY);
                   print(s);
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(19), ScreenUtil().setSp(0), ScreenUtil().setSp(10), ScreenUtil().setSp(0)),
                  height: ScreenUtil().setSp(40),
                  child: Row(
                    children: <Widget>[
                      Container(
                          height: ScreenUtil().setSp(16),
                          child: Image.asset("assets/images/loyalty/logout_icon.png")),
                      SizedBox(
                       width: ScreenUtil().setSp(10),
                      ),
                      Text(
                        FlutterI18n.translate(context, 'profilePage.logout'),
                        style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setSp(10),
              ),
            ],
          ),
        ));
  }

  Widget _buildItemFAQ(text, {onTap}){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(20), ScreenUtil().setSp(0), ScreenUtil().setSp(10), ScreenUtil().setSp(0)),
        height: ScreenUtil().setSp(40),
        child: Row(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(color: CommonColor.textBlack, fontSize: ScreenUtil().setSp(13)),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Color(0xFF9B9B9B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(context) {
    return RaisedGradientButton(
        width: ScreenUtil().setSp(345),
        height: ScreenUtil().setSp(44),
        child: Text(
          FlutterI18n.translate(context, 'profilePage.logout'),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(16)),
        ),
        gradient: CommonColor.commonButtonColor,
        onPressed: () {
          _logout();
        });
  }

  Widget _buildItemHeader(image,text, Function onTap){
    return Column(
      children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setSp(10)),
              height: ScreenUtil().setSp(63),
              width: ScreenUtil().setSp(63),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100)
              ) ,
              child: Image.asset(image),
            ),
          ),
        SizedBox(
          height: ScreenUtil().setSp(10),
        ),
        Text(text,style: TextStyle(
          fontSize: ScreenUtil().setSp(12),
          color: Colors.white
        ),)
      ],
    );
  }

  void _logout() async {
    applicationBloc.changeOrderCount(0);
    applicationBloc.logout().then((data) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
        (Route<dynamic> route) => false,
      );
    });
  }
}


class ClippingHeader extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height-40);
    path.quadraticBezierTo(size.width / 4, size.height,
        size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}