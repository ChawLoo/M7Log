import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mlog/m7_log.dart';

void main() {
  const MethodChannel channel = MethodChannel('mlog');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await M7log.platformVersion, '42');
  });
}
