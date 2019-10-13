import 'dart:async';
import 'dart:convert';

import 'package:ols_mobile/src/blocs/bloc_provider.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/models/item_model.dart';
import 'package:ols_mobile/src/models/user_modal.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';

enum AuthenticationState {
  notDetermined,
  notSignedIn,
  signedIn,
}

class ApplicationBloc extends BlocBase {
  final _storage = new FlutterSecureStorage();

  DataService dataService = DataService();
  StreamController _listBankCardController = new StreamController.broadcast();
  final _currentUserController = BehaviorSubject<User>();
  final _orderCount = BehaviorSubject<int>();
  final _authenticationStatusController = BehaviorSubject<bool>();
  final _notificationBadgeController = BehaviorSubject<int>();
  final _currentLanguageController = BehaviorSubject<String>();
  final _notifyEventController = BehaviorSubject<String>();

  //streams
  Stream get listBankcardStream => _listBankCardController.stream;

  Stream<User> get currentUser => _currentUserController.stream;

  Stream<int> get orderCountStream => _orderCount.stream;

  Stream<bool> get authenticationStatus => _authenticationStatusController.stream;

  Stream<String> get notifyEvent => _notifyEventController.stream;

  ValueObservable get getAuthStatus => _authenticationStatusController.stream;

  ValueObservable get orderCount => _orderCount.stream;

  ValueObservable get currentUserValue => _currentUserController.stream;

  ValueObservable get notificationBadgeValue => _notificationBadgeController.stream;

  ValueObservable get currentLanguageValue => _currentLanguageController.stream;

  //sinks
  Function(User) get changeCurrentUser => (user) => _currentUserController.sink.add(user);

//  changeCurrent (user){
//    return _currentLanguageController.sink.add(user);
//  }
  Function(int) get changeOrderCount => (count) => _orderCount.sink.add(count);

  Function(bool) get changeAuthenticationStatus => (val) => _authenticationStatusController.sink.add(val);

  Function(int) get changeNotificationBadgeValue => (val) => _notificationBadgeController.sink.add(val);

  Function(String) get changeCurrentLanguageValue => (val) => _currentLanguageController.sink.add(val);

  Function(String) get changeNotifyEventValue => (val) => _notifyEventController.sink.add(val);

  Function get addBankCardLink => (val) => _listBankCardController.sink.add(val);

  ApplicationBloc() {
    getCurrentLanguage();
    _authenticationStatusController.sink.add(false);
    getCurrentUser();
    _currentUserController.stream.listen((user) {
      if (user != null) {
        print('Login: ' + user.username + DateTime.now().toString());
        _authenticationStatusController.sink.add(true);
      }
    });
  }

  getCurrentUser() async {
    String token = await _storage.read(key: Config.TOKEN_KEY);
    String userFullname = await _storage.read(key: Config.USER_FULLNAME);
    String email = await _storage.read(key: Config.USER_EMAIL);
    String imageURL = await _storage.read(key: Config.IMAGE_URL);
//    print('2222');
    if (token != null) {
      _authenticationStatusController.sink.add(true);
      getOrderCount();
      changeCurrentUser(User(username: email, fullName: userFullname, imageURL: imageURL));
    } else {
      getLocalOrderCount();
    }
  }

  Future<bool> logout() async {
    // call api delete firebase token
    var firebasetoken = await _storage.read(key: Config.FIREBASE_TOKEN);
    if (firebasetoken != null) {
      dataService.deleteDevice(firebasetoken).then((data) {
        _clearUserData();
        return true;
      }).catchError((error) {
        _clearUserData();
        return true;
      });
    } else {
      _clearUserData();
      return true;
    }
  }

  getLocalOrderCount() async {
    var listOrderLocal = await _storage.read(key: Config.LIST_ORDER);
    if (listOrderLocal == null) {
      changeOrderCount(0);
    } else {
      int count = 0;
      List<Item> orders = OrderList.fromJson(jsonDecode(listOrderLocal)).items;
      orders.forEach((item) {
        count = count + item.quantity;
      });
      print("count: $count");
      changeOrderCount(count);
    }
  }

  getOrderCount() {
    dataService.getListCart().then((data) {
      if (data.items != null && data.items.length > 0) {
        int count = 0;
        data.items.forEach((obj) {
          count = count + obj.quantity;
        });
        changeOrderCount(count);
      } else {
        changeOrderCount(0);
      }
    });
  }

  _clearUserData() async {
    _authenticationStatusController.sink.add(false);
    changeCurrentUser(null);
    changeOrderCount(null);
    await _storage.delete(key: Config.TOKEN_KEY);
    await _storage.delete(key: Config.USER_EMAIL);
    await _storage.delete(key: Config.USER_FULLNAME);
    await _storage.delete(key: Config.USER_INFO);
    await _storage.delete(key: Config.IMAGE_URL);
    await _storage.delete(key: Config.FIREBASE_TOKEN);
    await _storage.delete(key: Config.LIST_ORDER);
    await _storage.delete(key: Config.CSN);
  }

  getCurrentLanguage() async {
    String language = await _storage.read(key: LanguageSetting.LANGUAGE);
    if (language == null) {
      language = LanguageSetting.LANGUAGE_EN;
    }
    changeLanguage(language);
  }

  changeLanguage(val) async {
    _currentLanguageController.sink.add(val);
    await _storage.write(key: LanguageSetting.LANGUAGE, value: val);
  }

  @override
  void dispose() {
    _currentUserController.close();
    _authenticationStatusController.close();
    _orderCount.close();
    _notificationBadgeController.close();
    _currentLanguageController.close();
    _notifyEventController.close();
    _listBankCardController.close();
  }
}
