import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_readhub/basis/basis_highlight_view_model.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/dialog/share_dialog.dart';
import 'package:flutter_readhub/enum/share_card_style.dart';
import 'package:flutter_readhub/enum/share_type.dart';
import 'package:flutter_readhub/helper/path_helper.dart';
import 'package:flutter_readhub/helper/save_image_helper.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/model/share_model.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/util/share_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/share_view_model.dart';
import 'package:flutter_readhub/widget/capture_image_widget.dart';
import 'package:flutter_readhub/widget/lifecycle_widget.dart';

///卡片分享页面-链接
class CardSharePage extends StatelessWidget implements WidgetLifecycleObserver {
  ///展示卡片分享
  static show(BuildContext context, CardShareModel model) {
    DialogUtil.showModalBottomSheetDialog(
      context,
      child: CardSharePage(model),
    );
    return;
    Navigator.push(
      context,
      CupertinoPageRoute(
        settings: RouteSettings(name: 'card_share_page'),
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return CardSharePage(model);
        },
      ),
    );
  }

  final CardShareModel model;

  const CardSharePage(this.model, {Key? key}) : super(key: key);

  static GlobalKey _globalKey = GlobalKey();
  static GlobalKey _globalJueJinKey = GlobalKey();
  static SaveImageHelper _saveImageHelper = SaveImageHelper();

  @override
  Widget build(BuildContext context) {
    return BasisProviderWidget<ShareCardStyleViewModel>(
      model: ShareCardStyleViewModel(),
      builder: (context, styleModel, child) => Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight * 0.5),
          child: Center(
            child: LifecycleWidget(
              child: styleModel.shareCardStyle == ShareCardStyle.app
                  ? ShotImageWidget(
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
        bottomNavigationBar: ShareBottomWidget(
          model: ShareBottomViewModel(),
          onClick: (type) => _share(
              type,
              styleModel.shareCardStyle == ShareCardStyle.gold
                  ? _globalJueJinKey
                  : _globalKey),
          styleViewModel: styleModel,
        ),
      ),
    );
  }

  ///开始分享
  _share(ShareType type, GlobalKey key) async {
    ///复制链接
    if (type == ShareType.copyLink) {
      ShareUtil.shareTextToClipboard(model.url);
      return;

      ///浏览器打开
    } else if (type == ShareType.browser) {
      ShareUtil.shareTextOpenByBrowser(model.url);
      return;
    }
    String _imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
    String? _filePath = await _saveImageHelper.saveImage(
        navigatorKey.currentContext!, key, _imageName);

    LogUtil.v('CardSharePage_filePath:$_filePath');
    if (TextUtil.isEmpty(_filePath)) {
      ToastUtil.show(StringHelper.getS()!.shotFailed);
      return;
    }
    switch (type) {

      ///微信好友
      case ShareType.weChatFriend:
        ShareUtil.shareImagesToWeChatFriend([_filePath!]);
        break;

      ///微信朋友圈
      case ShareType.weChatTimeLine:
        ShareUtil.shareImagesToWeChatTimeLine([_filePath!]);
        break;

      ///QQ好友
      case ShareType.qqFriend:
        ShareUtil.shareImagesToQQFriend([_filePath!]);
        break;

      ///微博内容
      case ShareType.weiBoTimeLine:
        ShareUtil.shareImagesToWeiBoTimeLine([_filePath!]);
        break;

      ///所有可选
      case ShareType.more:
        ShareUtil.shareImagesToAllApps([_filePath!]);
        break;
    }
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

///分享底部
class ShareBottomWidget<A extends ShareBottomViewModel>
    extends StatelessWidget {
  final Function(ShareType)? onClick;
  final A model;
  final ShareCardStyleViewModel? styleViewModel;

  const ShareBottomWidget({
    Key? key,
    required this.model,
    this.onClick,
    this.styleViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasisListProviderWidget<ShareBottomViewModel>(
      model: model,
      builder: (context, model, child) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            styleViewModel != null
                ? ListTile(
                    title: Text(StringHelper.getS()!.shareCarStyle),
                    trailing: Text(
                      styleViewModel!.shareCardStyle == ShareCardStyle.gold
                          ? StringHelper.getS()!.shareCarStyleJueJin
                          : StringHelper.getS()!.shareCarStyleApp,
                    ),
                    onTap: () => styleViewModel!.setShareCardStyle(
                        styleViewModel!.shareCardStyle == ShareCardStyle.gold
                            ? ShareCardStyle.app
                            : ShareCardStyle.gold),
                  )
                : SizedBox(),
            ShareGridWidget(
              model.list,
              onClick: onClick,
            ),
            Divider(
              height: 0,
            ),
            CancelShare(),
          ],
        ),
      ),
    );
  }
}

///分享网格布局
class ShareGridWidget extends StatelessWidget {
  final List<ShareModel> listShare;
  final Function(ShareType)? onClick;

  const ShareGridWidget(this.listShare, {Key? key, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      physics: ClampingScrollPhysics(),
      itemCount: listShare.length,
      itemBuilder: (BuildContext context, int index) {
        return BasisProviderWidget<BasisHighlightViewModel>(
          model: BasisHighlightViewModel(),
          builder: (context, highlightModel, child) => Opacity(
            opacity: highlightModel.highlight ? 0.5 : 1,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onHighlightChanged: highlightModel.onHighlightChanged,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/share/${listShare[index].image}.png',
                    width: 52,
                    height: 52,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(listShare[index].text),
                ],
              ),
              onTap: () => onClick?.call(listShare[index].type),
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        ///纵向数量
        crossAxisCount: 4,

        ///水平单个子Widget之间间距
        mainAxisSpacing: 0.0,

        ///垂直单个子Widget之间间距
        crossAxisSpacing: 0.0,
      ),
    );
  }
}

class CancelShare extends StatelessWidget {
  const CancelShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasisProviderWidget<BasisHighlightViewModel>(
      model: BasisHighlightViewModel(),
      builder: (context, model, child) => Opacity(
        opacity: model.highlight ? 0.5 : 1,
        child: MaterialButton(
          onHighlightChanged: model.onHighlightChanged,
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          disabledElevation: 0,
          hoverElevation: 0,
          child: Text(
            StringHelper.getS()!.cancel,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
