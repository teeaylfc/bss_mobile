//General constants

// LOCAL DEV
// const String apiUrl = 'http://192.168.99.134:8090/api/mobile/v2.0';
// const String cywApiUrl = 'http://192.168.99.134:8090/api/mobile/cyw';
// const String fileApiUrl = 'http://192.168.99.134:8090/api/files/';
// const String fileApiUpload = 'http://192.168.99.134:8090/api/files';
// const String baseApiUrl = 'http://192.168.99.134:8090/';
//
// LOCAL SERVER
 const String apiUrl = 'http://192.168.99.21:9090/api/mobile/v2.0';
 const String cywApiUrl = 'http://192.168.99.21:9090/api/mobile/cyw';
 const String fileApiUrl = 'http://192.168.99.21:9090/api/files/';
 const String fileApiUpload = 'http://192.168.99.21:9090/api/files';
 const String baseApiUrl = 'http://192.168.99.21:9090/';
 const String baseApiBss = 'http://vuonxa.com:9090/';

// PUBLIC SERVER
//import 'package:flutter/material.dart';
//
//const String apiUrl = 'http://118.70.177.14:9090/api/mobile/v2.0';
//const String cywApiUrl = 'http://118.70.177.14:9090/api/mobile/cyw';
//const String fileApiUrl = 'http://118.70.177.14:9090/api/files/';
//const String fileApiUpload = 'http://118.70.177.14:9090/api/files';
//const String baseApiUrl = 'http://118.70.177.14:9090/';

const String mbfApiUrl = 'http://192.168.99.11:8080/portal-backend/api';

const int distributorId = 1126;

const String CYW_DOLLAR = 'UM\$';

class Config {
  static const CONNECTION_TIMEOUT = 5000;

  static const PAGE_SIZE = 20;
  static const DEBUG = false;
  static const USE_NATIVE_WEBVIEW = true;

  static const BIOMETRIC_CLIENT_SECRET = "biometric-client-secret";

  static const TOKEN_KEY = "jwt-token";
  static const USER_ID = "id";


  static const USER_INFO = "user-info";
  static const USER_FULLNAME = "user-fullname";
  static const IMAGE_URL = "image-url";
  static const IMAGE = "image";
  static const FIREBASE_TOKEN = "firebase-token";
  static const CSN = "csn";

  static const USER_EMAIL = "user-email";
  static const LIST_ORDER = "list-order";
  static const WALLET_COUNT = "wallet-count";

  static const COUPON_EXPRIED = "E";
  static const COUPON_ACTIVED = "A";

  static const FADEIN_DURATION = 300;
}

enum QRCODE_TYPE { POS_ID, RECEIPT }

class QRCODE_RECEIPT_TYPE {
  static const PAY_AT_COUNTER_OFFLINE = "|0";
  static const PAY_AT_TABLE_CHECK = "|1";
  static const PAY_AT_TABLE_OFFLINE = "|2";
}

enum ConfirmAction { CANCEL, ACCEPT }

class CouponStatus {
  static const ACTIVE = "A";
  static const SELECTED = "S";
  static const EXPIRED = "E";
}
class TransactionStatus{
  static const GIFTHISTORY = "GH";
  static const POINTHISTORY = "PH";
}
class TabWallet {
  static const MY_REWARD = "0";
  static const MY_FAVORITE_ITEM = "1";

  static const INUSE_TEXT = "In use";
  static const EXPIRED_TEXT = "Expired";
  static const OUT_OF_STOC = "Out of stock";
}

class BookingStatus {
  static const WAITING_FOR_CONFIRMATION = "C";
  static const CONFIRMED = "A";
  static const CONSUMER_CANCEL = "X";
  static const EXPIRED = "E";

  static const BOOKING_UP_COMING = "A";
  static const HISTORY = "E";
}

class CouponType {
  static const BASICOFAWARD_FC = 'FC';
  static const BASICOFAWARD_ELP = 'ELP';
  static const BASICOFAWARD_BSR = 'BSR';
  static const BASICOFAWARD_NS = 'NS';
  static const ITEM_REDUCE_PRICE = 'R';
  static const KEY_PREPAID_COUPONS = 'PP';
  static const ITEM_WALLETS_SELECTED = 'S';
}

class PageIndex {
  static const DISCOVER = 0;
  static const BROWSER = 1;
  static const WALLET = 2;
  static const STORE_LIST = 3;

  static const PROFILE = 4;
  static const COUPON_LIST = 5;
  static const CATEGORY_LIST = 6;
  static const BOOKING_LIST = 7;
  static const BOOKING_DETAIL = 8;
  static const BOOKING = 9;
}

class NotificationStatus {
  static const Y = 'Y';
  static const N = 'N';
}

class NotificationType {
  static const TRANSACTION = 'transaction';
  static const OFFER = 'O';
}

class LanguageSetting {
  static const LANGUAGE_PATH = 'resources/langs';
  static const LANGUAGE = "language";
  static const LANGUAGE_VI = "vi";
  static const LANGUAGE_EN = "en";
}

class AppEvent {
  static const RELOAD_WALLET = 'RELOAD_WALLET';
  static const SCROLL_HOME = 'SCROLL_HOME';
  static const SCROLL_BROWSER = 'SCROLL_BROWSER';
}

class Page {
  static const WALLET = 'WALLET';
  static const REWARD = 'REWARD';
}

class SocialConnectionType {
  static const FACEBOOK = 'facebook';
  static const GOOGLE = 'google';
}
class TypeAddress {
  static const CITY = 'city';
  static const DISTRICT = 'district';
}
class ContextProfile {
  static var context;
}
class ChangeAmount {
  static const PLUS = 'plus';
  static const MINUS = 'minus';
}
class TypeStore {
  static const ALL_STORE = 'ALL_STORE';
  static const FAVORITE_STORE = 'FAVORITE_STORE';
}

class DisplayType {
  static const GRID = 'GRID';
  static const BIG_CARD = 'BIG_CARD';
}