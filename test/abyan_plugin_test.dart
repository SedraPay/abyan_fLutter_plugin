import 'package:flutter_test/flutter_test.dart';
import 'package:abyan_plugin/abyan_plugin.dart';
import 'package:abyan_plugin/abyan_plugin_platform_interface.dart';
import 'package:abyan_plugin/abyan_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAbyanPluginPlatform
    with MockPlatformInterfaceMixin
    implements AbyanPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AbyanPluginPlatform initialPlatform = AbyanPluginPlatform.instance;

  test('$MethodChannelAbyanPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAbyanPlugin>());
  });

  test('getPlatformVersion', () async {
    AbyanPlugin abyanPlugin = AbyanPlugin();
    MockAbyanPluginPlatform fakePlatform = MockAbyanPluginPlatform();
    AbyanPluginPlatform.instance = fakePlatform;

    expect(await abyanPlugin.getPlatformVersion(), '42');
  });
}
