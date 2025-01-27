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

  Future<void> createJourney(String journeyType) {
    throw UnimplementedError('createJourney() has not been implemented.');
  }

  Future<void> listenForErrors() {
    throw UnimplementedError('listenForErrors() has not been implemented.');
  }

  Future<void> listenForJourneyId() {
    throw UnimplementedError('listenForJourneyId() has not been implemented.');
  }

  Future<void> fetchProducts() {
    throw UnimplementedError('fetchProducts() has not been implemented.');
  }

  void listenForProducts() {
    throw UnimplementedError('listenForProducts() has not been implemented.');
  }

  void listenForErrorProducts() {
    //this error also listen for get form Info
    throw UnimplementedError('listenForErrorProducts() has not been implemented.');
  }

  Future<void> sendFormDataRequestToiOS(int productId) {
    throw UnimplementedError('sendFormDataRequestToiOS() has not been implemented.');
  }

  void listenForFormData() {
    throw UnimplementedError('listenForFormData() has not been implemented.');
  }

  void listenForEmptyFormInfo() {
    throw UnimplementedError('listenForEmptyFormInfo() has not been implemented.');
  }

  Future<void> callScanCardID(int documentType) {
    throw UnimplementedError('callScanCardID() has not been implemented.');
  }

  void listenCardImages() {
    throw UnimplementedError('listenCardImages() has not been implemented.');
  }

  void listenCardError() {
    throw UnimplementedError('listenCardError() has not been implemented.');
  }

  void listenToCardData() {
    throw UnimplementedError('listenToCardData() has not been implemented.');
  }

  void listenToKYCData() {
    throw UnimplementedError('listenToKYCData() has not been implemented.');
  }
  void listenToKYCDataError() {
    throw UnimplementedError('listenToKYCDataError() has not been implemented.');
  }

  Future<void> updateKYC(String kycField) {
    throw UnimplementedError('updateKYC() has not been implemented.');
  }

  Future<void> scanYourFaceID() {
    throw UnimplementedError('scanYourFaceID() has not been implemented.');
  }

  void listenToFaceIDData() {
    throw UnimplementedError('listenToFaceIDData() has not been implemented.');
  }

  void listenToFaceIDError() {
    throw UnimplementedError('listenToFaceIDError() has not been implemented.');
  }

  Future<void> closeJourney(String customerID) {
    throw UnimplementedError('closeJourney() has not been implemented.');
  }

  void listenToCloseJourney() {
    throw UnimplementedError('listenToCloseJourney() has not been implemented.');
  }

  void listenToCloseJourneyWithError() {
    throw UnimplementedError('listenToCloseJourneyWithError() has not been implemented.');
  }
}