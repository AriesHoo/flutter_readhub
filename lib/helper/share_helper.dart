import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_readhub/enum/share_type.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/page/card_share_page.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/util/share_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/share_view_model.dart';
import 'package:flutter_readhub/widget/share_widget.dart';
import 'package:url_launcher/url_launcher.dart';

///分享帮助类
class ShareHelper {
  static final ShareHelper _singleton = ShareHelper._internal();

  static ShareHelper get singleton => _singleton;

  ///工厂构造函数
  factory ShareHelper() {
    return _singleton;
  }

  ///构造函数私有化，防止被误创建
  ShareHelper._internal();

  ///分享文本到粘贴板
  Future<void> shareTextToClipboard(String text) {
    return Clipboard.setData(ClipboardData(text: text)).then(
        (value) => ToastUtil.show(StringHelper.getS()!.copyToClipboardSucceed));
  }

  ///分享网址-通过系统浏览器打开
  void shareTextOpenByBrowser(String url) async {
    try {
      await launch(url);
    } catch (e) {
      LogUtil.v('e:$e}', tag: 'shareTextOpenByBrowser');
    }
  }

  ///分享url信息底部Dialog
  void shareUrlBottomSheet(String text, CardShareModel model) async {
    DialogUtil.showModalBottomSheetDialog(
      navigatorKey.currentContext!,
      settings: RouteSettings(name: 'share_url_bottom_sheet'),
      childOutside: true,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: ShareBottomWidget<ShareTextViewModel>(
        model: ShareTextViewModel(),
        onClick: (type, ctx) {
          Navigator.of(navigatorKey.currentContext!).pop();
          final box = ctx.findRenderObject() as RenderBox?;
          final rect = box!.localToGlobal(Offset.zero) & box.size;
          switch (type) {

            ///卡片分享
            case ShareType.card:
              CardSharePage.show(navigatorKey.currentContext!, model);
              break;

            ///微信好友
            case ShareType.weChatFriend:
              ShareUtil.shareTextToWeChatFriend(text, rect: rect);
              break;

            ///QQ好友
            case ShareType.qqFriend:
              ShareUtil.shareTextToQQFriend(text, rect: rect);
              break;

            ///微博内容
            case ShareType.weiBoTimeLine:
              ShareUtil.shareTextToWeiBoTimeLine(text, rect: rect);
              break;

            ///钉钉
            case ShareType.dingTalk:
              ShareUtil.shareTextToDingTalk(text, rect: rect);
              break;

            ///企业微信
            case ShareType.weWork:
              ShareUtil.shareTextToWeWork(text, rect: rect);
              break;

            ///复制链接
            case ShareType.copyLink:
              shareTextToClipboard(text);
              break;

            ///浏览器打开
            case ShareType.browser:
              shareTextOpenByBrowser(model.url);
              break;

            ///所有可选
            case ShareType.more:
              ShareUtil.shareText(
                text,
                subject: StringHelper.getS()!.saveImageShareTip,
                rect: rect,
              );
              break;
          }
        },
      ),
    );
  }

  ///分享Image底部Dialog
  void shareImageBottomSheet(String path) async {
    List<ShareModel?> list = await ShareImageViewModel().loadData();

    ///只有一个
    if (list.isEmpty || list.length == 1) {
      ShareUtil.shareImages([path]);
      return;
    }
    DialogUtil.showModalBottomSheetDialog(
      navigatorKey.currentContext!,
      settings: RouteSettings(name: 'share_image_bottom_sheet'),
      childOutside: true,
      child: ShareBottomWidget<ShareImageViewModel>(
        model: ShareImageViewModel(),
        onClick: (type, ctx) {
          Navigator.of(navigatorKey.currentContext!).pop();

          final box = ctx.findRenderObject() as RenderBox?;
          final rect = box!.localToGlobal(Offset.zero) & box.size;
          switch (type) {

            ///微信好友
            case ShareType.weChatFriend:
              ShareUtil.shareImagesToWeChatFriend([path], rect: rect);
              break;

            ///微信朋友圈
            case ShareType.weChatTimeLine:
              ShareUtil.shareImagesToWeChatTimeLine([path], rect: rect);
              break;

            ///QQ好友
            case ShareType.qqFriend:
              ShareUtil.shareImagesToQQFriend([path], rect: rect);
              break;

            ///微博内容
            case ShareType.weiBoTimeLine:
              ShareUtil.shareImagesToWeiBoTimeLine(
                [path],
                text: StringHelper.getS()!.saveImageShareTip,
                subject: StringHelper.getS()!.saveImageShareTip,
                rect: rect,
              );
              break;

            ///钉钉
            case ShareType.dingTalk:
              ShareUtil.shareImagesToDingTalk([path], rect: rect);
              break;

            ///企业微信
            case ShareType.weWork:
              ShareUtil.shareImagesToWeWork([path], rect: rect);
              break;

            ///所有可选
            case ShareType.more:
              ShareUtil.shareImages(
                [path],
                text: StringHelper.getS()!.saveImageShareTip,
                subject: StringHelper.getS()!.saveImageShareTip,
                rect: rect,
              );
              break;
          }
        },
      ),
    );
  }
}
