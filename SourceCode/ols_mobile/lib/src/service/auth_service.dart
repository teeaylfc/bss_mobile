import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ols_mobile/src/common/constants/constants.dart';
import 'package:ols_mobile/src/common/http_client.dart';
import 'package:ols_mobile/src/models/account_info_model.dart';
import 'package:ols_mobile/src/service/data_service.dart';

class AuthService {
  final String _endpoint = apiUrl;
  final String _loginUrl = baseApiUrl;
  final String _cywEndpoint = cywApiUrl;
  final String _mbfEndpoint = mbfApiUrl;
  final String _baseApiBss = baseApiBss;

  DataService dataService = DataService();

  final _storage = new FlutterSecureStorage();

  Future<dynamic> login(username, password) async {
    try {
      var body =  {
        'username': username,
        'password': password,
      };
      var rs = await httpManager.post(_baseApiBss + 'users/login',body);
      var response = rs['data'];
      await _storage.write(key: Config.TOKEN_KEY, value: response['idToken']);
      AccountInfo accountInfo = AccountInfo.fromJson(response["accountInfo"]);
        await _storage.write(key: Config.USER_ID, value: accountInfo.id.toString());
      _saveUserDetailsToPreference(accountInfo);
      return accountInfo;
    } on DioError catch (error) {
      if (error.response != null) {
        throw Exception(error.response.data['message']);
      } else {
        throw Exception(error.toString());
      }
    }
  }

  Future<dynamic> loginSocial(provider, name, email, userId, imageUrl) async {
    try {
      final dataJson = {'displayName': name, 'email': email, 'providerId': provider, 'providerUserId': userId, 'imageURL': imageUrl};
      var response = await httpManager.post(_loginUrl + 'social/login/$distributorId', dataJson);
      _saveUserDetailsToPreference(response);
      return response;
    } on DioError catch (error) {
      if (error.response != null) {
        throw Exception(error.response.data['message']);
      } else {
        throw Exception(error.toString());
      }
    }
  }

  Future<dynamic> getInforFacebook(token) async {
    final response = await httpManager.get(
        "https://graph.facebook.com/v2.12/me?fields=picture.width(100).height(100),name,first_name,last_name,email&access_token=${token}", null);
    final profile = json.decode(response);
//    print(profile['name']);
    return profile;
  }

  Future<dynamic> connectSocial(provider, name, email, userId, imageUrl) async {
    final dataJson = {'displayName': name, 'email': email, 'providerId': provider, 'providerUserId': userId, 'imageURL': imageUrl};
    var response = await httpManager.post(_loginUrl + 'social/connect/$distributorId', dataJson);
    return response['data'];
  }

  Future<dynamic> disconnectSocial(provider) async {
    var response = await httpManager.get(_loginUrl + 'social/disconnect/$provider', null);
    return response['data'];
  }

  Future<dynamic> register(username, fullName, password) async {
    try {
      final dataJson = {"username": username, "fullName": fullName, "password": password};
      print(dataJson);
      final response = await httpManager.post('$_mbfEndpoint/register', dataJson);
      // _saveUserDetailsToPreference(response);

      return response;
    } on DioError catch (error) {
      print(error.toString());

      if (error.response != null) {
        throw Exception(error.response.data['message']);
      } else {
        throw Exception(error.toString());
      }
    }
  }

  Future<AccountInfo> getAccountInfo() async {
    final response = await httpManager.get('$baseApiBss'+'users/info', null);
    return AccountInfo.fromJson(response["data"]["accountInfo"]);
  }

  Future<AccountInfo> updateAccountInfo(fullName, phone, gender, countryCode) async {
    final accountInfo = {"fullName": fullName, "phone": phone, 'gender': gender, 'birthday': null, 'countryCode': countryCode};
    final body = {
      'accountInfo': accountInfo,
    };
    final response = await httpManager.put('$_endpoint/customer/account_info/$distributorId', body);
    return AccountInfo.fromJson(response['data']['accountInfo']);
  }

  Future<dynamic> biometricRegister(deviceId) async {
    try {
      var response = await httpManager.put(_cywEndpoint + '/customer/biometric/$deviceId', null);
      await _storage.write(key: Config.BIOMETRIC_CLIENT_SECRET, value: response['data']);
      return response;
    } on DioError catch (error) {
      print(error.toString());

      if (error.response != null) {
        throw Exception(error.response.data['message']);
      } else {
        throw Exception(error.toString());
      }
    }
  }

  Future<dynamic> biometricUnRegister() async {
    try {
      var response = await httpManager.put(_cywEndpoint + '/customer/biometric/delete', null);
      return response;
    } on DioError catch (error) {
      print(error.toString());

      if (error.response != null) {
        throw Exception(error.response.data['message']);
      } else {
        throw Exception(error.toString());
      }
    }
  }

  Future<dynamic> biometricAuthenticate(username, biometricClientSecret) async {
    try {
      var response =
          await httpManager.post(_endpoint + '/customer/biometric-authenticate', {'username': username, 'biometricClientSecret': biometricClientSecret});
      // _saveUserDetailsToPreference(response);
      return response;
    } on DioError catch (error) {
      if (error.response != null) {
        throw Exception(error.response.data['message']);
      } else {
        throw Exception(error.toString());
      }
    }
  }

  _saveUserDetailsToPreference(AccountInfo res) async {
    await _storage.write(key: Config.USER_FULLNAME, value: res.fullName);
    await _storage.write(key: Config.USER_EMAIL, value: res.email);

    // if (res['data']['biometricClientSecret'] != null) {
    //   await _storage.write(key: Config.BIOMETRIC_CLIENT_SECRET, value: res['data']['biometricClientSecret']);
    // }
    // await _storage.write(key: Config.USER_FULLNAME, value: res['data']['accountInfo']['fullName']);
    // await _storage.write(key: Config.USER_EMAIL, value: res['data']['accountInfo']['email']);
    // if (res['data']['accountInfo']['image'] != null) {
    //   await _storage.write(key: Config.IMAGE_URL, value: fileApiUrl + res['data']['accountInfo']['image'].toString());
    // } else {
    //   await _storage.write(key: Config.IMAGE_URL, value: res['data']['accountInfo']['imageURL']);
    // }
    // registerDevice(null);
  }

  registerDevice(token) async {
    if (token == null) {
      token = await _storage.read(key: Config.FIREBASE_TOKEN);
    }
    if (token != null) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      String deviceName = '';
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine;
      }

      return await dataService.registerDevice(Platform.operatingSystem, Platform.operatingSystemVersion, token, deviceName);
    }
  }
}
