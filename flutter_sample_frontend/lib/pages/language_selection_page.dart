import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageSelectionPage extends StatelessWidget {
  final VoidCallback? onLanguageSelected;
  LanguageSelectionPage({this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final languages = languageProvider.availableLanguages;
    return Scaffold(
      backgroundColor: Color(0xFFD0F4FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose Your Language',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062863),
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...languages.map((lang) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            await languageProvider.changeLanguage(lang['code']!);
                            if (onLanguageSelected != null) onLanguageSelected!();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                            decoration: BoxDecoration(
                              color: Color(0xFF62D9FF).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Color(0xFF62D9FF).withOpacity(0.18),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.language,
                                  color: Color(0xFF238FFF),
                                  size: 28,
                                ),
                                SizedBox(width: 18),
                                Expanded(
                                  child: Text(
                                    lang['nativeName'] ?? lang['name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF062863),
                                    ),
                                  ),
                                ),
                                if (languageProvider.currentLocale.languageCode == lang['code'])
                                  Icon(Icons.check_circle, color: Color(0xFF238FFF), size: 24),
                              ],
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
