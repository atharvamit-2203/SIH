import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _currentLocale = const Locale('en');
  
  Locale get currentLocale => _currentLocale;
  
  // Available languages with their display names
  static const Map<String, Map<String, String>> supportedLanguages = {
    'en': {
      'name': 'English',
      'nativeName': 'English',
      'code': 'en',
    },
    'hi': {
      'name': 'Hindi',
      'nativeName': 'हिंदी',
      'code': 'hi',
    },
    'mr': {
      'name': 'Marathi',
      'nativeName': 'मराठी',
      'code': 'mr',
    },
  };
  
  LanguageProvider() {
    _loadSavedLanguage();
  }
  
  /// Load saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey) ?? 'en';
      
      // Validate that the saved language is supported
      if (supportedLanguages.containsKey(savedLanguage)) {
        _currentLocale = Locale(savedLanguage);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
      // Fall back to English if there's an error
      _currentLocale = const Locale('en');
    }
  }
  
  /// Change the current language
  Future<void> changeLanguage(String languageCode) async {
    if (!supportedLanguages.containsKey(languageCode)) {
      debugPrint('Unsupported language code: $languageCode');
      return;
    }
    
    if (_currentLocale.languageCode == languageCode) {
      return; // No change needed
    }
    
    try {
      _currentLocale = Locale(languageCode);
      notifyListeners();
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      
      debugPrint('Language changed to: $languageCode');
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }
  
  /// Get the display name of current language
  String get currentLanguageDisplayName {
    final langData = supportedLanguages[_currentLocale.languageCode];
    return langData?['nativeName'] ?? 'English';
  }
  
  /// Get all supported languages for UI display
  List<Map<String, String>> get availableLanguages {
    return supportedLanguages.values.toList();
  }
  
  /// Check if the current language is RTL (Right-to-Left)
  bool get isRTL {
    // Currently none of our supported languages are RTL
    // Add 'ar', 'he', 'fa', etc. here if you add RTL languages
    return false;
  }
  
  /// Get the text direction based on current language
  TextDirection get textDirection {
    return isRTL ? TextDirection.rtl : TextDirection.ltr;
  }
  
  /// Reset to default language
  Future<void> resetToDefault() async {
    await changeLanguage('en');
  }
  
  /// Clear saved language preference
  Future<void> clearSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_languageKey);
      _currentLocale = const Locale('en');
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing saved language: $e');
    }
  }
}