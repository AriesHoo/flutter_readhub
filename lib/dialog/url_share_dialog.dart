import 'package:flutter/material.dart';
import 'package:flutter_readhub/dialog/basis_dialog.dart';
import 'package:flutter_readhub/dialog/card_share_dialog.dart';
import 'package:flutter_readhub/enum/share_type.dart';
import 'package:flutter_readhub/helper/share_helper.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/util/adaptive.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/util/share_util.dart';
import 'package:flutter_readhub/view_model/share_view_model.dart';
import 'package:flutter_readhub/widget/share_widget.dart';

///webView分享url dialog
class UrlShareDialog extends BasisDialog {
  ///打开分享dialog
  static start(CardShareModel model) {
    DialogUtil.showModalBottomSheetDialog(
      navigatorKey.currentContext!,
      settings: RouteSettings(name: 'url_share_dialog'),
      childOutside: true,
      child: UrlShareDialog(model: model),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54.withOpacity(0.2),
    );
  }

  UrlShareDialog({
    Key? key,
    required this.model,
  });

  ///分享实体
  final CardShareModel model;

  @override
  double get maxWidth => smallDisplay ? double.infinity : 480;

  @override
  double? get elevation => 0;

  @override
  EdgeInsets? get insetPadding =>
      smallDisplay ? EdgeInsets.zero : super.insetPadding;

  @override
  ShapeBorder? get shape => RoundedRectangleBorder(
        borderRadius: smallDisplay
            ? BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              )
            : BorderRadius.circular(12),
      );

  @override
  AlignmentGeometry get alignment =>
      smallDisplay ? Alignment.bottomCenter : Alignment.bottomRight;

  @override
  bool get modalBottomSheet => true;

  @override
  Widget? get kid => ShareBottomWidget<ShareTextViewModel>(
        model: ShareTextViewModel(),
        safeAreaBottom: smallDisplay,
        onClick: _onShareClick,
      );

  ///点击分享
  _onShareClick(type, ctx) {
    if (smallDisplay) {
      Navigator.of(navigatorKey.currentContext!).pop();
    }
    final box = ctx.findRenderObject() as RenderBox?;
    final rect = box!.localToGlobal(Offset.zero) & box.size;
    switch (type) {

      ///卡片分享
      case ShareType.card:
        CardShareDialog.show(navigatorKey.currentContext!, model);
        break;

      ///微信好友
      case ShareType.weChatFriend:
        ShareUtil.shareTextToWeChatFriend(model.text!, rect: rect);
        break;

      ///QQ好友
      case ShareType.qqFriend:
        ShareUtil.shareTextToQQFriend(model.text!, rect: rect);
        break;

      ///微博内容
      case ShareType.weiBoTimeLine:
        ShareUtil.shareTextToWeiBoTimeLine(model.text!, rect: rect);
        break;

      ///钉钉
      case ShareType.dingTalk:
        ShareUtil.shareTextToDingTalk(model.text!, rect: rect);
        break;

      ///企业微信
      case ShareType.weWork:
        ShareUtil.shareTextToWeWork(model.text!, rect: rect);
        break;

      ///复制链接
      case ShareType.copyLink:
        ShareHelper.singleton.shareTextToClipboard(model.url);
        break;

      ///浏览器打开
      case ShareType.browser:
        ShareHelper.singleton.shareTextOpenByBrowser(model.url);
        break;

      ///所有可选
      case ShareType.more:
        ShareUtil.shareText(
          model.text!,
          subject: StringHelper.getS()!.saveImageShareTip,
          rect: rect,
        );
        break;
    }
  }
}
