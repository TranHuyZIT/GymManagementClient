import 'package:flutter/material.dart';

class CommonService {
  static void popUpMessage(String msg, context){
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)));
  }
}