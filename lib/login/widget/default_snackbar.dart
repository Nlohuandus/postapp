import 'package:flutter/material.dart';

class DefaultSnackbar {
  const DefaultSnackbar({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  static show(BuildContext context, String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(text),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
