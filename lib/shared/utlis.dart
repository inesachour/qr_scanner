import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void copyQrCodeText({required BuildContext context, required String text}){
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Text copied!'), duration: Duration(seconds: 1),));
}