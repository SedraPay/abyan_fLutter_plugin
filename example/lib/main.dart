import 'dart:async';

import 'package:abyan_plugin/abyan_plugin.dart';
import 'package:abyan_plugin_example/ui/screens/liveness_screen.dart';
import 'package:abyan_plugin_example/ui/screens/product_form_screen.dart';
import 'package:abyan_plugin_example/ui/screens/scan_documents_screen.dart';
import 'package:abyan_plugin_example/ui/screens/select_product_screen.dart';
import 'package:abyan_plugin_example/ui/screens/start_journey_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _abyanFlutterPlugin = AbyanPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Initialize any platform-specific state if needed
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/createJourney',
      routes: getRoutes(),
    );
  }

  Map<String, WidgetBuilder> getRoutes() {
    return {
      '/createJourney': (_) => CreateJourneyScreen(),
      '/selectProduct': (_) => SelectProductScreen(),
      '/productForm': (_) => ProductFormScreen(),
      '/scanDocuments': (_) => ScanDocumentsScreen(),
      '/liveness': (_) => LivenessScreen(),
    };
  }
// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: const Text('Plugin example app'),
//       ),
//       body: StartJourneyScreen(),
//       // body: Center(
//       //   child: Column(
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     children: <Widget>[
//       //       FilledButton(
//       //         onPressed: () {
//       //           _abyanFlutterPlugin.createJourney("7196137434652977");
//       //         },
//       //         child: Text("Start Journey"),
//       //       ),
//       //       FilledButton(
//       //         onPressed: () {
//       //           _abyanFlutterPlugin.fetchProducts();
//       //         },
//       //         child: Text("Get Products"),
//       //       ),
//       //       FilledButton(
//       //         onPressed: () {
//       //           _abyanFlutterPlugin.sendFormDataRequestToiOS(485);
//       //         },
//       //         child: Text("Get Form Data"),
//       //       ),
//       //       FilledButton(
//       //         onPressed: () {
//       //           _abyanFlutterPlugin.callScanCardID(1);
//       //         },
//       //         child: Text("Scan ID Card"),
//       //       ),
//       //       FilledButton(
//       //         onPressed: () {
//       //           _abyanFlutterPlugin.updateKYC('kycData');
//       //         },
//       //         child: Text("Update KYC"),
//       //       ),
//       //       FilledButton(
//       //         onPressed: () {
//       //           _abyanFlutterPlugin.scanYourFaceID();
//       //         },
//       //         child: Text("Scan Face ID"),
//       //       ),
//       //       FilledButton(
//       //         onPressed: () {
//       //           _abyanFlutterPlugin.closeJourney("test");
//       //         },
//       //         child: Text("Close Journey"),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//     ),
//   );
// }
}
