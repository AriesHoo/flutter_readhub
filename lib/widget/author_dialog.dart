import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_readhub/data/update_http.dart';
import 'package:flutter_readhub/generated/i18n.dart';
import 'package:flutter_readhub/util/log_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/view_model/theme_model.dart';
import 'package:flutter_readhub/view_model/update_model.dart';
import 'package:flutter_readhub/widget/home_drawer_widget.dart';
import 'package:flutter_readhub/widget/share_dialog.dart';
import 'package:flutter_share_plugin/flutter_share_plugin.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

///弹出分享提示框
Future<void> showAuthorDialog(BuildContext context) async {
  await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AuthorDialog();
    },
  );
}

///弹出颜色选择框
Future<void> showThemeDialog(BuildContext context) async {
  await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return ThemeDialog();
    },
  );
}

///弹出升级新版本Dialog
Future<void> showUpdateDialog(BuildContext context, AppUpdateInfo info,
    {bool background = false}) async {
  if (info == null || !info.buildHaveNewVersion) {
    if (!background) {
      ToastUtil.show(S.of(context).currentIsNew);
    }
    return;
  }
  int position = await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('发现新版本:${info.buildVersion}'),
        titleTextStyle: Theme.of(context).textTheme.subtitle.copyWith(
              fontSize: 18,
            ),
        content: Text(info.buildUpdateDescription),
        contentTextStyle: Theme.of(context).textTheme.subtitle.copyWith(
              fontSize: 15,
            ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              S.of(context).updateNextTime,
              style: Theme.of(context).textTheme.caption,
            ),
            onPressed: () => Navigator.of(context).pop(0),
          ),
          FlatButton(
            child: Text(
              S.of(context).updateNow,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
            onPressed: () => Navigator.of(context).pop(1),
          ),
        ],
      );
    },
  );
  if (position == 1) {
    await launch(info.buildShortcutUrl);
  }
}

