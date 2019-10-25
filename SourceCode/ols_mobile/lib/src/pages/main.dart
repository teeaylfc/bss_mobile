import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ols_mobile/src/blocs/application_bloc.dart';
import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/blocs/bottom_navbar_bloc.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/flutter_screenutil.dart';
import 'package:ols_mobile/src/common/util/localstorage.dart';
import 'package:ols_mobile/src/pages/booking-all.dart';
import 'package:ols_mobile/src/pages/booking_detail.dart';
import 'package:ols_mobile/src/pages/browser.dart';
import 'package:ols_mobile/src/pages/category_list.dart';
import 'package:ols_mobile/src/pages/home.dart';
import 'package:ols_mobile/src/pages/item_list.dart';
import 'package:ols_mobile/src/pages/notification_list.dart';
import 'package:ols_mobile/src/pages/profile.dart';
import 'package:ols_mobile/src/pages/sign_in.dart';
import 'package:ols_mobile/src/pages/stores_list_page.dart';
import 'package:ols_mobile/src/pages/wallet.dart';
import 'package:ols_mobile/src/service/auth_service.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:ols_mobile/src/style/styles.dart';
import 'package:ols_mobile/src/widgets/notification_popup.dart';

import 'booking.dart';

PageStorageKey mykey = new PageStorageKey("testkey");
final PageStorageBucket bucket = new PageStorageBucket();

final Widget _homePage = HomePage(key: PageStorageKey(NavBarItem.DISCOVER));
final Widget _browserPage =
BrowserPage(key: PageStorageKey(NavBarItem.BROWSER));
final Widget _walletPage = WalletPage(key: PageStorageKey(NavBarItem.WALLET));
final LocalStorage storage = new LocalStorage('cyw_app');
final _storage = new FlutterSecureStorage();

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'profile',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  AuthenticationState authStatus = AuthenticationState.notDetermined;
  DataService dataService = DataService();
  AuthService authService = AuthService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  ApplicationBloc applicationBloc;

  int walletCount;

  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    authStatus = applicationBloc.getAuthStatus.value
        ? AuthenticationState.signedIn
        : AuthenticationState.notSignedIn;

    applicationBloc.authenticationStatus.listen((data) {
      authStatus = applicationBloc.getAuthStatus.value
          ? AuthenticationState.signedIn
          : AuthenticationState.notSignedIn;
    });
    listenBloc();
    registerNotification();
    // configLocalNotification();

//    walletCount = BlocProvider.of<ApplicationBloc>(context).walletCount.value;
  }

  void registerNotification() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        printWrapped(
          '*******************************************' + message.toString(),
        );
        _showNotificationDialog(message);
        // showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationList(),
          ),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationList(),
          ),
        );
      },
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      print("token: $token");
      // save token to stogare
      _storage.write(key: Config.FIREBASE_TOKEN, value: token);
      if (authStatus == AuthenticationState.signedIn) {
        authService.registerDevice(token);
      }
    });
  }

  // void configLocalNotification() {
  //   var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
  //   var initializationSettingsIOS = new IOSInitializationSettings();
  //   var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  // void showNotification(message) async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //     'com.oe.oev.cyw',
  //     'Coupon You Want',
  //     '',
  //     playSound: true,
  //     enableVibration: true,
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //   );
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
  //       payload: json.encode(message));
  // }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  _showNotificationDialog(message) {
    if (message['badge'] != null) {
      var badge = int.parse(message['badge']);
      if (badge >= 0) {
        ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
        applicationBloc.changeNotificationBadgeValue(badge);
      }
    }
    String type;
    String title = '';
    if (Platform.isAndroid) {
      type = message['data']['type'];
      title = message['data']['title'];
    } else {
      type = message['type'];
      title = message['title'];
    }
    if (type != null) {
      if (type == NotificationType.OFFER) {
        containerForSheet<String>(
            context: context,
            message: message,
            child: MessagePopup(
              success: true,
              title1: title,
              title2: 'view detail',
              ogbjectId: 'NOTIFICATION',
            ));
      } else if (type == NotificationType.TRANSACTION) {
        containerForSheet<String>(
            context: context,
            message: message,
            child: MessagePopup(
              success: true,
              title1: title,
              title2: 'view detail',
              ogbjectId: 'NOTIFICATION',
            ));
      }
    }
  }

  void containerForSheet<T>({BuildContext context, message, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      if ('NOTIFICATION' == value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationList(),
          ),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    applicationBloc.orderCount.listen((wc) {
      setState(() {
        walletCount = wc;
        _buildBadgeWalletCount(wc);
      });
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void listenBloc(){
    pickItemBloc.pickItemStream.listen((data) {
      print('index tabbot: $data');
     if(data != null){
       pageController.animateToPage(
           data, duration: Duration(milliseconds: 500), curve: Curves.ease);
       setState(() {
         _tabIndex = data;
       });
     }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget _newPage = _homePage;
    return

      Scaffold(
        body:
        StreamBuilder(
            stream: pickItemBloc.pickItemStream,
            builder: (context, snapshot) {
              return PageView(
                // physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: (index) {
                  pageChanged(index);
                },
                children: [
                     authStatus == AuthenticationState.signedIn
                      ? _homePage
                      : SignInPage(),
                      authStatus == AuthenticationState.signedIn
                      ? _browserPage
                      : SignInPage(),
                  // authStatus == AuthenticationState.signedIn
                  //     ? _walletPage
                  //     : SignInPage(),
                     authStatus == AuthenticationState.signedIn
                      ? StoreListPage()
                      : SignInPage(),
                  authStatus == AuthenticationState.signedIn
                      ? ProfilePage()
                      : SignInPage(),
                ],
              );
            }
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
  }

  void pageChanged(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: _tabIndex,
      onTap: (index) {
        setState(() {
          _tabIndex = index;
        });
        pageController.animateToPage(
            index, duration: Duration(milliseconds: 500), curve: Curves.ease);
        print("_tabIndex: $_tabIndex");
      },
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/discover_ic.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            activeIcon: Image.asset(
              'assets/images/discover_ic_active.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            title: Text(
              FlutterI18n.translate(context, 'mainPage.home'),
              style: Styles.bottomBarTextStyle,
            )),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/search_ic.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            activeIcon: Image.asset(
              'assets/images/search_ic_active.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            title: Text(
              FlutterI18n.translate(context, 'mainPage.search'),
              style: Styles.bottomBarTextStyle,
            )),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/store_ic.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            activeIcon: Image.asset(
              'assets/images/store_ic_active.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            title: Text(
              FlutterI18n.translate(context, 'mainPage.store'),
              style: Styles.bottomBarTextStyle,
            )),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/profile_ic.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            activeIcon: Image.asset(
              'assets/images/profile_ic_active.png',
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
            ),
            title: Text(
              FlutterI18n.translate(context, 'mainPage.profile'),
              style: Styles.bottomBarTextStyle,
            )),
      ],
    );
  }

  Widget _buildBadgeWalletCount(wc) {
    if (authStatus == AuthenticationState.signedIn && wc != null && wc > 0) {
      return Positioned(
        right: 0,
        top: 0,
        child: new Container(
          padding: EdgeInsets.all(1),
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          constraints: BoxConstraints(
            minWidth: 14,
            minHeight: 14,
          ),
          child: new Text(
            wc.toString(),
            style: new TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(9),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Positioned(right: 0, top: 0, child: new Container());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}