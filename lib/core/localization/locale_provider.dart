import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _storageKey = 'app_locale_code';
  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCode = preferences.getString(_storageKey) ?? 'en';
    await initializeDateFormatting(savedCode);
    Intl.defaultLocale = savedCode;
    _locale = Locale(savedCode);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    if (!{'en', 'ur', 'ar'}.contains(languageCode)) return;
    if (_locale.languageCode == languageCode) return;

    await initializeDateFormatting(languageCode);
    Intl.defaultLocale = languageCode;
    _locale = Locale(languageCode);
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, languageCode);
  }
}
