import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/dialog/basis_dialog.dart';
import 'package:flutter_readhub/enum/share_card_style.dart';
import 'package:flutter_readhub/enum/share_type.dart';
import 'package:flutter_readhub/helper/path_helper.dart';
import 'package:flutter_readhub/helper/save_image_helper.dart';
import 'package:flutter_readhub/helper/share_helper.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/page/home_page.dart';
import 'package:flutter_readhub/util/adaptive.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/share_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/share_view_model.dart';
import 'package:flutter_readhub/widget/capture_image_widget.dart';
import 'package:flutter_readhub/widget/lifecycle_widget.dart';
import 'package:flutter_readhub/widget/share_widget.dart';

///卡片分享页面-链接
class CardShareDialog extends BasisDialog implements WidgetLifecycleObserver {
  ///展示卡片分享
  static show(BuildContext context, CardShareModel model) async {
    if (PlatformUtil.isWindows || PlatformUtil.isBrowser) {
      ShareHelper.singleton.shareTextToClipboard(model.text!);
      return;
    }
    LogUtil.v('CardShareDialog_context:$context');
    DialogUtil.showModalBottomSheetDialog(
      context,
      settings: RouteSettings(name: 'card_share_dialog'),
      childOutside: true,
      child: CardShareDialog(model),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54.withOpacity(0.2),
    );
  }

  CardShareDialog(this.model, {Key? key});

  ///分享实体
  final CardShareModel model;

  ///Freadhub分享样式 key
  static GlobalKey _globalKey = GlobalKey();

  ///掘金分享样式key
  static GlobalKey _globalJueJinKey = GlobalKey();

  ///保存文件帮助类
  static SaveImageHelper _saveImageHelper = SaveImageHelper();

  @override
  double get maxWidth => smallDisplay ? double.infinity : 460;

  @override
  double? get elevation => 0;

  @override
  EdgeInsets? get insetPadding => smallDisplay
      ? EdgeInsets.only(top: kToolbarHeight + tabHeight)
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
  bool get modalBottomSheet => true;

  ///检测底部高度
  final ValueNotifier<double> _bottomHeight = ValueNotifier(200);

  final GlobalKey _bottomKey = GlobalKey();

  @override
  Widget? get child => Builder(
        builder: (context) {
          ///延迟等待控件渲染完毕再进行测量
          Future.delayed(
            Duration(milliseconds: 300),
            () {
              double bottomHeight = _bottomKey.currentContext!.size!.height;
              if (bottomHeight != _bottomHeight.value) {
                _bottomHeight.value = bottomHeight;
              }
            },
          );
          return BasisProviderWidget<ShareCardStyleViewModel>(
            model: ShareCardStyleViewModel(),
            builder: (context, styleModel, child) => Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<double>(
                  valueListenable: _bottomHeight,
                  builder: (context, height, child) => ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height -
                          insetPadding!.top -
                          insetPadding!.bottom -
                          height,
                    ),
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: LifecycleWidget(
                        child: styleModel.shareCardStyle == ShareCardStyle.app
                            ? CaptureImageAppStyleWidget(
                                model.title,
                                model.summary,
                                model.notice,
                                model.url,
                                model.bottomNotice,
                                _globalKey,
                                summaryWidget: model.summaryWidget,
                              )
                            : CaptureImageWidget(
                                model.url,
                                _globalJueJinKey,
                                title: model.title,
                                summary: model.summary,
                                summaryWidget: model.summaryWidget,
                              ),
                        observer: this,
                      ),
                    ),
                  ),
                ),

                ///保证操作栏在最底部
                ShareBottomWidget(
                  key: _bottomKey,
                  model: ShareBottomViewModel(),
                  safeAreaBottom: smallDisplay,
                  onClick: (type, ctx) => _share(type, styleModel, ctx),
                ),
              ],
            ),
          );
        },
      );

  ///开始分享
  _share(ShareType type, ShareCardStyleViewModel styleModel,
      BuildContext context) async {
    ///复制链接
    if (type == ShareType.copyLink) {
      ShareHelper.singleton.shareTextToClipboard(model.url);
      return;

      ///浏览器打开
    } else if (type == ShareType.browser) {
      ShareHelper.singleton.shareTextOpenByBrowser(model.url);
      return;

      ///卡片模式
    } else if (type == ShareType.icon) {
      _chooseCardStyle(styleModel);
      return;
    }
    String _imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
    String? _filePath = await _saveImageHelper.saveImage(
        navigatorKey.currentContext!,
        styleModel.shareCardStyle == ShareCardStyle.gold
            ? _globalJueJinKey
            : _globalKey,
        _imageName);

    LogUtil.v('CardSharePage_filePath:$_filePath');
    if (TextUtil.isEmpty(_filePath)) {
      ToastUtil.show(StringHelper.getS()!.shotFailed);
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    final rect = box!.localToGlobal(Offset.zero) & box.size;
    switch (type) {

      ///微信好友
      case ShareType.weChatFriend:
        ShareUtil.shareImagesToWeChatFriend([_filePath!], rect: rect);
        break;

      ///微信朋友圈
      case ShareType.weChatTimeLine:
        ShareUtil.shareImagesToWeChatTimeLine([_filePath!], rect: rect);
        break;

      ///QQ好友
      case ShareType.qqFriend:
        ShareUtil.shareImagesToQQFriend([_filePath!], rect: rect);
        break;

      ///微博内容
      case ShareType.weiBoTimeLine:
        ShareUtil.shareImagesToWeiBoTimeLine(
          [_filePath!],
          text: model.text,
          subject: StringHelper.getS()!.saveImageShareTip,
          rect: rect,
        );
        break;

      ///钉钉
      case ShareType.dingTalk:
        ShareUtil.shareImagesToDingTalk([_filePath!], rect: rect);
        break;

      ///企业微信
      case ShareType.weWork:
        ShareUtil.shareImagesToWeWork([_filePath!], rect: rect);
        break;

      ///所有可选
      case ShareType.more:
        ShareUtil.shareImages(
          [_filePath!],
          text: model.text,
          subject: StringHelper.getS()!.saveImageShareTip,
          rect: rect,
        );
        break;
    }
  }

  ///切换卡片模式
  _chooseCardStyle(ShareCardStyleViewModel styleModel) async {
    int checkIndex = styleModel.shareCardStyle == ShareCardStyle.app ? 0 : 1;
    await styleModel.setShareCardStyle(
      checkIndex == 1 ? ShareCardStyle.app : ShareCardStyle.gold,
    );
    ToastUtil.show(
      styleModel.shareCardStyle == ShareCardStyle.app
          ? StringHelper.getS()!.shareCarStyleApp
          : StringHelper.getS()!.shareCarStyleJueJin,
    );
  }

  @override
  void didChangeWidgetLifecycleState(WidgetLifecycleState state) async {
    ///销毁时清空截图
    if (WidgetLifecycleState.beforeDestroyed == state) {
      ///清空下载视频本地文件夹所有数据
      Directory directory = Directory(await PathHelper.getShareImage());

      if (directory.existsSync()) {
        ///递归删除所有相关文件
        directory.deleteSync(recursive: true);
      }
    }
  }
}
