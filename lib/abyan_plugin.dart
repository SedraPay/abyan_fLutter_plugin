import 'abyan_plugin_platform_interface.dart';

class AbyanPlugin {
  Future<void> createJourney(String journeyType) {
    return AbyanPluginPlatform.instance.createJourney(journeyType);
  }

  Future<void> listenForErrors() {
    return AbyanPluginPlatform.instance.listenForErrors();
  }

  Future<void> listenForJourneyId() {
    return AbyanPluginPlatform.instance.listenForJourneyId();
  }

  Future<void> fetchProducts() {
    return AbyanPluginPlatform.instance.fetchProducts();
  }

  void listenForProducts() {
    AbyanPluginPlatform.instance.listenForProducts();
  }

  void listenForErrorProducts() {
    AbyanPluginPlatform.instance.listenForErrorProducts();
  }

  Future<void> sendFormDataRequestToiOS(int productId) {
    return AbyanPluginPlatform.instance.sendFormDataRequestToiOS(productId);
  }

  void listenForFormData() {
    AbyanPluginPlatform.instance.listenForFormData();
  }

  void listenForEmptyFormInfo() {
    AbyanPluginPlatform.instance.listenForEmptyFormInfo();
  }

  Future<void> callScanCardID(int documentType) {
    return AbyanPluginPlatform.instance.callScanCardID(documentType);
  }

  void listenCardImages() {
    AbyanPluginPlatform.instance.listenCardImages();
  }

  void listenCardError() {
    AbyanPluginPlatform.instance.listenCardError();
  }
  void listenToCardData() {
    AbyanPluginPlatform.instance.listenToCardData();
  }

  void listenToKYCData() {
    AbyanPluginPlatform.instance.listenToKYCData();
  }

  void listenToKYCDataError() {
    AbyanPluginPlatform.instance.listenToKYCDataError();
  }
  Future<void> updateKYC(String kycField) {
    return AbyanPluginPlatform.instance.updateKYC(kycField);
  }

  Future<void> scanYourFaceID() {
    return AbyanPluginPlatform.instance.scanYourFaceID();
  }

  void listenToFaceIDData() {
    AbyanPluginPlatform.instance.listenToFaceIDData();
  }

  Future<void> closeJourney(String customerID) {
    return AbyanPluginPlatform.instance.closeJourney(customerID);
  }

  void listenToCloseJourney() {
    AbyanPluginPlatform.instance.listenToCloseJourney();
  }


  void listenToCloseJourneyWithError() {
    AbyanPluginPlatform.instance.listenToCloseJourneyWithError();
  }
}
