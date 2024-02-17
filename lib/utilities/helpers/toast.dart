import 'package:flutter/material.dart';

class Toast {
  static void show(String message, BuildContext context, {int duration = 2}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
