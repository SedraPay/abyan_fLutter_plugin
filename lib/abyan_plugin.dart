import 'package:abyan_plugin/models/products.dart';

import 'abyan_plugin_platform_interface.dart';

class AbyanPlugin {
  Future<String> createJourney(String journeyType) {
    return AbyanPluginPlatform.instance.createJourney(journeyType);
  }

  Future<List<Product>> fetchProducts() {
    return AbyanPluginPlatform.instance.fetchProducts();
  }

  Future<String> sendFormDataRequest(int productId) {
    return AbyanPluginPlatform.instance.sendFormDataRequest(productId);
  }

  Future<String> scanDocument(int documentType) {
    return AbyanPluginPlatform.instance.callScanDocument(documentType);
  }

  Future<String> scanYourFaceID() {
    return AbyanPluginPlatform.instance.scanYourFaceID();
  }

  Future<String> closeJourney(String customerID) {
    return AbyanPluginPlatform.instance.closeJourney(customerID);
  }

  //TODO
  Future<void> updateKYC(String kycField) {
    return AbyanPluginPlatform.instance.updateKYC(kycField);
  }

  Future<void> getKYC(String kycField) {
    return AbyanPluginPlatform.instance.getKYC();
  }
}
