import 'package:flutter/material.dart';

class ToastUtils {
  static void showToast(BuildContext context, String? msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 120,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ), // RoundedRectangleBorder
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        content: Text(msg ?? "加载成功", textAlign: TextAlign.center),
      ), // SnackBar
    );
  }
}
