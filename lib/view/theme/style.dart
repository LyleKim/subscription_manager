import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryBlue = Color(0xFF0011FF); 
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color textBlack = Color(0xFF333333);
}

class AppTextStyle {
  static const TextStyle title = TextStyle(
    fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.textBlack
  );
  static const TextStyle body = TextStyle(
    fontSize: 16, color: AppColor.textBlack
  );
}