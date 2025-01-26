import 'abyan_plugin_platform_interface.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

/// An implementation of [AbyanPluginPlatform] that uses method channels.
class MethodChannelAbyanPlugin extends AbyanPluginPlatform {
  final MethodChannel _journeyChannel = const MethodChannel('createJourney');
  final MethodChannel _journeyIdChannel = const MethodChannel('journeyIdChannel');
  final MethodChannel _productChannel = const MethodChannel('getProduct');
  final MethodChannel _formDataChannel = const MethodChannel('getFormData');
  final MethodChannel _scanningChannel = const MethodChannel('scanCardIDChannel');
  final MethodChannel _updateKYCChannel = const MethodChannel('updateKYCChannel');
  final MethodChannel _livenessCheckChannel = const MethodChannel('livenessCheckChannel');
  final MethodChannel _closeJourneyChannel = const MethodChannel('closeJourneyChannel');
  final MethodChannel _errorChannel = const MethodChannel('didFinishCreatingJourneyWithError');

  Future<void> createJourney(String journeyType) async {
    try {
      await _journeyChannel.invokeMethod('createJourneyinAbyan', journeyType);
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    } catch (e) {
      print("catch an error = $e}");
    }
  }

  Future<void> listenForErrors() async {
    _errorChannel.setMethodCallHandler((call) async {
      if (call.method == "didFinishCreatingJourneyWithError") {
        String errorMessage = call.arguments;
        print("Received AbyanError: $errorMessage");
      }
    });
  }

  Future<void> listenForJourneyId() async {
    _journeyIdChannel.setMethodCallHandler((call) async {
      if (call.method == "onJourneyIdReceived") {
        String journeyId = call.arguments;
        print("Received journeyId: $journeyId");
      }
    });
  }

  Future<void> fetchProducts() async {
    try {
      await _productChannel.invokeMethod('fetchProduct');
      print('Sent product request to iOS.');
    } on PlatformException catch (e) {
      print("Failed to send request: '${e.message}'.");
    }
  }

  void listenForProducts() {
    _productChannel.setMethodCallHandler((call) async {
      if (call.method == "onProductsReceived") {
        String jsonString = call.arguments;
        log(jsonString, name: "listenForProducts");
      }
    });
  }

  Future<void> sendFormDataRequestToiOS(int productId) async {
    try {
      await _formDataChannel.invokeMethod('fetchFormData', productId);
      print("Method fetchFormData called successfully");
    } on PlatformException catch (e) {
      print("Failed to call fetchFormData: ${e.message}");
    }
  }

  void listenForFormData() {
    _formDataChannel.setMethodCallHandler((call) async {
      if (call.method == "onFormDataReceived") {
        String jsonString = call.arguments;
        log(jsonString, name: "listenForFormData");
      }
    });
  }

  void listenForEmptyFormInfo() {
    _formDataChannel.setMethodCallHandler((call) async {
      if (call.method == "emptyFormInfofields") {
        log("Empty Form Info fields");
      }
    });
  }

  Future<void> callScanCardID(int documentType) async {
    try {
      await _scanningChannel.invokeMethod('scanCard', documentType);
      print('Method called in AppDelegate');
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    } catch (e) {
      print("catch an error = $e}");
    }
  }

  void listenCardImages() {
    _scanningChannel.setMethodCallHandler((call) async {
      if (call.method == "onDocumentsCaptured") {
        log("Card Images Data");
      }
    });
  }

  void listenToCardData() {
    _scanningChannel.setMethodCallHandler((call) async {
      if (call.method == "documentResponseData") {
        String jsonString = call.arguments;
        log(jsonString, name: "Card Data");
      }
    });
  }

  void listenToKYCData() {
    _scanningChannel.setMethodCallHandler((call) async {
      if (call.method == "kycResponseData") {
        String jsonString = call.arguments;
        updateKYC(jsonString);
        log(jsonString, name: "KYC Data");
      }
    });
  }

  Future<void> updateKYC(String kycField) async {
    try {
      final jsonData = jsonEncode({'kycField': kycField});
      await _updateKYCChannel.invokeMethod('updateKYC', jsonData);
      print('Method called in AppDelegate');
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    } catch (e) {
      print("catch an error = $e}");
    }
  }

  Future<void> scanYourFaceID() async {
    try {
      await _livenessCheckChannel.invokeMethod('scanfaceID');
      print('Method called in AppDelegate');
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    } catch (e) {
      print("catch an error = $e}");
    }
  }

  void listenToFaceIDData() {
    _livenessCheckChannel.setMethodCallHandler((call) async {
      if (call.method == "ImageMatchingResponseData") {
        String jsonString = call.arguments;
        log(jsonString, name: "face id Data");
      }
    });
  }

  Future<void> closeJourney(String customerID) async {
    try {
      await _closeJourneyChannel.invokeMethod('closeJourney', customerID);
      print('Method called in AppDelegate');
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    } catch (e) {
      print("catch an error = $e}");
    }
  }

  void listenToCloseJourney() {
    _closeJourneyChannel.setMethodCallHandler((call) async {
      if (call.method == "didFinishCloseJourneyWithSuccess") {
        log("Finish Close Journey Success");
      }
    });
  }
}