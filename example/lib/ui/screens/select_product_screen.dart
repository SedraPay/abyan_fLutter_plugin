import 'dart:convert';
import 'dart:developer';

import 'package:abyan_plugin/abyan_plugin.dart';
import 'package:abyan_plugin/models/products.dart';
import 'package:abyan_plugin_example/ui/dialogs/SimpleAlertDialog.dart';
import 'package:flutter/material.dart';

class SelectProductScreen extends StatefulWidget {
  SelectProductScreen({super.key});

  @override
  _SelectProductScreenState createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  final _abyanFlutterPlugin = AbyanPlugin();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  Product? selectedProduct;
  final List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchAndListenForProducts();
  }

  Future<void> fetchAndListenForProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Product> response = await _abyanFlutterPlugin.fetchProducts();

      setState(() {
        products.clear();
        products.addAll(response);
      });
    } catch (e) {
      log("Error fetching products: $e");
      showSimpleAlertDialog(context, 'Error', e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                child: DropdownButtonFormField<Product>(
                  decoration: const InputDecoration(
                    labelText: 'Select a product',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedProduct,
                  items: products
                      .map((product) => DropdownMenuItem(
                            value: product,
                            child: Text(product.name ?? 'product_has_no_name'),
                          ))
                      .toList(),
                  onChanged: (Product? newValue) {
                    setState(() {
                      selectedProduct = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a product';
                    }
                    return null;
                  },
                ),
              ),
              Spacer(),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: () => getFormDataForProduct(context),
                      child: Text("Get Product Form Data"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getFormDataForProduct(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedProduct == null) {
      showSimpleAlertDialog(context, 'Error', 'Please select a product');
      return;
    }

    if (selectedProduct?.id == null) {
      showSimpleAlertDialog(context, 'Error', 'ID of selected product is null');
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      String result =
          await _abyanFlutterPlugin.sendFormDataRequest(selectedProduct!.id!);

      var jsonObject = jsonDecode(result);
      var prettyString = const JsonEncoder.withIndent('  ').convert(jsonObject);

      showSimpleAlertDialog(
        context,
        'Form Data',
        prettyString,
        onPressed: () {
          Navigator.pushNamed(context, '/productForm');
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
