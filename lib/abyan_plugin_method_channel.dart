import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:abyan_plugin/models/products.dart';
import 'package:flutter/services.dart';

import 'abyan_plugin_platform_interface.dart';

/// An implementation of [AbyanPluginPlatform] that uses method channels.
class MethodChannelAbyanPlugin extends AbyanPluginPlatform {
  final MethodChannel _journeyChannel = const MethodChannel('createJourney');
  final MethodChannel _journeyIdChannel =
      const MethodChannel('journeyIdChannel');
  final MethodChannel _productChannel = const MethodChannel('getProduct');
  final MethodChannel _formDataChannel = const MethodChannel('getFormData');
  final MethodChannel _scanningChannel =
      const MethodChannel('scanCardIDChannel');
  final MethodChannel _getKYCChannel = const MethodChannel('_getKYCChannel');
  final MethodChannel _updateKYCChannel =
      const MethodChannel('updateKYCChannel');
  final MethodChannel _livenessCheckChannel =
      const MethodChannel('livenessCheckChannel');
  final MethodChannel _closeJourneyChannel =
      const MethodChannel('closeJourneyChannel');
  final MethodChannel _errorChannel =
      const MethodChannel('didFinishCreatingJourneyWithError');

  @override
  Future<String> createJourney(String journeyType) async {
    final Completer<String> completer = Completer<String>();

    _journeyIdChannel.setMethodCallHandler((call) async {
      if (call.method == "onJourneyIdReceived") {
        String journeyId = call.arguments;
        completer.complete(journeyId);
      }
    });

    _errorChannel.setMethodCallHandler((call) async {
      if (call.method == "didFinishCreatingJourneyWithError") {
        String errorMessage = call.arguments;
        completer.completeError(errorMessage);
      }
    });

    try {
      await _journeyChannel.invokeMethod('createJourneyinAbyan', journeyType);
    } on PlatformException catch (e) {
      completer.completeError(e.message ?? "Failed to create journey");
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  @override
  Future<List<Product>> fetchProducts() async {
    final Completer<List<Product>> completer = Completer<List<Product>>();

    _productChannel.setMethodCallHandler((call) async {
      if (call.method == "onProductsReceived") {
        String jsonString = call.arguments;
        List<Product> products = Product.fromJsonList(jsonDecode(jsonString));
        completer.complete(products);
      }

      //NOTE: this error also listen for get form Info
      if (call.method == "onErrorProducts") {
        String errorMessage = call.arguments;
        completer.completeError(errorMessage);
      }
    });

    try {
      await _journeyChannel.invokeMethod('fetchProduct');
    } on PlatformException catch (e) {
      completer.completeError(e.message ?? "Failed to fetch products");
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  @override
  Future<String> sendFormDataRequest(int productId) async {
    final Completer<String> completer = Completer<String>();

    _formDataChannel.setMethodCallHandler((call) async {
      if (call.method == "onFormDataReceived") {
        String jsonString = call.arguments;
        completer.complete(jsonString);
      }

      if (call.method == "emptyFormInfofields") {
        completer.completeError("Selected product has an issue, please check the portal");
      }
    });

    try {
      await _journeyChannel.invokeMethod('fetchFormData', productId);
    } on PlatformException catch (e) {
      completer.completeError(e.message ?? "Failed to fetch products");
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  @override
  Future<String> callScanDocument(int documentType) async {
    final Completer<String> completer = Completer<String>();

    _scanningChannel.setMethodCallHandler((call) async {
      if (call.method == "onDocumentsCaptured") {
        //todo: add the ability to return the captured documents as path.
        //completer.complete("Document Captured");
      }

      if (call.method == "onErrorCapturingDocuments") {
        String errorMessage = call.arguments;
        completer.completeError(errorMessage);
      }

      if (call.method == "documentResponseData") {
        String jsonString = call.arguments;
        completer.complete(jsonString);
      }
    });

    try {
      await _journeyChannel.invokeMethod('scanCard', documentType);
    } on PlatformException catch (e) {
      completer.completeError(e.message ?? "Failed to fetch products");
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  @override
  Future<String> startLivenessCheck() async {
    final Completer<String> completer = Completer<String>();

    _livenessCheckChannel.setMethodCallHandler((call) async {
      if (call.method == "ImageMatchingResponseData") {
        String jsonString = call.arguments;
        completer.complete(jsonString);
      }

      if (call.method == "ImageMatchingErrorResponseData") {
        String errorMessage = call.arguments;
        completer.completeError(errorMessage);
      }
    });

    try {
      await _journeyChannel.invokeMethod('scanfaceID');
    } on PlatformException catch (e) {
      completer.completeError(e.message ?? "Failed to fetch products");
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  @override
  Future<String> closeJourney(String customerID) async {
    final Completer<String> completer = Completer<String>();
    _closeJourneyChannel.setMethodCallHandler((call) async {
      if (call.method == "didFinishCloseJourneyWithSuccess") {
        completer.complete("Finish Close Journey Success");
      }

      if (call.method == "didFinishCloseWithError") {
        String errorMessage = call.arguments;
        completer.completeError(errorMessage);
      }
    });
    try {
      await _journeyChannel.invokeMethod('closeJourney', customerID);
    } on PlatformException catch (e) {
      completer.completeError(e.message ?? "Failed to fetch products");
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  //todo
  @override
  Future<void> updateKYC(String kycField) async {
    try {
      final jsonData = jsonEncode({'kycField': kycField});
      await _journeyChannel.invokeMethod('updateKYC', jsonData);
      print('Method called in AppDelegate');
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    } catch (e) {
      print("catch an error = $e}");
    }
  }
 //

  Future<void> getKYC() async {
    final Completer<String> completer = Completer<String>();

    _getKYCChannel.setMethodCallHandler((call) async {

      if (call.method == "kycResponseData") {
        String jsonString = call.arguments;
        updateKYC(jsonString);
        completer.complete(jsonString);
        log("kyc response data", name: "ScanDocument");
      }

      if (call.method == "kycResponseError") {
        String errorMessage = call.arguments;
        completer.completeError(errorMessage);
      }
    });

    try {
      await _journeyChannel.invokeMethod('getKYC');
      print('Method called in AppDelegate');
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
    } catch (e) {
      print("catch an error = $e}");
    }
  }
}
