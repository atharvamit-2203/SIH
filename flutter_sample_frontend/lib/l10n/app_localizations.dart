import 'package:flutter/material.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';
abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  // Welcome Screen
  String get appName;
  String get welcomeTagline;
  String get loginButton;
  String get signUpButton;
  String get continueAsGuest;

  // Login & Signup
  String get welcomeBack;
  String get loginSubtitle;
  String get username;
  String get password;
  String get email;
  String get fullName;
  String get login;
  String get signUp;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get forgotPassword;

  // Dashboard
  String get welcomeBackUser;
  String get currentRank;
  String get totalScore;
  String get streak;
  String get days;
  String get points;
  String get inClass;
  String get leaderboard;
  String get viewAll;
  String get recentAwards;
  String get yourSubjects;
  String get quickPlay;

  // Subjects
  String get mathematics;
  String get science;
  String get english;
  String get history;
  String get geography;
  String get computerScience;
  String get physics;
  String get chemistry;
  String get biology;
  String get hindi;
  String get socialStudies;
  String get selectSubjects;
  String get chooseYourSubjects;

  // Topics
  String get topics;
  String get selectTopic;
  String get algebra;
  String get geometry;
  String get arithmetic;
  String get calculus;
  String get probability;
  String get statistics;

  // Games
  String get games;
  String get mathQuiz;
  String get wordBuilder;
  String get memoryGame;
  String get speedMath;
  String get brainTrainer;
  String get play;
  String get difficulty;
  String get easy;
  String get medium;
  String get hard;

  // Settings
  String get settings;
  String get language;
  String get darkMode;
  String get notifications;
  String get aboutApp;
  String get reportProblem;
  String get visitDeveloperSite;

  // Common
  String get back;
  String get next;
  String get cancel;
  String get ok;
  String get yes;
  String get no;
  String get save;
  String get edit;
  String get delete;
  String get search;
  String get loading;
  String get error;
  String get success;
  String get close;

  // Achievements
  String get mathWizard;
  String get scienceExplorer;
  String get speedReader;
  String get problemSolver;
  String get newAchievement;
  String get rankUpdate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'mr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'hi':
        return AppLocalizationsHi();
      case 'mr':
        return AppLocalizationsMr();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}