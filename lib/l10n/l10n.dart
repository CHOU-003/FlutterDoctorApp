import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'), // English
    const Locale('vi'), // Tiếng Việt
    const Locale('ja'), // 日本語 (tiếng Nhật)
  ];

  static String getCountry(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Việt Nam';
      case 'ja':
        return '日本語 (Japanese)';
      default:
        return 'Unknown';
    }
  }
}
