import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_readhub/generated/l10n.dart';
import 'package:flutter_readhub/helper/path_helper.dart';
import 'package:flutter_readhub/helper/permission_helper.dart';
import 'package:flutter_readhub/model/article_model.dart';
import 'package:flutter_readhub/util/dialog_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:flutter_readhub/widget/article_item_widget.dart' as prefix0;
import 'package:flutter_readhub/widget/article_item_widget.dart';
import 'package:flutter_share_plugin/flutter_share_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

///弹出分享提示框
Future<void> showShareArticleDialog(
    BuildContext context, ArticleItemModel data) async {
  await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return ShareDialog(data.title, data.getSummary(), data.getScanNote(),
          data.getUrl(), S.of(context).saveImageShareTip, data.getFileName());
    },
  );
}

///弹出分享App提示框
Future<void> showShareAppDialog(BuildContext context, Dialog dialog) async {
  await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}

///分享Dialog
// ignore: must_be_immutable
class ShareDialog extends Dialog {
  final String title;
  final String summary;
  final String notice;
  final String url;
  final String bottomNotice;
  final String fileName;
  Widget summaryWidget;

  ShareDialog(this.title, this.summary, this.notice, this.url,
      this.bottomNotice, this.fileName,
      {this.summaryWidget});

  final GlobalKey _globalKey = GlobalKey();

  ///保存图片到本地
  final SaveImageToGallery saveImageToGallery = SaveImageToGallery();

  @override
  Widget build(BuildContext context) {
    ///最外层包裹设置距离屏幕边距
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///最上边白色圆角开始
          ShotImageWidget(
            title,
            summary,
            notice,
            url,
            bottomNotice,
            _globalKey,
            summaryWidget: summaryWidget,
          ),

          ///最上边白色圆角结束
          SizedBox(
            height: 20,
          ),

          ///最底部水平分享按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                elevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                disabledElevation: 0,
                tooltip: S.of(context).share,
                backgroundColor: Colors.blue,
                splashColor: Colors.white.withAlpha(50),
                child: Icon(Icons.share),
                onPressed: () => saveImageToGallery
                    .saveImage(context, _globalKey, '/$fileName', share: true),
              ),
              SizedBox(
                width: 20,
              ),
              FloatingActionButton(
                elevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                disabledElevation: 0,
                tooltip: S.of(context).downloadImage,
                backgroundColor: Colors.red,
                splashColor: Colors.white.withAlpha(50),
                child: Icon(Icons.file_download),
                onPressed: () => saveImageToGallery
                    .saveImage(context, _globalKey, '/$fileName', share: false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///需要进行截图-RepaintBoundary包裹部分参考
///https://www.codercto.com/a/46348.html
///https://blog.csdn.net/u014449046/article/details/98471268
///https://www.cnblogs.com/wupeng88/p/10797667.html
class ShotImageWidget extends StatelessWidget {
  final String title;
  final String summary;
  final String notice;
  final String url;
  final String bottomNotice;
  final GlobalKey globalKey;
  Widget summaryWidget;

  ShotImageWidget(this.title, this.summary, this.notice, this.url,
      this.bottomNotice, this.globalKey,
      {this.summaryWidget});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.only(
            left: 20,
            top: 20,
            right: 20,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ///标题
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      title,
                      textScaleFactor: ThemeViewModel.textScaleFactor,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: prefix0.letterSpacing,
                            fontSize: 17,
                          ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),

              ///圆角分割线包裹内容开始
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),

                ///圆角线装修器
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Decorations.lineBoxBorder(
                      context,
                      left: true,
                      top: true,
                      right: true,
                      bottom: true,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ///文章摘要
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5),
                      child: SingleChildScrollView(
                        child: summaryWidget ??
                            Text(
                              summary,
                              textScaleFactor: ThemeViewModel.textScaleFactor,
                              overflow: TextOverflow.visible,
                              strutStyle: StrutStyle(
                                  forceStrutHeight: true,
                                  height: textLineHeight,
                                  leading: leading),
                              maxLines: 12,
                              style: Theme.of(context).textTheme.title.copyWith(
                                    fontSize: 13,
                                    letterSpacing: letterSpacing,
                                    color: Theme.of(context)
                                        .textTheme
                                        .title
                                        .color
                                        .withOpacity(0.8),
                                  ),
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ///扫码提示语
                        Expanded(
                          flex: 1,
                          child: Text(
                            notice,
                            textScaleFactor: ThemeViewModel.textScaleFactor,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.title.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                          ),
                        ),

                        ///右侧二维码
                        QrImage(
                          data: url,
                          padding: EdgeInsets.all(2),
                          version: QrVersions.auto,
                          size: 64,
                          foregroundColor:
                              Theme.of(context).textTheme.title.color,
                          backgroundColor: Theme.of(context).cardColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),

              ///圆角分割线包裹内容结束

              SizedBox(
                height: 6,
              ),
              Text(
                bottomNotice,
                textScaleFactor: ThemeViewModel.textScaleFactor,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: 10,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

///保存图片到系统相册
class SaveImageToGallery {
  ///已保存图片的路径
  String fileImage;
  Uint8List pngBytes;

  Future<String> getImagePath(String imageName) async {
    File fileImage = await PathHelper.getImagePath()
        .then((value) => File('$value$imageName.png'));
    return fileImage.path;
  }

  ///保存图片
  void saveImage(BuildContext context, GlobalKey globalKey, String imageName,
      {bool share: false}) async {
    if (fileImage != null && fileImage.isNotEmpty) {
      if (share) {
//        ShareExtend.share(fileImage, 'image',
//            subject: S.of(context).saveImageShareTip);
        FlutterShare.shareFileWithText(
            textContent: S.of(context).saveImageShareTip, filePath: fileImage);
      } else {
        ToastUtil.show(S.of(context).saveImageSucceedInGallery);
      }
      return;
    }

    ///直接获取读写文件权限
    if (!await PermissionHelper.checkStoragePermission()) {
      ToastUtil.show(S.of(context).saveImagePermissionFailed);
      await DialogUtil.showAlertDialog(context,
              title: Platform.isIOS ? 'Freadhub提示' : null,
              content: '分享功能需使用访问您的${Platform.isIOS ? '照片' : '文件读写'}权限',
              cancel: '暂不授权',
              ensure: '去授权')
          .then((value) {
        if (value == 1) {
          openAppSettings();
        }
      });
      return;
    }
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();

    ///弹框宽度与屏幕宽度比值避免截图出来比预览更大
    ///分辨率通过获取设备的devicePixelRatio以达到清晰度良好
    var image = await boundary.toImage(
        pixelRatio: (MediaQuery.of(context).devicePixelRatio));

    ///转二进制
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);

    ///图片数据
    pngBytes = byteData.buffer.asUint8List();

    ///保存图片到系统图库
    File saveFile = File(await getImagePath(imageName));
    bool exist = await saveFile.exists();
    LogUtil.e('fileImage_exist0:$exist');
    if (!exist) {
      await saveFile.writeAsBytes(pngBytes);
      exist = await saveFile.exists();
    }
    LogUtil.e('fileImage_exist1:$exist');
    if (exist) {
      fileImage = saveFile.absolute.path;
      LogUtil.e('fileImage:$fileImage');
      saveImage(context, globalKey, imageName, share: share);
      return;
    }
    ToastUtil.show(S.of(context).saveImageFailed);
  }
}
