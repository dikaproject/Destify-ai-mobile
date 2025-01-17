import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  final String key = "language";
  SharedPreferences? _prefs;
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadFromPrefs();
  }

  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    String languageCode = _prefs?.getString(key) ?? 'en';
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs?.setString(key, _currentLocale.languageCode);
  }

  void setLocale(Locale locale) {
    if (!['en', 'id'].contains(locale.languageCode)) return;
    _currentLocale = locale;
    _saveToPrefs();
    notifyListeners();
  }

  String getLanguageName() {
    switch (_currentLocale.languageCode) {
      case 'id':
        return 'Bahasa Indonesia';
      case 'en':
      default:
        return 'English';
    }
  }
}
