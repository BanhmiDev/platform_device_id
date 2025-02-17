import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:platform_device_id_platform_interface/platform_device_id_platform_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:android_id/android_id.dart';

/// Provides device id information.
class PlatformDeviceId {
  /// Provides device and operating system information.
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  /// Information derived from `android`-`androidId` or `ios`-`identifierForVendor`
  static Future<String?> get getDeviceId async {
    String? deviceId;
    try {
      if (kIsWeb) {
        deviceId = await PlatformDeviceIdPlatform.instance.getDeviceId();
      } else if (Platform.isAndroid) {
        String? androidId;
        try {
          const _androidIdPlugin = AndroidId();
          androidId = await _androidIdPlugin.getId();
        } catch (e) {
          // Fallback
          AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
          androidId = androidInfo.id;
        }
        deviceId = androidId;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else {
        deviceId = await PlatformDeviceIdPlatform.instance.getDeviceId();
      }
    } on PlatformException {
      deviceId = '';
    }
    return deviceId;
  }
}
