import 'package:flutter/material.dart';
import 'package:share/share.dart';

///分享帮助类
class ShareUtil {
  ///QQ包名
  static String get qqPackageName => 'com.tencent.mobileqq';

  ///QQ-好友
  static String get qqFriendActivityName =>
      'com.tencent.mobileqq.activity.JumpActivity';

  ///微信包名
  static String get weChatPackageName => 'com.tencent.mm';

  ///微信-好友
  static String get weChatFriendActivityName =>
      'com.tencent.mm.ui.tools.ShareImgUI';

  ///微信-朋友圈
  static String get weChatTimeLineActivityName =>
      'com.tencent.mm.ui.tools.ShareToTimeLineUI';

  ///微博包名
  static String get weiBoPackageName => 'com.sina.weibo';

  ///微博内容
  static String get weiBoTimeLineActivityName =>
      'com.sina.weibo.composerinde.ComposerDispatchActivity';

  ///钉钉包名
  static String get dingTalkPackageName => "com.alibaba.android.rimet";

  /// 企业微信包名
  static String get weWorkPackageName => "com.tencent.wework";

  ///图片分享类型
  static String get shareImageType => 'image/*';

  ///视频分享类型
  static String get shareVideoType => 'video/*';

  ///音频分享类型
  static String get shareAudioType => 'audio/*';

  ///文件分享类型
  static String get shareFileType => '*/*';

  ///QQ是否安装
  static Future<bool> isQQInstall() {
    return Share.isAppInstall(qqPackageName);
  }

  ///微信是否安装
  static Future<bool> isWeChatInstall() {
    return Share.isAppInstall(weChatPackageName);
  }

  ///微博是否安装
  static Future<bool> isWeiBoInstall() {
    return Share.isAppInstall(weiBoPackageName);
  }

  ///钉钉是否安装
  static Future<bool> isDingTalkInstall() {
    return Share.isAppInstall(dingTalkPackageName);
  }

  ///企业微信是否安装
  static Future<bool> isWeWorkInstall() {
    return Share.isAppInstall(weWorkPackageName);
  }

  ///分享文本到QQ-好友、我的电脑、收藏夹
  static void shareTextToQQ(
    String text, {
    String? subject,
    String? title,
    Rect? rect,
  }) {
    shareText(
      text,
      subject: subject,
      title: title,
      packageName: qqPackageName,
      rect: rect,
    );
  }

  ///分享文本到QQ好友
  static void shareTextToQQFriend(
    String text, {
    String? subject,
    String? title,
    Rect? rect,
  }) {
    shareText(
      text,
      subject: subject,
      title: title,
      packageName: qqPackageName,
      activityName: qqFriendActivityName,
      rect: rect,
    );
  }

  ///分享文本到微信好友
  static void shareTextToWeChatFriend(
    String text, {
    String? subject,
    String? title,
    Rect? rect,
  }) {
    shareText(
      text,
      subject: subject,
      title: title,
      packageName: weChatPackageName,
      activityName: weChatFriendActivityName,
      rect: rect,
    );
  }

  ///分享文本到微博内容
  static void shareTextToWeiBoTimeLine(
    String text, {
    String? subject,
    String? title,
    Rect? rect,
  }) {
    shareText(
      text,
      subject: subject,
      title: title,
      packageName: weiBoPackageName,
      activityName: weiBoTimeLineActivityName,
      rect: rect,
    );
  }

  ///分享文本到钉钉-只会出现弹框选择好友/ding
  static void shareTextToDingTalk(
    String text, {
    String? subject,
    String? title,
    Rect? rect,
  }) {
    shareText(
      text,
      subject: subject,
      title: title ?? 'shareTextToDingTalk',
      packageName: dingTalkPackageName,
      rect: rect,
    );
  }

  ///分享文本到企业微信
  static void shareTextToWeWork(
    String text, {
    String? subject,
    String? title,
    Rect? rect,
  }) {
    shareText(
      text,
      subject: subject,
      title: title ?? 'shareTextToWeWork',
      packageName: weWorkPackageName,
      rect: rect,
    );
  }

