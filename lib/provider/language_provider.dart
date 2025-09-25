import 'package:flutter/material.dart';
import '../l10n/l10n.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // mặc định tiếng Anh

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    // set ngon ngu cho tât ca
    if (!L10n.all.contains(locale)) return; 
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en'); 
    notifyListeners();
  }
}
