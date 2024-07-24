import 'package:flutter/material.dart';

class DefaultSnackbar {
  const DefaultSnackbar({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  static show(
    BuildContext context, {
    required String text,
    required Color color,
    bool persistent = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: persistent,
        duration:
            persistent ? const Duration(hours: 1) : const Duration(seconds: 2),
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
