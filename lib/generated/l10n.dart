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
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
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

  /// `做轻便的聚合资讯`
  String get slogan {
    return Intl.message(
      '做轻便的聚合资讯',
      name: 'slogan',
      desc: '',
      args: [],
    );
  }

  /// `温馨提示`
  String get dialogTitle {
    return Intl.message(
      '温馨提示',
      name: 'dialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `选择主题`
  String get choiceTheme {
    return Intl.message(
      '选择主题',
      name: 'choiceTheme',
      desc: '',
      args: [],
    );
  }

  /// `网易红`
  String get red {
    return Intl.message(
      '网易红',
      name: 'red',
      desc: '',
      args: [],
    );
  }

  /// `滴滴橙`
  String get orange {
    return Intl.message(
      '滴滴橙',
      name: 'orange',
      desc: '',
      args: [],
    );
  }

  /// `闲鱼黄`
  String get yellow {
    return Intl.message(
      '闲鱼黄',
      name: 'yellow',
      desc: '',
      args: [],
    );
  }

  /// `微信绿`
  String get green {
    return Intl.message(
      '微信绿',
      name: 'green',
      desc: '',
      args: [],
    );
  }

  /// `青桔青`
  String get cyan {
    return Intl.message(
      '青桔青',
      name: 'cyan',
      desc: '',
      args: [],
    );
  }

  /// `掘金蓝`
  String get blue {
    return Intl.message(
      '掘金蓝',
      name: 'blue',
      desc: '',
      args: [],
    );
  }

  /// `夸克紫`
  String get purple {
    return Intl.message(
      '夸克紫',
      name: 'purple',
      desc: '',
      args: [],
    );
  }

  /// `周一`
  String get monday {
    return Intl.message(
      '周一',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `周二`
  String get tuesday {
    return Intl.message(
      '周二',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `周三`
  String get wednesday {
    return Intl.message(
      '周三',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `周四`
  String get thursday {
    return Intl.message(
      '周四',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `周五`
  String get friday {
    return Intl.message(
      '周五',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `周六`
  String get saturday {
    return Intl.message(
      '周六',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `周日`
  String get sunday {
    return Intl.message(
      '周日',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `深色主题`
  String get darkMode {
    return Intl.message(
      '深色主题',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `浅色主题`
  String get lightMode {
    return Intl.message(
      '浅色主题',
      name: 'lightMode',
      desc: '',
      args: [],
    );
  }

  /// `更多信息`
  String get moreSetting {
    return Intl.message(
      '更多信息',
      name: 'moreSetting',
      desc: '',
      args: [],
    );
  }

  /// `加载中...`
  String get loadingWebTitle {
    return Intl.message(
      '加载中...',
      name: 'loadingWebTitle',
      desc: '',
      args: [],
    );
  }

  /// `后退`
  String get back {
    return Intl.message(
      '后退',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `前进`
  String get forward {
    return Intl.message(
      '前进',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `刷新`
  String get refresh {
    return Intl.message(
      '刷新',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `分享`
  String get share {
    return Intl.message(
      '分享',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `上拉加载更多`
  String get loadIdle {
    return Intl.message(
      '上拉加载更多',
      name: 'loadIdle',
      desc: '',
      args: [],
    );
  }

  /// `加载失败`
  String get loadFailed {
    return Intl.message(
      '加载失败',
      name: 'loadFailed',
      desc: '',
      args: [],
    );
  }

  /// `我也是有底线的`
  String get loadNoMore {
    return Intl.message(
      '我也是有底线的',
      name: 'loadNoMore',
      desc: '',
      args: [],
    );
  }

  /// `再点击一次退出程序`
  String get quitApp {
    return Intl.message(
      '再点击一次退出程序',
      name: 'quitApp',
      desc: '',
      args: [],
    );
  }

  /// `加载失败`
  String get viewStateError {
    return Intl.message(
      '加载失败',
      name: 'viewStateError',
      desc: '',
      args: [],
    );
  }

  /// `网络好像不给力哟！`
  String get viewStateNetworkError {
    return Intl.message(
      '网络好像不给力哟！',
      name: 'viewStateNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `空空如也`
  String get viewStateEmpty {
    return Intl.message(
      '空空如也',
      name: 'viewStateEmpty',
      desc: '',
      args: [],
    );
  }

  /// `刷新一下`
  String get viewStateRefresh {
    return Intl.message(
      '刷新一下',
      name: 'viewStateRefresh',
      desc: '',
      args: [],
    );
  }

  /// `重试`
  String get viewStateRetry {
    return Intl.message(
      '重试',
      name: 'viewStateRetry',
      desc: '',
      args: [],
    );
  }

  /// `隐藏悬浮按钮`
  String get settingHideFloatingButton {
    return Intl.message(
      '隐藏悬浮按钮',
      name: 'settingHideFloatingButton',
      desc: '',
      args: [],
    );
  }

  /// `样式`
  String get settingStyle {
    return Intl.message(
      '样式',
      name: 'settingStyle',
      desc: '',
      args: [],
    );
  }

  /// `保存图片到本地`
  String get downloadImage {
    return Intl.message(
      '保存图片到本地',
      name: 'downloadImage',
      desc: '',
      args: [],
    );
  }

  /// `已保存至手机`
  String get saveImageSucceedInGallery {
    return Intl.message(
      '已保存至手机',
      name: 'saveImageSucceedInGallery',
      desc: '',
      args: [],
    );
  }

  /// `文件读写权限获取失败`
  String get saveImagePermissionFailed {
    return Intl.message(
      '文件读写权限获取失败',
      name: 'saveImagePermissionFailed',
      desc: '',
      args: [],
    );
  }

  /// `保存文件失败`
  String get saveImageFailed {
    return Intl.message(
      '保存文件失败',
      name: 'saveImageFailed',
      desc: '',
      args: [],
    );
  }

  /// `来自「Freadhub」 App 的分享`
  String get saveImageShareTip {
    return Intl.message(
      '来自「Freadhub」 App 的分享',
      name: 'saveImageShareTip',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get cancel {
    return Intl.message(
      '取消',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `浏览器打开-推荐Chrome`
  String get openBySystemBrowser {
    return Intl.message(
      '浏览器打开-推荐Chrome',
      name: 'openBySystemBrowser',
      desc: '',
      args: [],
    );
  }

  /// `软件说明`
  String get appCopyright {
    return Intl.message(
      '软件说明',
      name: 'appCopyright',
      desc: '',
      args: [],
    );
  }

  /// `意见反馈`
  String get feedback {
    return Intl.message(
      '意见反馈',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `检查版本`
  String get checkUpdate {
    return Intl.message(
      '检查版本',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `分享软件`
  String get shareApp {
    return Intl.message(
      '分享软件',
      name: 'shareApp',
      desc: '',
      args: [],
    );
  }

  /// `当前已是最新版本`
  String get currentIsNew {
    return Intl.message(
      '当前已是最新版本',
      name: 'currentIsNew',
      desc: '',
      args: [],
    );
  }

  /// `立即更新`
  String get updateNow {
    return Intl.message(
      '立即更新',
      name: 'updateNow',
      desc: '',
      args: [],
    );
  }

  /// `下次再说`
  String get updateNextTime {
    return Intl.message(
      '下次再说',
      name: 'updateNextTime',
      desc: '',
      args: [],
    );
  }

  /// `文字大小`
  String get fontSize {
    return Intl.message(
      '文字大小',
      name: 'fontSize',
      desc: '',
      args: [],
    );
  }

  /// `赞赏开发`
  String get appreciateDeveloper {
    return Intl.message(
      '赞赏开发',
      name: 'appreciateDeveloper',
      desc: '',
      args: [],
    );
  }

  /// `英语`
  String get english {
    return Intl.message(
      '英语',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `当前系统为深色主题`
  String get tipSwitchThemeWhenPlatformDark {
    return Intl.message(
      '当前系统为深色主题',
      name: 'tipSwitchThemeWhenPlatformDark',
      desc: '',
      args: [],
    );
  }

  /// `请安装邮箱app后重试！`
  String get tipNoEmailApp {
    return Intl.message(
      '请安装邮箱app后重试！',
      name: 'tipNoEmailApp',
      desc: '',
      args: [],
    );
  }

  /// `回到顶部`
  String get tooltipScrollTop {
    return Intl.message(
      '回到顶部',
      name: 'tooltipScrollTop',
      desc: '',
      args: [],
    );
  }

  /// `复制成功`
  String get copyToClipboardSucceed {
    return Intl.message(
      '复制成功',
      name: 'copyToClipboardSucceed',
      desc: '',
      args: [],
    );
  }

  /// `卡片分享`
  String get cardShare {
    return Intl.message(
      '卡片分享',
      name: 'cardShare',
      desc: '',
      args: [],
    );
  }

  /// `微信`
  String get weChatFriend {
    return Intl.message(
      '微信',
      name: 'weChatFriend',
      desc: '',
      args: [],
    );
  }

  /// `朋友圈`
  String get weChatTimeLine {
    return Intl.message(
      '朋友圈',
      name: 'weChatTimeLine',
      desc: '',
      args: [],
    );
  }

  /// `QQ`
  String get qqFriend {
    return Intl.message(
      'QQ',
      name: 'qqFriend',
      desc: '',
      args: [],
    );
  }

  /// `微博`
  String get weiBoTimeLine {
    return Intl.message(
      '微博',
      name: 'weiBoTimeLine',
      desc: '',
      args: [],
    );
  }

  /// `钉钉`
  String get dingTalk {
    return Intl.message(
      '钉钉',
      name: 'dingTalk',
      desc: '',
      args: [],
    );
  }

  /// `企业微信`
  String get weWork {
    return Intl.message(
      '企业微信',
      name: 'weWork',
      desc: '',
      args: [],
    );
  }

  /// `复制链接`
  String get copyLink {
    return Intl.message(
      '复制链接',
      name: 'copyLink',
      desc: '',
      args: [],
    );
  }

  /// `浏览器打开`
  String get openByBrowser {
    return Intl.message(
      '浏览器打开',
      name: 'openByBrowser',
      desc: '',
      args: [],
    );
  }

  /// `更多`
  String get more {
    return Intl.message(
      '更多',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `分享您一个不错的App`
  String get aboutUsShareTitle {
    return Intl.message(
      '分享您一个不错的App',
      name: 'aboutUsShareTitle',
      desc: '',
      args: [],
    );
  }

  /// `识别二维码查看详情`
  String get scanOrCodeForDetail {
    return Intl.message(
      '识别二维码查看详情',
      name: 'scanOrCodeForDetail',
      desc: '',
      args: [],
    );
  }

  /// `分享自`
  String get shareForm {
    return Intl.message(
      '分享自',
      name: 'shareForm',
      desc: '',
      args: [],
    );
  }

  /// `分享功能需使用访问您的`
  String get shareImageNeedInvite {
    return Intl.message(
      '分享功能需使用访问您的',
      name: 'shareImageNeedInvite',
      desc: '',
      args: [],
    );
  }

  /// `照片`
  String get photo {
    return Intl.message(
      '照片',
      name: 'photo',
      desc: '',
      args: [],
    );
  }

  /// `文件存储`
  String get fileStorage {
    return Intl.message(
      '文件存储',
      name: 'fileStorage',
      desc: '',
      args: [],
    );
  }

  /// `暂不授权`
  String get noPermission {
    return Intl.message(
      '暂不授权',
      name: 'noPermission',
      desc: '',
      args: [],
    );
  }

  /// `去授权`
  String get goPermission {
    return Intl.message(
      '去授权',
      name: 'goPermission',
      desc: '',
      args: [],
    );
  }

  /// `卡片样式`
  String get shareCarStyle {
    return Intl.message(
      '卡片样式',
      name: 'shareCarStyle',
      desc: '',
      args: [],
    );
  }

  /// `Freadhub样式`
  String get shareCarStyleApp {
    return Intl.message(
      'Freadhub样式',
      name: 'shareCarStyleApp',
      desc: '',
      args: [],
    );
  }

  /// `掘金样式`
  String get shareCarStyleJueJin {
    return Intl.message(
      '掘金样式',
      name: 'shareCarStyleJueJin',
      desc: '',
      args: [],
    );
  }

  /// `截图失败,请开启访问存储权限`
  String get shotFailed {
    return Intl.message(
      '截图失败,请开启访问存储权限',
      name: 'shotFailed',
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
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
