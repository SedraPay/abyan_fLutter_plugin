import 'package:abyan_plugin/abyan_plugin.dart';
import 'package:abyan_plugin_example/ui/dialogs/SimpleAlertDialog.dart';
import 'package:flutter/material.dart';

class ScanDocumentsScreen extends StatefulWidget {
  ScanDocumentsScreen({super.key});

  @override
  _ScanDocumentsScreenState createState() => _ScanDocumentsScreenState();
}

class _ScanDocumentsScreenState extends State<ScanDocumentsScreen> {
  final _abyanFlutterPlugin = AbyanPlugin();

  final _formKey = GlobalKey<FormState>();

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
                      onPressed: () => startDocumentScanProcess(context),
                      child: Text("Scan Document Scan Process"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startDocumentScanProcess(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      String result =
      await _abyanFlutterPlugin.scanDocument(1);

      showSimpleAlertDialog(
        context,
        'Scan document result',
        'completed',
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
