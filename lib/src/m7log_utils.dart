import 'dart:io';

import 'package:flutter/services.dart';

class M7Log {
  M7Log._();

  static const MethodChannel _channel = const MethodChannel('com.qw.flutter.xlog.plugins/xlog');

  static bool _isAndroidPlatform = Platform.isAndroid;

  ///日志分割长度
  static const int _maxLen = 800;

  static String _tag = 'xlog_plugin';

  ///是否打印日志到控制台
  static bool _isConsolePrintLog = true;

  ///是否使用flutter print方法打印,否则就是使用native打印日志（仅针对android）
  static bool _isUseFlutterPrintMethodLog = true;

  ///xlog日志工具初始化
  ///日志保存到本地文件的前提是：Android平台+isUseFlutterPrintMethodLog为false；
  ///[tag] 日志tag
  ///[isConsolePrintLog] 控制台是否打印日志
  ///[isUseFlutterPrintMethodLog] 是否使用flutter print方法打印，否则就是使用native打印日志（仅针对android）
  ///[saveLogFilePath] log文件保存目录，仅android平台该字段才有效，为null，保存到内部存储路径下
  ///[encryptPubKey] 日志文件保存到本地，加密公钥，为空表示日志文件不加密
  static Future<void> init({
    required String tag,
    required bool isConsolePrintLog,
    required bool isUseFlutterPrintMethodLog,
    required String? saveLogFilePath,
    required String? encryptPubKey,
  }) async {
    _tag = tag;
    _isConsolePrintLog = isConsolePrintLog;

    ///非android平台，需要强制使用flutter print打印
    _isUseFlutterPrintMethodLog = (isUseFlutterPrintMethodLog) || !_isAndroidPlatform;

    if (!_isUseFlutterPrintMethodLog) {
      ///native打印日志：初始化native xlog库
      await _channel.invokeMethod('init', {
        'logTag': _tag,
        'isConsoleLogOpen': _isConsolePrintLog,
        'logPath': saveLogFilePath,
        'encryptPubKey': encryptPubKey,
      });
    }
  }

  static void v(String tag, String? msg) {
    if (_isConsolePrintLog) {
      if (_isUseFlutterPrintMethodLog) {
        _flutterPrint('v', '${_tag}_v: $tag', msg);
      } else {
        _invokeNativeMethodPrint('v', tag, msg);
      }
    } else if (_isAndroidPlatform && !_isUseFlutterPrintMethodLog) {
      _invokeNativeMethodPrint('v', tag, msg);
    }
  }

  static void d(String tag, String? msg) {
    if (_isConsolePrintLog) {
      if (_isUseFlutterPrintMethodLog) {
        _flutterPrint('d', '${_tag}_d: $tag', msg);
      } else {
        _invokeNativeMethodPrint('d', tag, msg);
      }
    } else if (_isAndroidPlatform && !_isUseFlutterPrintMethodLog) {
      _invokeNativeMethodPrint('d', tag, msg);
    }
  }

  static void i(String tag, String? msg) {
    if (_isConsolePrintLog) {
      if (_isUseFlutterPrintMethodLog) {
        _flutterPrint('i', '${_tag}_i: $tag', msg);
      } else {
        _invokeNativeMethodPrint('i', tag, msg);
      }
    } else if (_isAndroidPlatform && !_isUseFlutterPrintMethodLog) {
      _invokeNativeMethodPrint('i', tag, msg);
    }
  }

  static void w(String tag, String? msg) {
    if (_isConsolePrintLog) {
      if (_isUseFlutterPrintMethodLog) {
        _flutterPrint('w', '${_tag}_w: $tag', msg);
      } else {
        _invokeNativeMethodPrint('w', tag, msg);
      }
    } else if (_isAndroidPlatform && !_isUseFlutterPrintMethodLog) {
      _invokeNativeMethodPrint('w', tag, msg);
    }
  }

  static void e(String tag, String? msg) {
    if (_isConsolePrintLog) {
      if (_isUseFlutterPrintMethodLog) {
        _flutterPrint('e', '${_tag}_e $tag', msg);
      } else {
        _invokeNativeMethodPrint('e', tag, msg);
      }
    } else if (_isAndroidPlatform && !_isUseFlutterPrintMethodLog) {
      _invokeNativeMethodPrint('e', tag, msg);
    }
  }

  ///native打印日志（并保存到文件）
  static Future<void> _invokeNativeMethodPrint(String level, String tag, String? msg) async {
    await _channel.invokeMethod('log', {'level': level, 'tag': tag, 'msg': msg});
  }

  ///flutter打印日志
  static void _flutterPrint(String method, String? tag, String? log) {
    String msg = log?.toString() ?? '_flutterPrint log is null';
    if (msg.length <= _maxLen) {
      print('$tag: $msg');
    } else {
      print('$tag ======================== log start ================================');
      while (msg.isNotEmpty) {
        if (msg.length > _maxLen) {
          print('${msg.substring(0, _maxLen)}');
          msg = msg.substring(_maxLen, msg.length);
        } else {
          print('$msg');
          msg = '';
        }
      }
      print('$tag ======================== log end ================================');
    }
  }

  static Future<void> dispose() async {
    await _channel.invokeMethod('onDestroy');
  }
}
