library flutter_xlog_plugin;

import 'package:flutter/services.dart';

export 'src/m7log_utils.dart';

class M7log {
  static const MethodChannel _channel = MethodChannel('mlog');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}