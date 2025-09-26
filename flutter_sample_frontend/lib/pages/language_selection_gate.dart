import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_selection_page.dart';
import '../main.dart';
import '../providers/language_provider.dart';

class LanguageSelectionGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    // If language is not selected (default 'en'), show selection page
    // You can enhance this logic to check SharedPreferences for first launch
    if (languageProvider.currentLocale.languageCode == 'en' && !_hasUserSelectedLanguage(context)) {
      return LanguageSelectionPageWrapper();
    }
    return WelcomeScreen();
  }

  bool _hasUserSelectedLanguage(BuildContext context) {
    // You can implement a more robust check if needed
    // For now, always show selection if 'en' and not set
    return false;
  }
}

class LanguageSelectionPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LanguageSelectionPage(onLanguageSelected: () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
    });
  }
}