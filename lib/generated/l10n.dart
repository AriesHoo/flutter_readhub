// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Freadhub`
  String get appName {
    return Intl.message(
      'Freadhub',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Choice theme`
  String get choiceTheme {
    return Intl.message(
      'Choice theme',
      name: 'choiceTheme',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get red {
    return Intl.message(
      'Red',
      name: 'red',
      desc: '',
      args: [],
    );
  }

  /// `Orange`
  String get orange {
    return Intl.message(
      'Orange',
      name: 'orange',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get yellow {
    return Intl.message(
      'Yellow',
      name: 'yellow',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get green {
    return Intl.message(
      'Green',
      name: 'green',
      desc: '',
      args: [],
    );
  }

  /// `Cyan`
  String get cyan {
    return Intl.message(
      'Cyan',
      name: 'cyan',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get blue {
    return Intl.message(
      'Blue',
      name: 'blue',
      desc: '',
      args: [],
    );
  }

  /// `Purple`
  String get purple {
    return Intl.message(
      'Purple',
      name: 'purple',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get thursday {
    return Intl.message(
      'Thursday',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get friday {
    return Intl.message(
      'Friday',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get saturday {
    return Intl.message(
      'Saturday',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get sunday {
    return Intl.message(
      'Sunday',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get darkMode {
    return Intl.message(
      'Dark theme',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Light theme`
  String get lightMode {
    return Intl.message(
      'Light theme',
      name: 'lightMode',
      desc: '',
      args: [],
    );
  }

  /// `More settings`
  String get moreSetting {
    return Intl.message(
      'More settings',
      name: 'moreSetting',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loadingWebTitle {
    return Intl.message(
      'Loading...',
      name: 'loadingWebTitle',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Forward`
  String get forward {
    return Intl.message(
      'Forward',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Pull up`
  String get loadIdle {
    return Intl.message(
      'Pull up',
      name: 'loadIdle',
      desc: '',
      args: [],
    );
  }

  /// `Load failed`
  String get loadFailed {
    return Intl.message(
      'Load failed',
      name: 'loadFailed',
      desc: '',
      args: [],
    );
  }

  /// `No more data`
  String get loadNoMore {
    return Intl.message(
      'No more data',
      name: 'loadNoMore',
      desc: '',
      args: [],
    );
  }

  /// `Click again to exit the app`
  String get quitApp {
    return Intl.message(
      'Click again to exit the app',
      name: 'quitApp',
      desc: '',
      args: [],
    );
  }

  /// `Load failed`
  String get viewStateError {
    return Intl.message(
      'Load failed',
      name: 'viewStateError',
      desc: '',
      args: [],
    );
  }

  /// `Load failed,check network `
  String get viewStateNetworkError {
    return Intl.message(
      'Load failed,check network ',
      name: 'viewStateNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Nothing at all`
  String get viewStateEmpty {
    return Intl.message(
      'Nothing at all',
      name: 'viewStateEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get viewStateRefresh {
    return Intl.message(
      'Refresh',
      name: 'viewStateRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get viewStateRetry {
    return Intl.message(
      'Retry',
      name: 'viewStateRetry',
      desc: '',
      args: [],
    );
  }

  /// `Hide floating button`
  String get settingHideFloatingButton {
    return Intl.message(
      'Hide floating button',
      name: 'settingHideFloatingButton',
      desc: '',
      args: [],
    );
  }

  /// `Style`
  String get settingStyle {
    return Intl.message(
      'Style',
      name: 'settingStyle',
      desc: '',
      args: [],
    );
  }

  /// `Download image`
  String get downloadImage {
    return Intl.message(
      'Download image',
      name: 'downloadImage',
      desc: '',
      args: [],
    );
  }

  /// `Save succeed in user phone`
  String get saveImageSucceedInGallery {
    return Intl.message(
      'Save succeed in user phone',
      name: 'saveImageSucceedInGallery',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get read / write file permission`
  String get saveImagePermissionFailed {
    return Intl.message(
      'Failed to get read / write file permission',
      name: 'saveImagePermissionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Save image failed`
  String get saveImageFailed {
    return Intl.message(
      'Save image failed',
      name: 'saveImageFailed',
      desc: '',
      args: [],
    );
  }

  /// `Shared by Freadhub app`
  String get saveImageShareTip {
    return Intl.message(
      'Shared by Freadhub app',
      name: 'saveImageShareTip',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Open by system browser`
  String get openBySystemBrowser {
    return Intl.message(
      'Open by system browser',
      name: 'openBySystemBrowser',
      desc: '',
      args: [],
    );
  }

  /// `App copyright`
  String get appCopyright {
    return Intl.message(
      'App copyright',
      name: 'appCopyright',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Check update`
  String get checkUpdate {
    return Intl.message(
      'Check update',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Share app`
  String get shareApp {
    return Intl.message(
      'Share app',
      name: 'shareApp',
      desc: '',
      args: [],
    );
  }

  /// `Current version is the latest`
  String get currentIsNew {
    return Intl.message(
      'Current version is the latest',
      name: 'currentIsNew',
      desc: '',
      args: [],
    );
  }

  /// `Update now`
  String get updateNow {
    return Intl.message(
      'Update now',
      name: 'updateNow',
      desc: '',
      args: [],
    );
  }

  /// `Next time`
  String get updateNextTime {
    return Intl.message(
      'Next time',
      name: 'updateNextTime',
      desc: '',
      args: [],
    );
  }

  /// `Font size`
  String get fontSize {
    return Intl.message(
      'Font size',
      name: 'fontSize',
      desc: '',
      args: [],
    );
  }

  /// `Appreciate`
  String get appreciateDeveloper {
    return Intl.message(
      'Appreciate',
      name: 'appreciateDeveloper',
      desc: '',
      args: [],
    );
  }

  /// `The current system is in dark mode`
  String get tipSwitchThemeWhenPlatformDark {
    return Intl.message(
      'The current system is in dark mode',
      name: 'tipSwitchThemeWhenPlatformDark',
      desc: '',
      args: [],
    );
  }

  /// `Please install email app and try again！`
  String get tipNoEmailApp {
    return Intl.message(
      'Please install email app and try again！',
      name: 'tipNoEmailApp',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}