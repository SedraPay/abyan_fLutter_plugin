import 'package:flutter/material.dart';


void showSimpleAlertDialog(BuildContext context, String title, String message,
    {VoidCallback? onPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onPressed != null) {
                onPressed();
              }
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
