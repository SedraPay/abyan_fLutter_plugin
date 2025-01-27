import 'package:abyan_plugin/abyan_plugin.dart';
import 'package:abyan_plugin_example/ui/dialogs/SimpleAlertDialog.dart';
import 'package:flutter/material.dart';

class CreateJourneyScreen extends StatefulWidget {
  CreateJourneyScreen({super.key});

  @override
  _CreateJourneyScreenState createState() => _CreateJourneyScreenState();
}

class _CreateJourneyScreenState extends State<CreateJourneyScreen> {
  final _abyanFlutterPlugin = AbyanPlugin();

  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();

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
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _apiKeyController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your subscription key',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your subscription key';
                    }
                    return null;
                  },
                ),
              ),
              Spacer(),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: () => createJourney(context),
                      child: Text("Start Journey"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createJourney(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      String result =
          await _abyanFlutterPlugin.createJourney(_apiKeyController.text);
      //store the journey id in your application and use it to link the journey to the user
      showSimpleAlertDialog(
        context,
        'Journey ID',
        result,
        onPressed: () {
          Navigator.pushNamed(context, '/selectProduct');
        },
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
