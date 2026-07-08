import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceLockAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (_) {
      return false;
    }
  }

  Future<bool?> authenticateWithDeviceLock() async {
    try {
      final available = await _auth.getAvailableBiometrics();
      print("Available biometrics: $available");

      // ✅ local_auth v3 — authenticate() takes only localizedReason
      final result = await _auth.authenticate(
        localizedReason: 'Unlock app to continue',
      );
      return result;
    } on PlatformException catch (e) {
      print("BiometricService error: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("BiometricService unknown error: $e");
      return null;
    }
  }
}