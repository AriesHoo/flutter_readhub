import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_readhub/enum/share_type.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/page/card_share_page.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/share_view_model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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

  ///图片分享类型
  static String get shareImageType => 'image/*';

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

  ///分享文本到粘贴板
  static void shareTextToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then(
        (value) => ToastUtil.show(StringHelper.getS()!.copyToClipboardSucceed));
  }

  ///分享网址-通过系统浏览器打开
  static void shareTextOpenByBrowser(String url) async {
    try {
      await launch(url);
    } catch (e) {
      LogUtil.v('e:$e}', tag: 'shareTextOpenByBrowser');
    }
  }

  ///分享文本到QQ
  static void shareTextToQQ(String text) {
    Share.share(
      text,
      packageName: qqPackageName,
      subject: 'shareTextToQQ',
    );
  }

  ///分享文本到QQ好友
  static void shareTextToQQFriend(String text) {
    Share.share(
      text,
      packageName: qqPackageName,
      activityName: qqFriendActivityName,
      subject: 'shareTextToQQFriend',
    );
  }

  ///分享文本到微信好友
  static void shareTextToWeChatFriend(String text) {
    Share.share(
      text,
      packageName: weChatPackageName,
      activityName: weChatFriendActivityName,
      subject: 'shareTextToWeChatFriend',
    );
  }

  ///分享文本到微博内容
  static void shareTextToWeiBoTimeLine(String text) {
    Share.share(
      text,
      packageName: weiBoPackageName,
      activityName: weiBoTimeLineActivityName,
      subject: 'shareTextToWeiBoTimeLine',
    );
  }

  ///分享文本到所有可选
  static void shareTextToAllApps(String text) {
    Share.share(
      text,
      subject: 'shareTextToAllApps',
    );
  }

  ///分享图片到QQ
  static void shareImagesToQQ(List<String> listImages) {
    Share.shareFiles(
      listImages,
      mimeTypes: [shareImageType],
      packageName: qqPackageName,
      subject: 'shareImagesToQQ',
    );
  }

  ///分享图片到QQ好友
  static void shareImagesToQQFriend(List<String> listImages) {
    Share.shareFiles(
      listImages,
      mimeTypes: [shareImageType],
      packageName: qqPackageName,
      activityName: qqFriendActivityName,
      subject: 'shareImagesToQQFriend',
    );
  }

  ///分享图片到微信好友
  static void shareImagesToWeChatFriend(List<String> listImages) {
    Share.shareFiles(
      listImages,
      mimeTypes: [shareImageType],
      packageName: weChatPackageName,
      activityName: weChatFriendActivityName,
      subject: 'shareImagesToWeChatFriend',
    );
  }

  ///分享图片到微信朋友圈
  static void shareImagesToWeChatTimeLine(List<String> listImages) {
    Share.shareFiles(
      listImages,
      mimeTypes: [shareImageType],
      packageName: weChatPackageName,
      activityName: weChatTimeLineActivityName,
      subject: 'shareImagesToWeChatTimeLine',
    );
  }

  ///分享图片到微博内容
  static void shareImagesToWeiBoTimeLine(List<String> listImages) {
    Share.shareFiles(
      listImages,
      mimeTypes: [shareImageType],
      packageName: weiBoPackageName,
      activityName: weiBoTimeLineActivityName,
      subject: 'shareImagesToWeChatTimeLine',
    );
  }

  ///分享图片到所有可选
  static void shareImagesToAllApps(List<String> listImages) {
    Share.shareFiles(
      listImages,
      mimeTypes: [shareImageType],
      subject: 'shareImagesToAllApps',
    );
  }

  ///分享url信息底部Dialog
  static void shareUrlBottomSheet(String text, CardShareModel model) async {
    return await showModalBottomSheet(
        context: (navigatorKey.currentContext)!,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Theme.of((navigatorKey.currentContext)!).cardColor,

        ///itemBuilder
        builder: (BuildContext context) {
          return ShareBottomWidget<ShareTextViewModel>(
            model: ShareTextViewModel(),
            onClick: (type) {
              Navigator.of(context).pop();
              switch (type) {

                ///卡片分享
                case ShareType.card:
                  CardSharePage.show(context, model);
                  break;

                ///微信好友
                case ShareType.weChatFriend:
                  ShareUtil.shareTextToWeChatFriend(text);
                  break;

                ///QQ好友
                case ShareType.qqFriend:
                  ShareUtil.shareTextToQQFriend(text);
                  break;

                ///微博内容
                case ShareType.weiBoTimeLine:
                  ShareUtil.shareTextToWeiBoTimeLine(text);
                  break;

                ///复制链接
                case ShareType.copyLink:
                  ShareUtil.shareTextToClipboard(text);
                  break;

                ///浏览器打开
                case ShareType.browser:
                  ShareUtil.shareTextOpenByBrowser(model.url);
                  break;

                ///所有可选
                case ShareType.more:
                  ShareUtil.shareTextToAllApps(text);
                  break;
              }
            },
          );
        });
  }

  ///分享Image底部Dialog
  static void shareImageBottomSheet(String path) async {
    List<ShareModel> list = await ShareImageViewModel().loadData();

    ///只有一个
    if (list.isEmpty || list.length == 1) {
      ShareUtil.shareImagesToAllApps([path]);
      return;
    }
    return await showModalBottomSheet(
        context: (navigatorKey.currentContext)!,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Theme.of((navigatorKey.currentContext)!).cardColor,

        ///itemBuilder
        builder: (BuildContext context) {
          return ShareBottomWidget<ShareImageViewModel>(
            model: ShareImageViewModel(),
            onClick: (type) {
              Navigator.of(context).pop();
              switch (type) {

                ///微信好友
                case ShareType.weChatFriend:
                  ShareUtil.shareImagesToWeChatFriend([path]);
                  break;

                ///微信朋友圈
                case ShareType.weChatTimeLine:
                  ShareUtil.shareImagesToWeChatTimeLine([path]);
                  break;

                ///QQ好友
                case ShareType.qqFriend:
                  ShareUtil.shareImagesToQQFriend([path]);
                  break;

                ///微博内容
                case ShareType.weiBoTimeLine:
                  ShareUtil.shareImagesToWeiBoTimeLine([path]);
                  break;

                ///所有可选
                case ShareType.more:
                  ShareUtil.shareImagesToAllApps([path]);
                  break;
              }
            },
          );
        });
  }
}
