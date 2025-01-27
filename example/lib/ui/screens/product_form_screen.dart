import 'package:abyan_plugin/abyan_plugin.dart';
import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  ProductFormScreen({super.key});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
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
              Form(
                key: _formKey,
                child: Placeholder(child: Text('Product Form')),
              ),
              Spacer(),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: () => submitProductForm(context),
                      child: Text("Submit Product Form"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitProductForm(BuildContext context) async {
    Navigator.pushNamed(context, "/scanDocuments");
  }
}
