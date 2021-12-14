import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_readhub/dialog/basis_dialog.dart';
import 'package:flutter_readhub/dialog/card_share_dialog.dart';
import 'package:flutter_readhub/enum/share_type.dart';
import 'package:flutter_readhub/helper/share_helper.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/util/adaptive.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/share_util.dart';
import 'package:flutter_readhub/view_model/share_view_model.dart';
import 'package:flutter_readhub/widget/qr_code.dart';
import 'package:flutter_readhub/widget/share_widget.dart';

/// 大屏分享---直接显示分享拼接文本+复制链接+复制分享文本+二维码提示手机扫码打开再分享
class TextShareDialog extends BasisDialog {
  ///展示卡片分享
  static show(BuildContext context, CardShareModel model) async {
    ///非移动端
    if (PlatformUtil.isMobile) {
      CardShareDialog.show(context, model);
      return;
    }
    DialogUtil.showModalBottomSheetDialog(
      context,
      settings: RouteSettings(name: 'text_share_dialog'),
      childOutside: true,
      child: TextShareDialog(model),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54.withOpacity(0.2),
    );
  }

  TextShareDialog(this.model, {Key? key});

  ///分享实体
  final CardShareModel model;

  @override
  double get maxWidth => smallDisplay ? double.infinity : 400;

  @override
  EdgeInsets? get insetPadding => smallDisplay
      ? EdgeInsets.only(
          top: PlatformUtil.isMobile
              ? MediaQueryData.fromWindow(window).padding.top
              : 20,
        )
      : super.insetPadding;

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
  Widget? get kid => Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '${model.text}',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: 12,
              ),

              ///二维码
              QrCode(
                data: model.url,
                size: 120,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                '手机扫码查看并分享',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              ///保证操作栏在最底部
              ShareBottomWidget(
                model: ShareTextViewModel(),
                safeAreaBottom: smallDisplay,
                onClick: (type, ctx) => _share(type, ctx),
              ),
            ],
          ),
        ),
      );

  ///开始分享
  _share(ShareType type, BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final rect = box!.localToGlobal(Offset.zero) & box.size;
    switch (type) {

      ///卡片分享
      case ShareType.card:
        CardShareDialog.show(context, model);
        break;

      ///复制分享text
      case ShareType.copyLink:
        ShareHelper.singleton.shareTextToClipboard(model.text!);
        break;

      ///浏览器打开
      case ShareType.browser:
        ShareHelper.singleton
            .shareTextOpenByBrowser(model.showUrl ?? model.url);
        break;

      ///直接调用分享text
      case ShareType.more:
        ShareUtil.shareText(
          model.text!,
          subject: appString.saveImageShareTip,
          rect: rect,
        );
        break;
    }
  }
}
