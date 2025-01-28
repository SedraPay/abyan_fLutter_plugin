import 'dart:convert';
import 'dart:developer';

import 'package:abyan_plugin/abyan_plugin.dart';
import 'package:abyan_plugin/models/products.dart';
import 'package:abyan_plugin_example/ui/dialogs/SimpleAlertDialog.dart';
import 'package:flutter/material.dart';

class LivenessScreen extends StatefulWidget {
  LivenessScreen({super.key});

  @override
  _LivenessScreenState createState() => _LivenessScreenState();
}

class _LivenessScreenState extends State<LivenessScreen> {
  final _abyanFlutterPlugin = AbyanPlugin();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: () => startLivenessProcess(context),
                      child: Text("Start Liveness Process"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startLivenessProcess(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      String result =
      await _abyanFlutterPlugin.startLivenessCheck();

      var jsonObject = jsonDecode(result);
      var prettyString = const JsonEncoder.withIndent('  ').convert(jsonObject);

      showSimpleAlertDialog(
        context,
        'Scan document result',
        prettyString,
      );
    } catch (e) {
      showSimpleAlertDialog(context, 'Error', e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