  ///分享文本到所有可选
  static void shareText(
    String text, {
    String? subject,
    String? title,
    String? packageName,
    String? activityName,
    Rect? rect,
  }) {
    Share.share(
      text,
      subject: subject,
      title: title,
      packageName: packageName,
      activityName: activityName,
      sharePositionOrigin: rect,
    );
  }

  ///分享图片到QQ好友
  static void shareImagesToQQ(
    List<String> paths, {
    String? title,
    String? subject,
    String? text,
    Rect? rect,
  }) {
    shareFiles(
      paths,
      packageName: qqPackageName,
      title: title,
      subject: subject,
      text: text,
      rect: rect,
    );
  }

  ///分享图片到QQ好友
  static void shareImagesToQQFriend(
    List<String> paths, {
    String? title,
    String? subject,
    String? text,
    Rect? rect,
  }) {
    shareFiles(
      paths,
      packageName: qqPackageName,
      activityName: qqFriendActivityName,
      title: title,
      subject: subject,
      text: text,
      rect: rect,
    );
  }

  ///分享图片到微信好友
  static void shareImagesToWeChatFriend(
    List<String> paths, {
    String? title,
    String? subject,
    String? text,
    Rect? rect,
  }) {
    shareFiles(
      paths,
      packageName: weChatPackageName,
      activityName: weChatFriendActivityName,
      title: title,
      subject: subject,
      text: text,
      rect: rect,
    );
  }

  ///分享图片到微信朋友圈
  static void shareImagesToWeChatTimeLine(
    List<String> paths, {
    String? title,
    String? subject,
    String? text,
    Rect? rect,
  }) {
    shareFiles(
      paths,
      packageName: weChatPackageName,
      activityName: weChatTimeLineActivityName,
      title: title,
      subject: subject,
      text: text,
      rect: rect,
    );
  }

  ///分享图片到微博内容
  static void shareImagesToWeiBoTimeLine(
    List<String> paths, {
    String? title,
    String? subject,
    String? text,
    Rect? rect,
  }) {
    shareFiles(
      paths,
      packageName: weiBoPackageName,
      activityName: weiBoTimeLineActivityName,
      title: title,
      subject: subject,
      text: text,
      rect: rect,
    );
  }

  ///分享图片到钉钉
  static void shareImagesToDingTalk(
    List<String> paths, {
    String? title,
    String? subject,
    String? text,
    Rect? rect,
  }) {
    shareFiles(
      paths,
      packageName: dingTalkPackageName,
      title: title,
      subject: subject,
      text: text,
      rect: rect,
    );
  }

  ///分享图片到企业微信
  static void shareImagesToWeWork(
    List<String> paths, {
    String? title,
    String? subject,
    String? text,
    Rect? rect,
  }) {
    shareFiles(
      paths,
      packageName: weWorkPackageName,
      title: title,
      subject: subject,
      text: text,
      rect: rect,
    );
  }

  ///分享图片到
  static void shareImages(
    List<String> paths, {
    List<String>? mimeTypes,
    String? packageName,
    String? activityName,
    String? title,
    String? subject,
    String? text,
    Rect? rect,
  }) {
    shareFiles(
      paths,
      mimeTypes: mimeTypes ?? [shareImageType],
      packageName: packageName,
      activityName: activityName,
      title: title,
      subject: subject,
      text: text,
      rect: rect,
    );
  }

  ///分享文件
  ///title 为创建分享标题
  ///subject 如邮件的主题
  ///text 如邮件、微博内容的正文
  static void shareFiles(
    List<String> paths, {
    List<String>? mimeTypes,
    String? packageName,
    String? activityName,
    String? title,
    String? subject,
    String? text,
    Rect? rect,
  }) {
    Share.shareFiles(
      paths,
      mimeTypes: mimeTypes,
      packageName: packageName,
      activityName: activityName,
      title: title,
      subject: subject,
      text: text,
      sharePositionOrigin: rect,
    );
  }
}
