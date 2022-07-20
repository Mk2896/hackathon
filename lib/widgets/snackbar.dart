import 'package:flutter/material.dart';

void snackBar(String? value, Color? color, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(value!),
      backgroundColor: color,
    ),
  );
}