///用户信息Dialog
// ignore: must_be_immutable
class AuthorDialog extends Dialog {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(context).accentColor;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///圆角
          ClipRRect(
            borderRadius: BorderRadius.circular(6),

            ///整体背景
            child: Container(
              color: Theme.of(context).cardColor,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 50),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ///顶部信息
                      TopRoundWidget(),

                      ///选择颜色主题
                      Material(
                        color: Theme.of(context).cardColor,
                        elevation: 0,
                        child: ListTile(
                          title: Text(
                            S.of(context).choiceTheme,
                            style:
                                Theme.of(context).textTheme.subtitle.copyWith(),
                          ),
                          onTap: () => showThemeDialog(context),
                          leading: Icon(
                            Icons.color_lens,
                            color: iconColor,
                          ),
                          trailing: Text(
                            ThemeModel.themeName(context),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),

                      ///意见反馈-发送邮件
                      Material(
                        color: Theme.of(context).cardColor,
                        elevation: 0,
                        child: ListTile(
                          title: Text(
                            S.of(context).feedback,
                            style:
                                Theme.of(context).textTheme.subtitle.copyWith(),
                          ),
                          onTap: () async {
                            ///发送邮件
                            await launch(
                                'mailto:AriesHoo@126.com?subject=关于Freadhub的意见反馈&body=');
                          },
                          leading: Icon(
                            Icons.mail_outline,
                            color: iconColor,
                          ),
                          trailing: Text(
                            'AriesHoo@126.com',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),

                      ///检查更新
                      UpdateWidget(),

                      ///应用分享
                      Material(
                        color: Theme.of(context).cardColor,
                        child: ListTile(
                          title: Text(
                            S.of(context).shareApp,
                            style:
                                Theme.of(context).textTheme.subtitle.copyWith(),
                          ),
                          onTap: () => showShareAppDialog(
                              context,
                              ShareDialog(
                                '分享一个还不错的 Readhub 三方客户端-Freadhub',
                                'Freadhub',
                                'AriesHoo开发\n扫码查看详情',
                                'https://www.coolapk.com/apk/${UpdateModel.packageName}',
                                S.of(context).saveImageShareTip,
                                summaryWidget: ShareAppSummaryWidget(),
                              )),
                          leading: Icon(
                            Icons.share,
                            color: iconColor,
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                        ),
                      ),

                      ///赞赏开发者
                      AppreciateWidget(),

                      ///版权申明
                      CopyrightWidget(
                        scrollController: _scrollController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

///分享app 摘要
class ShareAppSummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.title.copyWith(
              fontSize: 13,
              color: Theme.of(context).textTheme.title.color.withOpacity(0.8),
            ),
        text:
            'Freadhub 即 : Flutter 开发的 Readhub 客户端。由练习时长两月半的个人 Flutter 小学生 Aries Hoo 花费半月开发完成。'
            '\n囊括以下功能：',
        children: [
          TextSpan(
            style: Theme.of(context).textTheme.title.copyWith(
                  fontSize: 12,
                  color:
                      Theme.of(context).textTheme.title.color.withOpacity(0.8),
                  fontWeight: FontWeight.w900,
                ),
            text: '\n热门话题、科技动态、开发者、区块链四大模块'
                '\n相关聚合资讯快捷查看'
                '\n方便快捷的日间/夜间模式切换'
                '\n丰富的彩虹颜色主题/每日主题切换'
                '\n长按社会化分享预览图效果模式'
                '\n方便快捷的意见反馈入口',
          ),
          TextSpan(
              text: '\n其它功能由细心的你自己去探索。'
                  '\n如果你在使用体验上有自己独到的意见或建议,请通过意见反馈功能反馈，由衷感谢！'),
        ],
      ),
    );
  }
}

///赞赏开发
class AppreciateWidget extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();
  final SaveImageToGallery _saveImageToGallery = SaveImageToGallery();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: ExpansionTile(
        leading: Icon(
          Icons.payment,
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          S.of(context).appreciateDeveloper,
          style: Theme.of(context).textTheme.subtitle.copyWith(),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onLongPress: () =>
                      _saveImageToGallery.saveImage(context, _globalKey),
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Image.asset(
                      'assets/images/pay.png',
                      fit: BoxFit.fitWidth,
                      width: 80,
                      height: 80,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.subtitle.copyWith(
                                fontSize: 13,
                              ),
                          children: [
                            TextSpan(
                                text: '←   长按图片保存,微信扫码',
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 12,
                                )),
                            TextSpan(
                                text:
                                    '\n个人开发不易，如果您觉得Freadhub 不错，可以通过捐赠来支持一下，感谢！'),
                          ]),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

///版本声明
class CopyrightWidget extends StatelessWidget {
  final ScrollController scrollController;

  const CopyrightWidget({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: ExpansionTile(
        onExpansionChanged: (opened) {
          if (opened) {
            ///开启详情延时滚动底部
            Future.delayed(Duration(milliseconds: 200), () {
              scrollController.animateTo(
                MediaQuery.of(context).size.height,
                duration: Duration(milliseconds: 1),
                curve: Curves.easeInCirc,
              );
            });
          }
        },
        leading: Icon(
          Icons.content_copy,
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          S.of(context).appCopyright,
          style: Theme.of(context).textTheme.subtitle.copyWith(),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.subtitle.copyWith(
                        fontSize: 12,
                      ),
                  text:
                      '1、本软件为 AriesHoo 通过 Flutter 开发而成的 Readhub 三方客户端，非无码科技 Readhub 官方应用。',
                  children: [
                    TextSpan(
                      text: '所有数据来源于无码科技 Readhub ,版权归无码科技 Readhub 所有。',
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    TextSpan(
                      text: '可访问',
                    ),
                    TextSpan(
                        text: ' readhub.cn ',
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              color: Theme.of(context).accentColor,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            ///点击跳转链接
                            await launch('https://www.readhub.cn/');
                          }),
                    TextSpan(text: '了解更多。'),
                    TextSpan(
                        text:
                            '\n2、本软件开发过程中UI部分参(chao)考(xi)了 Marno 的 Kotlin 版本 Readhub+ 应用；Flutter 功能实现上借(zhao)鉴(ban)了 phoenixsky 的 Flutter 版本 玩android 应用 Fun Android ，在此由衷感谢！'),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

///颜色选择dialog
class ThemeDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                color: Theme.of(context).cardColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Wrap(
                  runSpacing: 8,
                  children: <Widget>[
                    ...ThemeModel.themeValueList.map((color) {
                      int index = ThemeModel.themeValueList.indexOf(color);
                      return Material(
                        borderRadius: BorderRadius.circular(4),
                        color: color,
                        child: InkWell(
                          onTap: () {
                            var model = Provider.of<ThemeModel>(context);
                            model.switchTheme(themeIndex: index);
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.black.withAlpha(50),
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            child: Center(
                              child: Text(
                                ThemeModel.themeName(context, i: index),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

///检查更新
class UpdateWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return BasisProviderWidget<UpdateModel>(
      model: UpdateModel(),
      builder: (context, model, child) => Material(
        color: Theme.of(context).cardColor,
        child: ListTile(
          title: Text(
            S.of(context).checkUpdate,
            style: Theme.of(context).textTheme.subtitle.copyWith(),
          ),
          onTap: model.loading
              ? null
              : () async {
                  try {
                    AppUpdateInfo info =
                        await Provider.of<UpdateModel>(context).checkUpdate();
                    showUpdateDialog(context, info);
                  } catch (e) {}
                },
          leading: Icon(
            Icons.system_update_alt,
            color: Theme.of(context).accentColor,
          ),
          trailing: model.loading
              ? CupertinoActivityIndicator(
                  radius: 8,
                )
              : Text(
                  UpdateModel.appVersion,
                  style: Theme.of(context).textTheme.caption,
                ),
        ),
      ),
    );
  }
}
