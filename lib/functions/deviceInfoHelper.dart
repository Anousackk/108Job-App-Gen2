import 'dart:io';

import 'package:apple_product_name/apple_product_name.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  final String modelName;
  final String modelVersion;

  DeviceInfo({required this.modelName, required this.modelVersion});
}

class DeviceInfoHelper {
  static Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      print('Device IOS name: ${iosInfo.utsname.productName}');
      print(
          'Device IOS version: ${iosInfo.systemName} ${iosInfo.systemVersion}');

      return DeviceInfo(
        modelName: iosInfo.utsname.productName.toString(),
        modelVersion: '${iosInfo.systemName} ${iosInfo.systemVersion}',
      );
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;

      print('Device Android name: ${androidInfo.brand} ${androidInfo.model}');
      print('Device Android version: ${androidInfo.version.release}');
      return DeviceInfo(
        modelName: '${androidInfo.brand} ${androidInfo.model}',
        modelVersion: androidInfo.version.release.toString(),
      );
    }

    return DeviceInfo(modelName: '', modelVersion: '');
  }
}
