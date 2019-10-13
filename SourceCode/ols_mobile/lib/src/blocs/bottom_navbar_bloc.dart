import 'dart:async';

import 'package:ols_mobile/src/common/constants/constants.dart';

enum NavBarItem {
  DISCOVER,
  BROWSER,
  WALLET,
  STORE_LIST,
  PROFILE,
  ITEM_LIST,
  CATEGORY_LIST,
  BOOKING_LIST,
  BOOKING_DETAIL,
  BOOKING,
}

class BottomNavBarBloc {
  final StreamController<Map<NavBarItem, dynamic>> _navBarStreamController = StreamController<Map<NavBarItem, dynamic>>.broadcast();

  Map<NavBarItem, dynamic> defaultItem = {NavBarItem.DISCOVER: ''};

  Stream<Map<NavBarItem, dynamic>> get itemStream => _navBarStreamController.stream;

  void pickItem(int i, [object]) {
    switch (i) {
      case PageIndex.DISCOVER:
        _navBarStreamController.sink.add({NavBarItem.DISCOVER: ''});
        break;
      case PageIndex.BROWSER:
        _navBarStreamController.sink.add({NavBarItem.BROWSER: ''});
        break;
      case PageIndex.WALLET:
        _navBarStreamController.sink.add({NavBarItem.WALLET: ''});
        break;
      case PageIndex.STORE_LIST:
        _navBarStreamController.sink.add({NavBarItem.STORE_LIST: ''});
        break;
      case PageIndex.PROFILE:
        _navBarStreamController.sink.add({NavBarItem.PROFILE: ''});
        break;
      case PageIndex.COUPON_LIST:
        _navBarStreamController.sink.add({NavBarItem.ITEM_LIST: object});
        break;
      case PageIndex.CATEGORY_LIST:
        _navBarStreamController.sink.add({NavBarItem.CATEGORY_LIST: ''});
        break;
      case PageIndex.BOOKING_LIST:
        _navBarStreamController.sink.add({NavBarItem.BOOKING_LIST: object});
        break;
      case PageIndex.BOOKING_DETAIL:
        _navBarStreamController.sink.add({NavBarItem.BOOKING_DETAIL: object});
        break;
      case PageIndex.BOOKING:
        _navBarStreamController.sink.add({NavBarItem.BOOKING: object});
        break;
    }
  }

  close() {
    _navBarStreamController?.close();
  }
}

final bottomNavBarBloc = BottomNavBarBloc();
