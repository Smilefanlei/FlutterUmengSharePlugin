import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mryt_share_plugin/mryt_share_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('mryt_share_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await MrytSharePlugin.platformVersion, '42');
  });
}
