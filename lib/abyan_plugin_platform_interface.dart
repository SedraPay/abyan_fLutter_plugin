import 'package:abyan_plugin/models/products.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'abyan_plugin_method_channel.dart';

abstract class AbyanPluginPlatform extends PlatformInterface {
  /// Constructs a SomePluginPlatform.
  AbyanPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static AbyanPluginPlatform _instance = MethodChannelAbyanPlugin();

  /// The default instance of [AbyanPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelAbyanFlutter].
  static AbyanPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AbyanPluginPlatform] when
  /// they register themselves.
  static set instance(AbyanPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> createJourney(String journeyType) {
    throw UnimplementedError('createJourney() has not been implemented.');
  }

  Future<List<Product>> fetchProducts() {
    throw UnimplementedError('fetchProducts() has not been implemented.');
  }

  Future<String> sendFormDataRequest(int productId) {
    throw UnimplementedError(
        'sendFormDataRequestToiOS() has not been implemented.');
  }

  Future<String> callScanDocument(int documentType) {
    throw UnimplementedError('callScanCardID() has not been implemented.');
  }

  Future<String> scanYourFaceID() {
    throw UnimplementedError('scanYourFaceID() has not been implemented.');
  }

  Future<String> closeJourney(String customerID) {
    throw UnimplementedError('closeJourney() has not been implemented.');
  }
  Future<void> getKYC() {
    throw UnimplementedError('getKYC() has not been implemented.');
  }
  Future<void> updateKYC(String kycField) {
    throw UnimplementedError('updateKYC() has not been implemented.');
  }
}
