import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LocalAuthenticationService {
  final _auth = LocalAuthentication();

  bool isAuthenticated = false;

  Future<bool> authenticate() async {
    try {
      isAuthenticated = await _auth.authenticateWithBiometrics(
        localizedReason: 'Please scan your fingerprintp !',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      return isAuthenticated;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}