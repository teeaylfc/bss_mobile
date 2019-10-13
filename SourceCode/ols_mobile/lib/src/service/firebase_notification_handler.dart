import 'dart:io';

import 'package:ols_mobile/src/common/exception/http_code.dart';
import 'package:ols_mobile/src/service/data_service.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';

class FirebaseNotifications {
  DataService dataService = DataService();
  EventBus eventBus = EventBus();
  FirebaseMessaging _firebaseMessaging;
  DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
  String osVersion;
  String deviceName;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
  }

  _getIosInfo() async {
    try {
      return await deviceInfo.iosInfo;
    } catch (err) {
      return null;
    }
  }

  _getAndroidInfo() async {
    try {
      return await deviceInfo.androidInfo;
    } catch (err) {
      return null;
    }
  }

  _registerDevice(token) async {
    return await dataService.registerDevice(Platform.operatingSystem, osVersion, token, deviceName);
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      IosDeviceInfo iosDeviceInfo;
      AndroidDeviceInfo androidDeviceInfo;

      // if (Platform.isIOS) {
      //   iosDeviceInfo = _getIosInfo();
      //   if (iosDeviceInfo != null) {
      //     osVersion = iosDeviceInfo.systemVersion;
      //     deviceName = iosDeviceInfo.name + iosDeviceInfo.model;
      //   }
      // } else if (Platform.isAndroid) {
      //   androidDeviceInfo = _getAndroidInfo();
      //   if (androidDeviceInfo != null) {
      //     osVersion = androidDeviceInfo.version.toString();
      //     deviceName = androidDeviceInfo.manufacturer + androidDeviceInfo.model;
      //   }
      // }

      // register device id
      print(token);

      final res = _registerDevice(token);
      print(res);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print('on message $message');
        print('on message ');

        eventBus.fire(NotificationEvent(message: message.toString()));
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

class NotificationEvent {
  String message;
  NotificationEvent({this.message});
}
